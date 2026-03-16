---
name: backup-and-recovery
description: "Query and analyze IBM i backup and recovery resources including save files, save file contents, media libraries, and tape cartridges via SQL services. Use when user asks about: (1) save file history or contents, (2) finding where an object was saved, (3) media library device status, (4) tape cartridge inventory, (5) backup verification, or (6) replacing DSPSAVF, WRKTAP, WRKMLBRM commands."
---

# IBM i Backup & Recovery

Query and analyze backup resources on IBM i using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing backup queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/backup-and-recovery, ~/.claude/skills/backup-and-recovery

ibmi tools --tools "$SKILL_DIR/tools/" --toolset backup_and_recovery_default
ibmi tool get_save_file_info --tools "$SKILL_DIR/tools/"
ibmi sql "SELECT * FROM QSYS2.SAVE_FILE_INFO FETCH FIRST 10 ROWS ONLY"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### Save File Analysis
- **QSYS2.SAVE_FILE_INFO** — Save file metadata (timestamps, object counts, commands used)
- **QSYS2.SAVE_FILE_OBJECTS** (view) — Broad search across all save files for specific objects
- **QSYS2.SAVE_FILE_OBJECTS** (table function) — Targeted inspection of a specific save file

### Media Hardware
- **QSYS2.MEDIA_LIBRARY_INFO** — Tape library device inventory and status
- **QSYS2.TAPE_CARTRIDGE_INFO** — Tape cartridge inventory, status, and location

## Key Capabilities

### Backup Verification
- List save files with timestamps, object counts, and save commands
- Filter by save file library or source library
- Verify backup completeness and timing

### Object Recovery
- Search all save files for a specific object by name
- Find the most recent save containing a given object
- Inspect individual save file contents with type filtering

### Media Management
- Check tape library device status (varied on/off)
- Inventory tape cartridges by status, location, or volume ID
- Verify media hardware availability before backup operations

## Common Use Cases

### 1. Backup Audit
List recent save files to verify backup schedule compliance

### 2. Object Recovery Search
Find which save file contains a specific object for restore

### 3. Save File Inspection
List all objects in a specific save file before restoring

### 4. Tape Drive Status
Check tape library devices before starting a backup job

### 5. Cartridge Inventory
List available tape cartridges and their current status

## CL Command Migration

| CL Command | SQL Service |
|------------|-------------|
| DSPSAVF | SAVE_FILE_OBJECTS (table function) |
| WRKTAP | TAPE_CARTRIDGE_INFO |
| WRKMLBRM | MEDIA_LIBRARY_INFO |

## Quick Examples

### List recent save files
```sql
SELECT SAVE_FILE_LIBRARY, SAVE_FILE, SAVE_TIMESTAMP, OBJECTS_SAVED, LIBRARY_NAME
  FROM QSYS2.SAVE_FILE_INFO
  ORDER BY SAVE_TIMESTAMP DESC
  FETCH FIRST 20 ROWS ONLY;
```

### Find a saved object
```sql
SELECT SAVE_FILE_LIBRARY, SAVE_FILE, OBJECT_NAME, SAVE_TIMESTAMP
  FROM QSYS2.SAVE_FILE_OBJECTS
  WHERE OBJECT_NAME = 'MYFILE'
  ORDER BY SAVE_TIMESTAMP DESC;
```

### Check tape drive status
```sql
SELECT DEVICE_NAME, DEVICE_STATUS, RESOURCE_NAME, SERIAL_NUMBER
  FROM QSYS2.MEDIA_LIBRARY_INFO
  ORDER BY DEVICE_NAME;
```

## Pre-built Tools

The `tools/backup-and-recovery.yaml` file provides 5 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_save_file_info` | Save file metadata with timestamps and object counts |
| `get_save_file_objects_view` | Broad search across all save files |
| `get_save_file_objects_detail` | Targeted save file content inspection |
| `get_media_library_info` | Tape library device inventory |
| `get_tape_cartridge_info` | Tape cartridge status and location |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Backup Services Catalog](./references/backup-and-recovery-services.md) — All BACKUP AND RECOVERY services
- [Backup Examples](./references/backup-and-recovery-examples.sql) — Working SQL examples
- [IBM i Services - Backup](https://www.ibm.com/support/pages/ibm-i-services-sql) — IBM documentation
