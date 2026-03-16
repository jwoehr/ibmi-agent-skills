---
name: database-plan-cache
description: "Explore and manage the IBM i SQL plan cache including snapshots, event monitors, and procedure references. Use when user asks about: (1) plan cache services or procedures available, (2) plan cache snapshot files on the system, (3) plan cache event monitor status, (4) how to dump or manage the plan cache, (5) plan cache sizing or QSQSRVR job memory usage, or (6) SQL syntax for plan cache management operations."
---

# IBM i Database Plan Cache

Explore and manage the SQL plan cache including service discovery, snapshot analysis, event monitor tracking, and management procedure references.

## Available Tools

The `ibmi` CLI is the primary tool for executing plan cache queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/database-plan-cache, ~/.claude/skills/database-plan-cache

# List all plan cache tools
ibmi tools --tools "$SKILL_DIR/tools/" --toolset database_plan_cache_default

# Run a specific tool
ibmi tool list_plan_cache_services --tools "$SKILL_DIR/tools/"

# Run with parameters
ibmi tool get_plan_cache_procedure_details --tools "$SKILL_DIR/tools/" procedure_name=DUMP_PLAN_CACHE

# Ad-hoc SQL for plan cache analysis
ibmi sql "SELECT * FROM QSYS2.SERVICES_INFO WHERE SERVICE_CATEGORY = 'DATABASE-PLAN CACHE'"
```

The `ibmi-mcp-server` also provides `execute_sql` for MCP-connected agents. Plan cache CALL operations require a connection that supports write operations.

## Service Selection Guide

### Service Discovery
- **QSYS2.SERVICES_INFO** -- List all plan cache services with schema, type, and release info
- **QSYS2.SYSPARMS / SYSROUTINES** -- Procedure parameter details for plan cache procedures

### Snapshot Management
- **QSYS2.DUMP_PLAN_CACHE** (PROCEDURE) -- Snapshot entire plan cache to a file
- **QSYS2.DUMP_PLAN_CACHE_TOPN** (PROCEDURE) -- Snapshot top N most expensive queries
- **QSYS2.DUMP_PLAN_CACHE_PROPERTIES** (PROCEDURE) -- Snapshot plan cache configuration

### Event Monitors
- **QSYS2.START_PLAN_CACHE_EVENT_MONITOR** (PROCEDURE) -- Begin monitoring plan cache events
- **QSYS2.END_PLAN_CACHE_EVENT_MONITOR** (PROCEDURE) -- Stop a specific event monitor
- **QSYS2.END_ALL_PLAN_CACHE_EVENT_MONITORS** (PROCEDURE) -- Stop all event monitors

### Plan Cache Control
- **QSYS2.CHANGE_PLAN_CACHE_SIZE** (PROCEDURE) -- Resize plan cache memory
- **QSYS2.CLEAR_PLAN_CACHE** (PROCEDURE) -- Remove all cached plans

### Snapshot Import/Export
- **QSYS2.IMPORT_PC_SNAPSHOT** (PROCEDURE) -- Import a previously exported snapshot
- **QSYS2.IMPORT_PC_EVENT_MONITOR** (PROCEDURE) -- Import event monitor data
- **QSYS2.REMOVE_PC_SNAPSHOT** (PROCEDURE) -- Remove an imported snapshot
- **QSYS2.REMOVE_PC_EVENT_MONITOR** (PROCEDURE) -- Remove imported event monitor data

## Key Capabilities

### Service Discovery
- **Service catalog** -- List all 14 plan cache services with their types and minimum releases
- **Parameter reference** -- Get exact parameter names, types, and modes for any procedure
- **SQL syntax generation** -- Ready-to-use CALL statements for all common operations

### Snapshot Analysis
- **Snapshot inventory** -- Find existing plan cache snapshot files across all libraries
- **Snapshot metadata** -- Get size, row count, and creation date for a specific snapshot
- **Snapshot querying** -- Once snapshots exist, query them with ad-hoc SQL

### Plan Cache Sizing
- **QSQSRVR monitoring** -- Track memory usage of SQL server jobs that manage the plan cache
- **Resource consumption** -- CPU, disk I/O, and temporary storage per server job

### Event Monitor Tracking
- **Active monitors** -- List running database monitors including plan cache event monitors
- **Monitor output** -- Track output file locations, row counts, and data sizes

## Common Use Cases

1. **Service discovery** -- Find available plan cache management procedures
2. **Snapshot review** -- Find and examine existing plan cache snapshot files
3. **Top query analysis** -- Dump top N queries by time, then analyze the snapshot
4. **Plan cache sizing** -- Monitor QSQSRVR job memory to assess plan cache pressure
5. **Event monitoring** -- Set up and track plan cache event monitors
6. **Procedure reference** -- Get exact parameter syntax for plan cache CALL statements
7. **Cross-system comparison** -- Import snapshots from another system for comparison

## Quick Examples

### List all plan cache services
```bash
ibmi tool list_plan_cache_services --tools "$SKILL_DIR/tools/"
```

### Get procedure parameters
```bash
ibmi tool get_plan_cache_procedure_details --tools "$SKILL_DIR/tools/" procedure_name=DUMP_PLAN_CACHE_TOPN
```

### Find existing snapshots
```bash
ibmi tool list_plan_cache_snapshots --tools "$SKILL_DIR/tools/"
```

### Get management SQL syntax
```bash
ibmi tool get_plan_cache_management_sql --tools "$SKILL_DIR/tools/"
```

### Dump top 50 queries (via ad-hoc SQL)
```sql
CALL QSYS2.DUMP_PLAN_CACHE_TOPN(
  FILESCHEMA => 'MYLIB',
  FILENAME => 'PCTOP50',
  TOPN => 50,
  CATEGORY => 'TOTAL_TIME');
```

### Query a snapshot (via ad-hoc SQL)
```sql
SELECT QQJOB, QQUSER, QQUCNT, QQETIM, QQSTIM
  FROM MYLIB.PCTOP50
  ORDER BY QQETIM DESC
  FETCH FIRST 20 ROWS ONLY;
```

## Pre-built Tools

The `tools/database-plan-cache.yaml` file provides 7 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_plan_cache_services` | All plan cache services from SERVICES_INFO |
| `get_plan_cache_procedure_details` | Parameter info for a specific procedure |
| `list_plan_cache_snapshots` | Find existing snapshot files across libraries |
| `get_plan_cache_snapshot_info` | Metadata for a specific snapshot file |
| `list_plan_cache_event_monitors` | Active and inactive database monitors |
| `get_plan_cache_size_info` | QSQSRVR job memory and resource usage |
| `get_plan_cache_management_sql` | Ready-to-use CALL statements for all operations |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Plan Cache Services Catalog](./references/database-plan-cache-services.md) -- Available SQL services
- [Example SQL Patterns](./references/database-plan-cache-examples.sql) -- Working query examples
- [IBM Plan Cache](https://www.ibm.com/docs/en/i/7.5?topic=services-plan-cache-procedures) -- Procedure documentation
- [IBM DUMP_PLAN_CACHE](https://www.ibm.com/docs/en/i/7.5?topic=dp-dump-plan-cache-procedure) -- Dump procedure
- [IBM START_PLAN_CACHE_EVENT_MONITOR](https://www.ibm.com/docs/en/i/7.5?topic=sp-start-plan-cache-event-monitor-procedure) -- Event monitor procedure
