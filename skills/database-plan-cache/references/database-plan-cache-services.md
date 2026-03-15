# Database Plan Cache Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'DATABASE-PLAN CACHE'`.

All 14 services are PROCEDURES (none are views or table functions).

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | CHANGE_PLAN_CACHE_SIZE | PROCEDURE | V6R1M0 |
| QSYS2 | CLEAR_PLAN_CACHE | PROCEDURE | V6R1M0 |
| QSYS2 | DUMP_PLAN_CACHE | PROCEDURE | V6R1M0 |
| QSYS2 | DUMP_PLAN_CACHE_PROPERTIES | PROCEDURE | V7R1M0 |
| QSYS2 | DUMP_PLAN_CACHE_TOPN | PROCEDURE | V6R1M0 |
| QSYS2 | DUMP_SNAP_SHOT_PROPERTIES | PROCEDURE | V7R2M0 |
| QSYS2 | END_ALL_PLAN_CACHE_EVENT_MONITORS | PROCEDURE | V6R1M0 |
| QSYS2 | END_PLAN_CACHE_EVENT_MONITOR | PROCEDURE | V6R1M0 |
| QSYS2 | IMPORT_PC_EVENT_MONITOR | PROCEDURE | V7R1M0 |
| QSYS2 | IMPORT_PC_SNAPSHOT | PROCEDURE | V7R1M0 |
| QSYS2 | REMOVE_PC_EVENT_MONITOR | PROCEDURE | V7R1M0 |
| QSYS2 | REMOVE_PC_SNAPSHOT | PROCEDURE | V7R1M0 |
| QSYS2 | REMOVE_PERFORMANCE_MONITOR | PROCEDURE | V6R1M0 |
| QSYS2 | START_PLAN_CACHE_EVENT_MONITOR | PROCEDURE | V6R1M0 |

## Procedure Parameters

### DUMP_PLAN_CACHE
Creates a snapshot of the SQL plan cache.
- `FILESCHEMA` (VARCHAR) -- Library for output file
- `FILENAME` (VARCHAR) -- Output file name
- `PLAN_IDENTIFIER` (DECIMAL) -- Optional: specific plan to dump
- `SQL_STATEMENT_TEXT_FILTER` (VARCHAR) -- Optional: filter by SQL text
- `INCLUDE_SYSTEM_QUERIES` (VARCHAR) -- Optional: include system queries
- `IASP_NAME` (VARCHAR) -- Optional: IASP name

### DUMP_PLAN_CACHE_TOPN
Snapshots the top N most expensive queries by category.
- `FILESCHEMA` (VARCHAR) -- Library for output file
- `FILENAME` (VARCHAR) -- Output file name
- `TOPN` (INTEGER) -- Number of top queries to capture
- `CATEGORY` (VARCHAR) -- Sort category: TOTAL_TIME, CPU_TIME, IO_COUNT, etc.

### DUMP_PLAN_CACHE_PROPERTIES
Snapshots plan cache configuration properties.
- `FILESCHEMA` (VARCHAR) -- Library for output file
- `FILENAME` (VARCHAR) -- Output file name

### START_PLAN_CACHE_EVENT_MONITOR
Begins monitoring plan cache events.
- `FILESCHEMA` (VARCHAR) -- Library for output file
- `FILENAME` (VARCHAR) -- Output file name
- `MONITORID` (CHAR, OUT) -- Returns the assigned monitor ID

### END_PLAN_CACHE_EVENT_MONITOR
Stops a specific plan cache event monitor.
- `MONITORID` (CHAR) -- Monitor ID to stop

### CHANGE_PLAN_CACHE_SIZE
Changes the plan cache memory allocation.
- `SIZE_IN_MEG` (INTEGER) -- New size in megabytes

### CLEAR_PLAN_CACHE
Removes entries from the plan cache.
- `QRO_HASH` (VARCHAR) -- Optional: specific query hash to clear
- `PLAN_IDENTIFIER` (DECIMAL) -- Optional: specific plan to clear

### IMPORT_PC_SNAPSHOT / IMPORT_PC_EVENT_MONITOR
Import previously exported data.
- `PLAN_CACHE_LIBRARY` (VARCHAR) -- Library containing the file
- `PLAN_CACHE_FILE` (VARCHAR) -- File name
- `IMPORTED_NAME` (CHAR) -- Name for the import

### REMOVE_PC_SNAPSHOT / REMOVE_PC_EVENT_MONITOR
Remove imported data.
- `PLAN_CACHE_LIBRARY` (VARCHAR) -- Library containing the file
- `PLAN_CACHE_FILE` (VARCHAR) -- File name

## Notes

- All plan cache services are PROCEDURES requiring CALL statements
- CALL statements require a connection that supports write operations
- The ibmi CLI read-only mode blocks CALL statements; use MCP execute_sql or direct connection
- Snapshot output files use QQQ-column naming (QQRID, QQJOB, QQUSER, QQETIM, etc.)
- Plan cache snapshot files contain 280+ columns in the database monitor format
- DUMP_PLAN_CACHE_TOPN CATEGORY values: TOTAL_TIME, CPU_TIME, IO_COUNT, TEMP_STORAGE, ROWS_FETCHED
