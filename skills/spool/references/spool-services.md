# Spool Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'SPOOL'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| SYSTOOLS | DELETE_OLD_SPOOLED_FILES | PROCEDURE | V7R3M0 |
| SYSTOOLS | GENERATE_PDF | SCALAR FUNCTION | V7R3M0 |
| QSYS2 | OUTPUT_QUEUE_ENTRIES | TABLE FUNCTION | V7R1M0 |
| QSYS2 | OUTPUT_QUEUE_ENTRIES | VIEW | V7R1M0 |
| QSYS2 | OUTPUT_QUEUE_ENTRIES_BASIC | VIEW | V7R2M0 |
| QSYS2 | OUTPUT_QUEUE_INFO | VIEW | V7R1M0 |
| SYSTOOLS | PRINTER_FILE_INFO | VIEW | V7R4M0 |
| SYSTOOLS | SPOOLED_FILE_DATA | TABLE FUNCTION | V7R3M0 |
| QSYS2 | SPOOLED_FILE_INFO | TABLE FUNCTION | V7R3M0 |

## Service Details

### Views (read-only queries)
- **OUTPUT_QUEUE_INFO** -- Output queue configuration, status, writer info, file counts
- **OUTPUT_QUEUE_ENTRIES** -- Detailed spooled file entries per output queue (51 columns)
- **OUTPUT_QUEUE_ENTRIES_BASIC** -- Lightweight spooled file listing (16 columns)
- **PRINTER_FILE_INFO** -- Printer file definitions and settings (SYSTOOLS, V7R4+)

### Table Functions (read-only with parameters)
- **OUTPUT_QUEUE_ENTRIES()** -- Parameterized output queue entry listing
- **SPOOLED_FILE_INFO()** -- Detailed spool file attributes per job
- **SPOOLED_FILE_DATA()** -- Read actual spool file text content (SYSTOOLS)

### Procedures (write operations)
- **DELETE_OLD_SPOOLED_FILES** -- Delete spool files older than a specified age (SYSTOOLS)

### Scalar Functions
- **GENERATE_PDF** -- Convert a spooled file to PDF format (SYSTOOLS)
