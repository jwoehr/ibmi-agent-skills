# Database Performance Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'DATABASE-PERFORMANCE'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| SYSTOOLS | ACT_ON_INDEX_ADVICE | PROCEDURE | V6R1M0 |
| QSYS2 | ACTIVE_QUERY_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | ADD_QUERY_THRESHOLD | PROCEDURE | V7R3M0 |
| QSYS2 | DATABASE_MONITOR_INFO | VIEW | V7R1M0 |
| SYSTOOLS | HARVEST_INDEX_ADVICE | PROCEDURE | V6R1M0 |
| QSYS2 | MTI_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | QUERY_SUPERVISOR | VIEW | V7R3M0 |
| SYSTOOLS | REMOVE_INDEXES | PROCEDURE | V6R1M0 |
| QSYS2 | REMOVE_QUERY_THRESHOLD | PROCEDURE | V7R3M0 |
| QSYS2 | RESET_TABLE_INDEX_STATISTICS | PROCEDURE | V6R1M0 |

## Additional Services Used by This Skill

| Schema | Service Name | SQL Object Type | Category |
|--------|-------------|-----------------|----------|
| QSYS2 | SYSINDEXSTAT | VIEW | (catalog) |
| QSYS2 | SYSMQTSTAT | VIEW | (catalog) |
| QSYS2 | SYSPARTITIONSTAT | VIEW | (cross-cutting) |

## Service Details

### Index Statistics
- **SYSINDEXSTAT** -- Index-level statistics: key columns, size, query use count, last build time, maintenance mode, validity
- **MTI_INFO()** -- Table function returning Maintained Temporary Indexes over a specific table with usage counts and sizes

### Database Monitors
- **DATABASE_MONITOR_INFO** -- Active and inactive database monitors with status, type, filters, output file locations, and row counts

### Query Supervisor
- **QUERY_SUPERVISOR** -- Query supervisor threshold rules with name, type, value, detection frequency, and scope filters

### Materialized Query Tables
- **SYSMQTSTAT** -- MQT statistics including refresh time, query/statistics use counts, size, maintenance, and isolation settings

### MTI Overhead
- **SYSPARTITIONSTAT** -- Partition-level MAINTAINED_TEMPORARY_INDEX_SIZE to find tables with high MTI overhead

### Additional Services (not covered by pre-built tools)
- **ACTIVE_QUERY_INFO()** -- Currently running queries with MTI counts and estimated metrics
- **ACT_ON_INDEX_ADVICE** -- Create indexes based on optimizer recommendations
- **HARVEST_INDEX_ADVICE** -- Collect index advice from the plan cache
- **REMOVE_INDEXES** -- Remove indexes based on criteria
- **ADD_QUERY_THRESHOLD / REMOVE_QUERY_THRESHOLD** -- Manage query supervisor thresholds
- **RESET_TABLE_INDEX_STATISTICS** -- Reset statistics counters

## Notes

- SYSINDEXSTAT includes both permanent indexes and system-managed indexes
- MTI_INFO requires specific schema and table name (no wildcard support)
- QUERY_SUPERVISOR shows thresholds defined by ADD_QUERY_THRESHOLD
- SYSMQTSTAT includes both user MQTs and system-maintained MQTs
- SYSPARTITIONSTAT MAINTAINED_TEMPORARY_INDEX_SIZE is in bytes
