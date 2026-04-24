---
name: ibmi
description: "Core skill for working with IBM i systems through the ibmi CLI. Covers text-to-SQL methodology, Db2 for i conventions, schema discovery, multi-system configuration, and — critically — agent scripting patterns (automatic JSON-when-piped, semantic exit codes, NDJSON streaming, dry-run planning, watch mode, multi-system workflows). Use this skill as the foundation for ANY IBM i task: running queries, exploring the database, configuring systems, writing bash/agent scripts that target IBM i, or composing pipelines that need structured output and reliable error handling."
---

# IBM i Core — CLI, Text-to-SQL, and Agent Scripting

Foundation skill for working with IBM i systems. Covers CLI usage, Db2 for i SQL conventions, and the scripting patterns that make `ibmi` a reliable building block for agent workflows, bash automation, and CI pipelines.

## Preflight

Before running any `ibmi` command, verify the CLI is installed, recent enough, and has a system configured.

```bash
command -v ibmi                  # CLI present on PATH
ibmi --version                   # expect >= 0.5 for all features in this skill
ibmi system list                 # shows configured systems and which is default
```

**If the CLI is missing**, ask the user whether to install it, then run one of:

```bash
# Recommended — daily use
npm i -g @ibm/ibmi-cli

# One-shot via npx (no install; first call is slower while npx caches)
npx -y @ibm/ibmi-cli --help
```

**If the CLI is outdated** (a flag or subcommand used below is rejected), upgrade:

```bash
npm update -g @ibm/ibmi-cli
```

**If no systems are configured**, `ibmi system list` returns no rows. Walk the user through the **System connections** section below (`ibmi system add` → `ibmi system default` → `ibmi system test`) before issuing queries. For ephemeral / CI environments, set `DB2i_HOST`, `DB2i_USER`, and `DB2i_PASS` as environment variables instead of using the config file.

Never execute destructive or mutating SQL (`INSERT/UPDATE/DELETE/CALL`, or any `--no-read-only`) without confirming scope and system with the user first.

## CLI at a glance

The CLI exposes first-class subcommands for every common discovery/execution task. Prefer them over hand-written SQL when they exist.

| Command | Purpose |
|---|---|
| `ibmi config show` | Show active configuration and file origins |
| `ibmi system list / show / add / remove / default / test` | Manage IBM i connections |
| `ibmi schemas [--filter] [--limit] [--system-schemas]` | List schemas/libraries |
| `ibmi tables <schema> [--filter] [--limit]` | List tables/views/physical files in a schema |
| `ibmi columns <schema> <table>` | Column metadata |
| `ibmi describe <lib>.<object> [--type ...]` | Generate DDL (TABLE, VIEW, INDEX, PROCEDURE, …) |
| `ibmi related <library> <object>` | Objects dependent on a database file |
| `ibmi validate <sql>` | Syntax check + referenced-object existence |
| `ibmi sql "..." [--file] [--limit] [--no-read-only] [--dry-run]` | Execute SQL |
| `ibmi tool <name> --tools <path> [--dry-run]` | Run a YAML-defined tool |
| `ibmi tools --tools <path> [--toolset <name>]` | List YAML tools |
| `ibmi toolsets --tools <path>` | List toolsets |
| `ibmi completion [bash\|zsh\|fish]` | Generate shell completion |

Global flags useful on any command: `--system <name>`, `--format {table,json,csv,markdown}`, `--raw` (json shorthand), `--stream` (NDJSON), `--watch <s>`, `--output <path>`, `--no-color`.

## System connections

```bash
ibmi system list                         # Show configured systems + default
ibmi system add prod --host ... --user ...
ibmi system test prod                    # Connectivity check — use in CI
ibmi system default dev                  # Set default
ibmi --system prod sql "SELECT ..."      # Override per command
```

`ibmi config show` prints the resolved config and which file each value came from — useful when a script misbehaves because of a stale env var or config file.

## Text-to-SQL methodology

Iterate in four steps. Never guess names — always discover first.

### 1. Discover the schema

