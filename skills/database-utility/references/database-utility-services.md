# Database Utility Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'DATABASE-UTILITY'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | ANALYZE_CATALOG | TABLE FUNCTION | V7R3M0 |
| QSYS2 | CANCEL_SQL | PROCEDURE | V6R1M0 |
| SYSTOOLS | CHECK_SYSCST | PROCEDURE | V7R1M0 |
| SYSTOOLS | CHECK_SYSROUTINE | PROCEDURE | V7R1M0 |
| QSYS2 | COMPARE_FILE | TABLE FUNCTION | V7R4M0 |
| QSYS2 | DUMP_SQL_CURSORS | PROCEDURE | V6R1M0 |
| QSYS2 | END_IDLE_SQE_THREADS | PROCEDURE | V7R3M0 |
| QSYS2 | EXTRACT_STATEMENTS | PROCEDURE | V6R1M0 |
| QSYS2 | FIND_AND_CANCEL_QSQSRVR_SQL | PROCEDURE | V6R1M0 |
| QSYS2 | FIND_QSQSRVR_JOBS | PROCEDURE | V6R1M0 |
| QSYS2 | GENERATE_SQL | PROCEDURE | V7R1M0 |
| QSYS2 | GENERATE_SQL_OBJECTS | PROCEDURE | V7R2M0 |
| SYSTOOLS | RELATED_OBJECTS | TABLE FUNCTION | V7R3M0 |
| QSYS2 | RESTART_IDENTITY | PROCEDURE | V6R1M0 |
| QSYS2 | SWAP_DYNUSRPRF | PROCEDURE | V7R3M0 |
| QSYS2 | SYSFILES | VIEW | V7R3M0 |
| QSYS2 | SYSMEMBERSTAT | VIEW | V7R4M0 |
| SYSTOOLS | VALIDATE_DATA | TABLE FUNCTION | V7R3M0 |

## Additional Services Used by This Skill

| Schema | Service Name | SQL Object Type | Category |
|--------|-------------|-----------------|----------|
| QSYS2 | SYSPARTITIONSTAT | VIEW | (cross-cutting) |
| QSYS2 | OBJECT_STATISTICS | TABLE FUNCTION | (cross-cutting) |

## Service Details

### File Inventory
- **SYSFILES** -- File-level attributes including type, record length, member count, CCSID, key fields, constraints, triggers

### Partition & Member Statistics
- **SYSPARTITIONSTAT** -- Partition-level row counts, deleted rows, data sizes, I/O operations, MTI sizes, timestamps
- **SYSMEMBERSTAT** -- Member-level statistics with source type, timestamps, row counts, data sizes

### Object Analysis
- **OBJECT_STATISTICS()** -- Table function for object inventory: names, types, sizes, usage, source tracking

### Catalog Health
- **ANALYZE_CATALOG()** -- Check for DBXREF constraint mismatches, orphan objects, catalog anomalies

### File Comparison
- **COMPARE_FILE()** -- Compare structure, triggers, constraints, and data between two file copies

### Dependency Analysis
- **RELATED_OBJECTS()** -- Find views, logical files, indexes, triggers, constraints, programs referencing a file

### Data Validation
- **VALIDATE_DATA()** -- Check for invalid numeric data, truncation, encoding problems in a file

## Notes

- SYSPARTITIONSTAT can timeout on `*ALL` schemas; always filter by specific schema
- OBJECT_STATISTICS supports `*ALLSIMPLE` for fast name-only listing
- COMPARE_FILE requires V7R4M0 or later
- SYSMEMBERSTAT requires V7R4M0 or later
