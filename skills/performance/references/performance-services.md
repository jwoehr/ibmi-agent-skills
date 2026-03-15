# Performance Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'PERFORMANCE'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | COLLECTION_SERVICES_INFO | VIEW | V7R3M0 |

## Additional Services Used by This Skill

These services are categorized elsewhere in SERVICES_INFO but are used for performance analysis:

| Schema | Service Name | SQL Object Type | Category |
|--------|-------------|-----------------|----------|
| QSYS2 | SYSTMPSTG | VIEW | (STORAGE) |
| QSYS2 | SYSDISKSTAT | VIEW | (STORAGE) |
| QSYS2 | MEMORY_POOL | TABLE FUNCTION | (cross-cutting) |

## Service Details

### Collection Services
- **COLLECTION_SERVICES_INFO** -- Active collection configuration, library, profile, intervals, categories, retention settings, and system monitoring status

### Temporary Storage (from STORAGE category)
- **SYSTMPSTG** -- Temporary storage per bucket and per job, with current/peak/limit sizes

### Disk I/O (from STORAGE category)
- **SYSDISKSTAT** -- Elapsed disk I/O statistics per unit including read/write requests, data transferred, and busy percentage

### Memory Performance (cross-cutting)
- **MEMORY_POOL()** -- Page faults, thread transitions, tuning parameters per memory pool

## Notes

- COLLECTION_SERVICES_INFO contains a CATEGORY_LIST JSON column that can be parsed with JSON_TABLE
- SYSTMPSTG shows both named system buckets (GLOBAL_BUCKET_NAME IS NOT NULL) and per-job storage
- SYSDISKSTAT elapsed statistics require an initial baseline query to start the measurement interval