```bash
ibmi schemas                             # What libraries exist
ibmi tables QSYS2 --filter '%JOB%'       # Tables matching a pattern
ibmi columns QSYS2 ACTIVE_JOB_INFO       # Column metadata
ibmi describe QSYS2.ACTIVE_JOB_INFO      # Full DDL
```

### 2. Validate before executing

```bash
ibmi validate "SELECT JOB_NAME, CPU_TIME FROM TABLE(QSYS2.ACTIVE_JOB_INFO())"
```

For YAML tools, use `--dry-run` to see the resolved SQL without hitting the database:

```bash
ibmi tool list_active_jobs --tools "$SKILL_DIR/tools/" --dry-run
```

### 3. Start small, iterate

Begin narrow, inspect, then expand:

```bash
ibmi sql "SELECT * FROM QSYS2.JOB_QUEUE_INFO FETCH FIRST 3 ROWS ONLY"
ibmi sql "SELECT JOB_QUEUE_NAME, NUMBER_OF_JOBS FROM QSYS2.JOB_QUEUE_INFO ORDER BY NUMBER_OF_JOBS DESC FETCH FIRST 10 ROWS ONLY"
```

### 4. Search the service catalog when you don't know which view to use

```bash
# Find services by keyword
ibmi sql "SELECT SERVICE_CATEGORY, SERVICE_NAME, SQL_OBJECT_TYPE FROM QSYS2.SERVICES_INFO WHERE UPPER(SERVICE_NAME) LIKE '%JOB%' ORDER BY SERVICE_CATEGORY"

# Usage example for a known service
ibmi sql "SELECT EXAMPLE FROM QSYS2.SERVICES_INFO WHERE SERVICE_NAME = 'ACTIVE_JOB_INFO'"
```

The helper tools `search_services` and `list_service_categories` (in `tools/ibmi.yaml`) wrap these for convenience.

## Db2 for i SQL conventions

### Table functions require `TABLE()`

```sql
-- GOOD
SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO(SUBSYSTEM_LIST_FILTER => 'QBATCH')) X

-- WRONG (SQL0204 / parse error)
SELECT * FROM QSYS2.ACTIVE_JOB_INFO()
```

### Use UDTF filter parameters, not WHERE

```sql
-- GOOD: filter is pushed inside the table function
SELECT * FROM TABLE(QSYS2.JOB_INFO(
  JOB_STATUS_FILTER => '*ACTIVE',
  JOB_USER_FILTER   => 'MYUSER'))

-- BAD: scans everything, filters afterward
SELECT * FROM TABLE(QSYS2.JOB_INFO()) X
WHERE JOB_STATUS = '*ACTIVE' AND AUTHORIZATION_NAME = 'MYUSER'
```

### Always FETCH FIRST — views can return millions of rows.

### Case sensitivity — names are uppercase by default. `UPPER()` user-supplied parameters.

### Two naming conventions — SQL naming `SCHEMA.TABLE` (default) vs system naming `LIBRARY/FILE`. Use SQL naming everywhere.

### Common optional-filter pattern

```sql
WHERE (:filter = '' OR COLUMN = UPPER(:filter))
WHERE (:filter = '*ALL' OR COLUMN = UPPER(:filter))
```

## Agent & scripting best practices

The CLI is built for programmatic use: piped output auto-switches to JSON, exit codes are semantic, and `--dry-run` lets an agent plan without hitting the database.

### 1. JSON automatically when piped — no `--format json` needed

```bash
# Not a TTY → JSON output
count=$(ibmi sql "SELECT COUNT(*) AS CNT FROM SAMPLE.EMPLOYEE" | jq '.data[0].CNT')
echo "Employee count: $count"
```

Force JSON explicitly with `--raw` (or `--format json`) when you need to be certain — e.g. inside `bash -c` where stdin/stdout detection varies.

### 2. Semantic exit codes — branch logic without parsing output

| Code | Name | Meaning |
|---|---|---|
| 0 | SUCCESS | Command completed successfully |
| 1 | GENERAL | Connection failure or unexpected error |
| 2 | USAGE | Invalid arguments or missing options |
| 3 | QUERY | SQL execution error |
| 4 | SECURITY | Read-only violation or forbidden operation |
| 5 | AUTH | Authentication failure |

