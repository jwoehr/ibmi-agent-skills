---
name: database-performance
description: "Monitor IBM i database performance including index statistics, maintained temporary indexes (MTIs), database monitors, query supervisor thresholds, and materialized query tables. Use when user asks about: (1) index usage or unused indexes, (2) maintained temporary indexes and whether to create permanent indexes, (3) database monitor configuration, (4) query supervisor thresholds, (5) MQT statistics and refresh status, or (6) tables with high MTI overhead."
---

# IBM i Database Performance

Monitor database performance using index statistics, MTI analysis, database monitors, query supervisor thresholds, and materialized query table tracking.

## Available Tools

The `ibmi` CLI is the primary tool for executing database performance queries:

```bash
# List all database performance tools
ibmi tools --tools tools/ --toolset database_performance_default

# Run a specific tool
ibmi tool get_index_statistics --tools tools/

# Run with parameters
ibmi tool get_mti_info --tools tools/ schema_name=MYLIB table_name=ORDERS

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.SYSINDEXSTAT WHERE TABLE_SCHEMA = 'MYLIB' ORDER BY QUERY_USE_COUNT DESC"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### Index Analysis
- **QSYS2.SYSINDEXSTAT** -- Index-level statistics: key columns, size, usage counts, build times
- **QSYS2.MTI_INFO()** -- Maintained Temporary Indexes over a specific table

### MTI Overhead
- **QSYS2.SYSPARTITIONSTAT** -- Partition-level MTI sizes to find tables with high overhead

### Database Monitoring
- **QSYS2.DATABASE_MONITOR_INFO** -- Active and inactive database performance monitors

### Query Governance
- **QSYS2.QUERY_SUPERVISOR** -- Query supervisor threshold rules and filters

### Materialized Query Tables
- **QSYS2.SYSMQTSTAT** -- MQT refresh status, usage counts, sizes, and maintenance settings

## Key Capabilities

### Index Statistics & Optimization
- **Usage tracking** -- Query use count and last query use for each index
- **Unused detection** -- Find indexes never used by the optimizer (cleanup candidates)
- **Build history** -- Last build time, type (rebuild vs. incremental), and degree of parallelism
- **Key analysis** -- Number of key columns, column names, uniqueness, and sparseness

### Maintained Temporary Index Analysis
- **Per-table MTIs** -- List all MTIs on a specific table with usage counts and sizes
- **System-wide MTI overhead** -- Find tables with the largest MTI footprints
- **Promotion candidates** -- Identify frequently-used MTIs that should become permanent indexes

### Database Monitor Management
- **Monitor inventory** -- List all database monitors with status, type, and filters
- **Output tracking** -- Monitor file locations, row counts, and data sizes
- **Filter review** -- Job, user, and SQL code filters applied to each monitor

### Query Supervisor
- **Threshold rules** -- All defined thresholds with types, values, and detection frequency
- **Scope filters** -- Job names, users, and subsystems targeted by each threshold

### Materialized Query Table Tracking
- **Refresh status** -- Last refresh time and whether MQTs are enabled
- **Usage statistics** -- Query use count and statistics count per MQT
- **Maintenance mode** -- Immediate, deferred, or user-controlled refresh settings

## Common Use Cases

1. **Index audit** -- Review all indexes on a table to assess coverage
2. **Unused index cleanup** -- Find and remove indexes not used by the optimizer
3. **MTI promotion** -- Identify MTIs that should become permanent indexes
4. **MTI overhead** -- Find tables where MTI maintenance consumes excessive resources
5. **Monitor review** -- Check what database monitors are running and their output
6. **Threshold audit** -- Review query supervisor rules for appropriateness
7. **MQT health** -- Verify MQTs are being refreshed and used by the optimizer

## Quick Examples

### View index statistics for a library
```bash
ibmi tool get_index_statistics --tools tools/ schema_filter=MYLIB
```

### Find unused indexes
```bash
ibmi tool get_unused_indexes --tools tools/ schema_filter=MYLIB unused_days=90
```

### Check MTIs on a specific table
```bash
ibmi tool get_mti_info --tools tools/ schema_name=MYLIB table_name=ORDERS
```

### Find tables with high MTI overhead
```bash
ibmi tool get_tables_with_high_mti --tools tools/ schema_filter=MYLIB min_mti_size=1048576
```

### Review query supervisor thresholds
```bash
ibmi tool get_query_supervisor_thresholds --tools tools/
```

## Pre-built Tools

The `tools/database-performance.yaml` file provides 7 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_index_statistics` | Index usage, key columns, size, and build history |
| `get_unused_indexes` | Indexes not used by the optimizer |
| `get_mti_info` | Maintained Temporary Indexes on a specific table |
| `get_database_monitor_info` | Active and inactive database monitors |
| `get_query_supervisor_thresholds` | Query supervisor rules and filters |
| `get_mqt_statistics` | Materialized Query Table refresh and usage stats |
| `get_tables_with_high_mti` | Tables with largest MTI overhead |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Database Performance Services Catalog](./references/database-performance-services.md) -- Available SQL services
- [Example SQL Patterns](./references/database-performance-examples.sql) -- Working query examples
- [IBM SYSINDEXSTAT](https://www.ibm.com/docs/en/i/7.5?topic=services-sysindexstat-view) -- View documentation
- [IBM MTI_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-mti-info-table-function) -- Function documentation
- [IBM DATABASE_MONITOR_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-database-monitor-info-view) -- View documentation
