# Agent Scripting Cookbook

Deeper recipes for using the `ibmi` CLI from bash, agents, and CI pipelines. The core patterns (JSON auto-switch, exit codes, `--stream`, `--dry-run`, `--watch`, `--system`) are covered in the parent SKILL.md — this file collects worked examples that compose them.

## Table of contents

1. [Safe defaults for scripts](#safe-defaults-for-scripts)
2. [Parsing JSON and NDJSON results](#parsing-json-and-ndjson-results)
3. [Error-handling idioms](#error-handling-idioms)
4. [Cross-system diff](#cross-system-diff)
5. [Monitoring loop with threshold alerting](#monitoring-loop-with-threshold-alerting)
6. [Full text-to-SQL agent](#full-text-to-sql-agent)
7. [CI: gate a deploy on a post-deploy query](#ci-gate-a-deploy-on-a-post-deploy-query)
8. [Streaming bulk exports](#streaming-bulk-exports)

---

## Safe defaults for scripts

```bash
#!/usr/bin/env bash
set -euo pipefail          # fail fast, catch undefined vars, propagate pipeline errors
export NO_COLOR=1          # plain JSON when piped anyway, but keeps logs clean
IBMI_SYSTEM="${IBMI_SYSTEM:-dev}"   # allow caller to override
```

Always prefer `--raw` over relying on piped auto-JSON when the next stage is not obviously a pipe (e.g. inside `$()` captured across lines, or when using `tee`). It costs nothing and removes a failure mode.

---

## Parsing JSON and NDJSON results

A successful response always has this shape:

```json
{
  "ok": true,
  "system": "dev",
  "host": "...",
  "command": "execute_sql",
  "data": [ { "COL": "value", ... }, ... ],
  "meta": { "rows": 42, "hasMore": false, "elapsed_ms": 123 }
}
```

Common `jq` idioms:

```bash
# Scalar from the first row
value=$(ibmi sql "SELECT X FROM T" | jq -r '.data[0].X')

# Length / bail if empty
rows=$(ibmi sql "..." | jq '.data | length')
[ "$rows" -eq 0 ] && { echo "no rows"; exit 0; }

# Tab-separated for downstream pipelines
ibmi sql "SELECT A, B, C FROM T" \
  | jq -r '.data[] | [.A, .B, .C] | @tsv'

# Error code + message pair
ibmi sql "SELECT * FROM BADTABLE" 2>/dev/null \
  | jq -r '"\(.error.code): \(.error.message)"'
```

NDJSON (`--stream`) has no envelope — each line is a data row:

```bash
ibmi sql "SELECT JOB_NAME, CPU_TIME FROM TABLE(QSYS2.ACTIVE_JOB_INFO())" --stream \
  | jq -s 'sort_by(-.CPU_TIME)[0:5]'    # top 5 CPU consumers
```

---

## Error-handling idioms

Route exit codes, then fall back to the JSON error object:

```bash
run_sql() {
  local out rc
  out=$(ibmi sql "$1" --raw 2>/dev/null); rc=$?
  if [ "$rc" -eq 0 ]; then printf '%s' "$out"; return 0; fi
  local code msg
  code=$(printf '%s' "$out" | jq -r '.error.code   // "UNKNOWN"')
  msg=$( printf '%s' "$out" | jq -r '.error.message // "(no message)"')
  case "$rc" in
    3)  echo "SQL error [$code]: $msg"   >&2 ;;
    5)  echo "Auth failure [$code]: $msg" >&2 ;;
    *)  echo "Exit $rc [$code]: $msg"    >&2 ;;
  esac
  return "$rc"
}

run_sql "SELECT 1 FROM SYSIBM.SYSDUMMY1" | jq .
```

Retry only the conditions worth retrying (transient network, `AUTH_FAILURE` after token refresh). Don't retry `SQL_ERROR` — the query is wrong.

---

## Cross-system diff

Compare row counts (or any scalar) across two systems and exit non-zero on divergence:

```bash
#!/usr/bin/env bash
set -euo pipefail

table="${1:-MYLIB.ORDERS}"

dev=$(ibmi sql "SELECT COUNT(*) AS C FROM $table" --system dev  | jq '.data[0].C')
prd=$(ibmi sql "SELECT COUNT(*) AS C FROM $table" --system prod | jq '.data[0].C')

printf 'dev=%s prod=%s\n' "$dev" "$prd"
[ "$dev" = "$prd" ] || { echo "ROW COUNT DIVERGENCE" >&2; exit 2; }
```

For a deeper structural diff, run `ibmi describe LIB.TABLE` on both systems and `diff` the DDL.

---

## Monitoring loop with threshold alerting

`--watch` ticks a single query. Wrap it with `--stream` for per-tick JSON output you can filter:

```bash
# Alert when any job holds > 80% CPU
ibmi sql "SELECT JOB_NAME, ELAPSED_CPU_PERCENTAGE
            FROM TABLE(QSYS2.ACTIVE_JOB_INFO())
           WHERE ELAPSED_CPU_PERCENTAGE > 80" \
  --watch 15 --raw \
  | jq -c --unbuffered '.data[] | select(.ELAPSED_CPU_PERCENTAGE > 80)' \
  | while read -r row; do
      job=$(jq -r '.JOB_NAME' <<<"$row")
      cpu=$(jq -r '.ELAPSED_CPU_PERCENTAGE' <<<"$row")
      echo "[ALERT] $(date -u +%FT%TZ) job=$job cpu=${cpu}%"
      # post to Slack / PagerDuty / etc. here
    done
```

If you only need the latest tick on disk for a dashboard, use `--output` instead of streaming.

---

## Full text-to-SQL agent

A single script that discovers schema, plans a query, validates it, and only then executes:

```bash
#!/usr/bin/env bash
set -euo pipefail

SYSTEM="${IBMI_SYSTEM:-dev}"
SCHEMA="$1"
TABLE="$2"
PREDICATE="${3:-1=1}"

# 1. Confirm objects exist (no-op if they don't — validate will fail later)
ibmi tables  "$SCHEMA" --filter "${TABLE}%" --system "$SYSTEM" > /dev/null
cols=$(ibmi columns "$SCHEMA" "$TABLE" --system "$SYSTEM" \
       | jq -r '.data[].COLUMN_NAME' | paste -sd, -)
[ -z "$cols" ] && { echo "no columns for $SCHEMA.$TABLE"; exit 2; }

# 2. Compose + validate offline
query="SELECT $cols FROM $SCHEMA.$TABLE WHERE $PREDICATE FETCH FIRST 100 ROWS ONLY"
ibmi validate "$query" --system "$SYSTEM" > /dev/null

# 3. Preview (no DB hit) before committing
echo "About to run:"
ibmi sql "$query" --system "$SYSTEM" --dry-run | jq -r '.data[0].sql // "(not a dry-run-shaped payload)"'

# 4. Execute
ibmi sql "$query" --system "$SYSTEM" --raw --output ./result.json
rows=$(jq '.meta.rows' ./result.json)
echo "Retrieved $rows rows into ./result.json"
```

Invoke: `./agent.sh SAMPLE EMPLOYEE "SALARY > 50000"`.

---

## CI: gate a deploy on a post-deploy query

```yaml
# .github/workflows/smoke.yml (excerpt)
- name: Post-deploy smoke
  env:
    DB2i_HOST: ${{ secrets.IBMI_HOST }}
    DB2i_USER: ${{ secrets.IBMI_USER }}
    DB2i_PASS: ${{ secrets.IBMI_PASS }}
  run: |
    npx -y @ibm/ibmi-cli system add ci --host "$DB2i_HOST" --user "$DB2i_USER" --port 8076
    ibmi --system ci system test
    # Deploy marker row must be <60s old
    ibmi --system ci sql "SELECT TIMESTAMPDIFF(2, CURRENT_TIMESTAMP - DEPLOY_TS) AS AGE
                            FROM MYLIB.DEPLOY_HEALTH
                           ORDER BY DEPLOY_TS DESC FETCH FIRST 1 ROWS ONLY" \
      | jq -e '.data[0].AGE < 60' > /dev/null
```

The job fails with a useful exit code (3 = SQL, 5 = auth, etc.) that a CI system can surface directly.

---

## Streaming bulk exports

`--stream` is the safe choice for multi-million-row exports — it never buffers the full result set into JSON:

```bash
# Append an NDJSON audit trail
ibmi sql "SELECT * FROM TABLE(SYSTOOLS.AUDIT_JOURNAL_AF(STARTING_TIMESTAMP =>
           CURRENT_TIMESTAMP - 24 HOURS))" --stream \
  | tee -a /var/log/ibmi/audit-$(date +%F).ndjson \
  | jq -c 'select(.SEVERITY >= 40)'

# CSV export for analytics tools
ibmi sql "SELECT * FROM MYLIB.HISTORY" \
  --format csv --output /data/history-$(date +%F).csv
```

For recurring exports, combine with `cron` / systemd timers — `ibmi system test` at job start is a cheap way to fail fast when the target system is down.