```bash
ibmi sql "SELECT 1 FROM SYSIBM.SYSDUMMY1" --system prod
case $? in
  0) echo "Connection OK" ;;
  1) echo "Connection failed — check host/port" ;;
  3) echo "SQL error — check query syntax" ;;
  5) echo "Auth failed — check credentials" ;;
esac
```

JSON errors also carry a machine-readable `error.code` alongside the message:

```
GENERAL_ERROR, USAGE_ERROR, CONNECTION_ERROR, QUERY_ERROR, SQL_ERROR,
SECURITY_VIOLATION, AUTH_FAILURE, NOT_FOUND, TIMEOUT
```

```bash
out=$(ibmi sql "SELECT * FROM SAMPLE.BADTABLE" 2>/dev/null)
code=$(echo "$out" | jq -r '.error.code // empty')
[ "$code" = "SQL_ERROR" ] && echo "Recognised SQL error; continuing..."
```

### 3. `--stream` for large result sets (NDJSON, one object per row)

```bash
ibmi sql "SELECT * FROM SAMPLE.EMPLOYEE" --stream | while IFS= read -r row; do
  name=$(echo "$row" | jq -r '.FIRSTNME')
  echo "Processing: $name"
done
```

`--stream` is memory-safe for multi-million-row exports and works with any SQL statement (including UDTF-backed views).

### 4. `--dry-run` for safe agent planning

`--dry-run` resolves parameters and prints the final SQL *without* opening a database connection. Use it when an agent is deciding whether to commit to a query:

```bash
# Preview SQL for a direct query
ibmi sql "SELECT * FROM SAMPLE.EMPLOYEE WHERE SALARY > 50000" --dry-run

# Preview YAML-tool SQL with bound parameters
ibmi tool monthly_report --tools ./tools.yaml --schema SAMPLE --month 3 --dry-run
```

Combine with `ibmi validate` for a no-connection "will this parse + reference real objects?" check.

### 5. `--output` writes results to a file

```bash
ibmi sql "SELECT * FROM SAMPLE.EMPLOYEE" --format csv --output /tmp/employees.csv
ibmi sql "SELECT * FROM SAMPLE.EMPLOYEE" --raw        --output /tmp/employees.json
```

### 6. `--watch <seconds>` for monitoring loops

```bash
# Sample active jobs every 10s
ibmi sql "SELECT JOB_NAME, CPU_TIME FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) WHERE JOB_STATUS='RUN'" \
  --watch 10

# Write a CSV time-series to disk
ibmi sql "SELECT * FROM TABLE(QSYS2.SYSTEM_STATUS())" \
  --format csv --output /tmp/status.csv --watch 30
```

Ctrl+C stops the loop; `--output` re-writes the file each tick (it does not append — redirect `--stream` output to append).

### 7. Multi-system workflows — `--system <name>` per command

```bash
dev_count=$(ibmi sql  "SELECT COUNT(*) AS C FROM MYLIB.ORDERS" --system dev  | jq '.data[0].C')
prod_count=$(ibmi sql "SELECT COUNT(*) AS C FROM MYLIB.ORDERS" --system prod | jq '.data[0].C')
echo "Dev: $dev_count, Prod: $prod_count"
```

### 8. Put it all together — a text-to-SQL agent step

```bash
#!/bin/bash
set -euo pipefail

SYSTEM="${IBMI_SYSTEM:-dev}"
SCHEMA="SAMPLE"
TABLE="EMPLOYEE"

# 1. Discover
ibmi tables  "$SCHEMA" --filter "${TABLE}%" --system "$SYSTEM" > /dev/null
ibmi columns "$SCHEMA" "$TABLE" --system "$SYSTEM" > /dev/null

# 2. Plan — no DB connection needed
query="SELECT EMPNO, SALARY FROM $SCHEMA.$TABLE WHERE SALARY > 50000 FETCH FIRST 100 ROWS ONLY"
ibmi validate "$query" --system "$SYSTEM"

# 3. Execute, branching on exit code
if ibmi sql "$query" --system "$SYSTEM" --raw --output ./result.json; then
  rows=$(jq '.meta.rows' ./result.json)
  echo "Retrieved $rows rows"
else
  case $? in
    3) echo "SQL error — inspect ./result.json"; exit 3 ;;
    5) echo "Auth failure — re-authenticate"; exit 5 ;;
    *) echo "Unexpected failure ($?)"; exit 1 ;;
  esac
fi
```

