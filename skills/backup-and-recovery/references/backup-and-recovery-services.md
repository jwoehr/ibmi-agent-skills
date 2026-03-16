# Backup & Recovery Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'BACKUP AND RECOVERY'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | MEDIA_LIBRARY_INFO | VIEW | V7R3M0 |
| QSYS2 | SAVE_FILE_INFO | VIEW | V7R3M0 |
| QSYS2 | SAVE_FILE_OBJECTS | TABLE FUNCTION | V7R3M0 |
| QSYS2 | SAVE_FILE_OBJECTS | VIEW | V7R3M0 |
| QSYS2 | TAPE_CARTRIDGE_INFO | VIEW | V7R3M0 |

## Service Details

### Views
- **SAVE_FILE_INFO** — Save file metadata: timestamps, object counts, save command, target release
- **SAVE_FILE_OBJECTS** (view) — Cross-system search of objects in all save files
- **MEDIA_LIBRARY_INFO** — Tape library device inventory, status, and configuration
- **TAPE_CARTRIDGE_INFO** — Tape cartridge status, volume IDs, and location

### Table Functions
- **SAVE_FILE_OBJECTS()** — Targeted inspection of a specific save file with filtering options
  - Parameters: SAVE_FILE, SAVE_FILE_LIBRARY, OBJECT_TYPE_FILTER, DETAILED_INFO
  - DETAILED_INFO => 'ALL' returns full object details including creation timestamps