For deeper recipes (cross-system diffs, monitoring alert loops, a full text-to-SQL agent), see [`references/agent-scripting.md`](./references/agent-scripting.md).

### Gotchas

- **`--format` is ignored when `--output` has an extension** — the extension wins (`.csv` → CSV regardless of `--format`).
- **`--read-only` is default-on**; mutation SQL (`INSERT/UPDATE/DELETE/CALL`) requires `--no-read-only` AND a writable system entry.
- **Positional `key=value`** passed to `ibmi tool` is silently ignored. Use `--kebab-case-name <value>` — flag names come from the YAML param `name` with underscores converted to hyphens.
- **`--watch` + `--output`** rewrites the same file each tick; to build a time series pipe `--stream` to `tee -a`.
- **`ibmi tools` with no `--tools`** emits "No tools path specified" — there are no globally-installed YAML tools; every skill ships its own `tools/` directory.

## Error diagnosis cheat sheet

| SQL code | Meaning | Common fix |
|---|---|---|
| SQL0204 | Object not found | `ibmi schemas`, `ibmi tables`, or search `QSYS2.SERVICES_INFO` |
| SQL0206 | Column not found | `ibmi columns <schema> <table>` to get real column list |
| SQL0418 | Parameter marker not valid | `CAST(:param AS <type>)` in SELECT lists / UDTF arguments |
| SQL0443 | Trigger/function error | Usually feature not configured (Db2 Mirror not installed, missing authority) |
| SQL0438 | Application error | Raised by system services — read the message text |
| SQL0199 | Keyword not expected | Db2 for i dialect difference — e.g. `NULLS LAST` isn't supported; simulate with `CASE` |

## Helper YAML tools

`tools/ibmi.yaml` ships a small set of tools that go beyond what the CLI exposes natively. Native-command duplicates (`list_tables_in_schema`, `get_column_info`, `validate_query`, `sample_rows`) have been removed — use the CLI subcommand instead.

| Tool | Why it exists |
|------|---|
| `get_table_statistics` | Detailed row/deleted/I-O counters from `SYSTABLESTAT` beyond what `ibmi describe` exposes |
| `search_services` | Keyword search over `QSYS2.SERVICES_INFO` with example snippets |
| `list_service_categories` | Count of services per category — broad catalog browse |

```bash
ibmi tool get_table_statistics --tools "$SKILL_DIR/tools/" --schema-name QSYS2 --table-name SYSTABLES
ibmi tool search_services      --tools "$SKILL_DIR/tools/" --keyword JOB
ibmi tool list_service_categories --tools "$SKILL_DIR/tools/"
```

## Reference documentation

- **[Agent scripting cookbook](./references/agent-scripting.md)** — deep recipes: cross-system diff, monitoring loop, text-to-SQL agent
- [Service catalog overview](./references/ibmi-services-overview.md) — category inventory
- [SQL patterns](./references/ibmi-sql-patterns.md) — reusable query snippets
- [IBM i CLI docs (upstream)](https://ibm-d95bab6e.mintlify.app/llms.txt) — complete documentation index; key pages:
  - [CLI commands reference](https://ibm-d95bab6e.mintlify.app/cli/commands.md)
  - [Agent integration](https://ibm-d95bab6e.mintlify.app/cli/agent-integration.md)
  - [Output formats](https://ibm-d95bab6e.mintlify.app/cli/output-formats.md)
  - [YAML tools](https://ibm-d95bab6e.mintlify.app/cli/yaml-tools.md)
- [IBM i SQL Services](https://www.ibm.com/support/pages/ibm-i-services-sql) — official service reference
