---
name: database-utility
description: "Manage and analyze IBM i database files, members, partitions, and objects using SQL services. Use when user asks about: (1) file inventory or file attributes in a library, (2) member or partition statistics like row counts, deleted rows, or data sizes, (3) object statistics including last used dates and sizes, (4) catalog health analysis or cross-reference checks, (5) comparing files between libraries, (6) finding objects that depend on a file, (7) validating data integrity, or (8) finding unused objects for cleanup."
---

# IBM i Database Utility

Analyze database files, members, partitions, and objects using SQL services from QSYS2, SYSTOOLS, and the OBJECT_STATISTICS table function.

## Available Tools

The `ibmi` CLI is the primary tool for executing database utility queries:

```bash
# List all database utility tools
ibmi tools --tools tools/ --toolset database_utility_default

# Run a specific tool
ibmi tool list_sysfiles --tools tools/

# Run with parameters
ibmi tool object_statistics --tools tools/ library_name=MYLIB object_type='*PGM'

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.SYSFILES WHERE SYSTEM_TABLE_SCHEMA = 'MYLIB'"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### File Inventory
- **QSYS2.SYSFILES** -- File-level attributes: type, record length, member count, CCSID, reuse deleted records

### Partition & Member Statistics
- **QSYS2.SYSPARTITIONSTAT** -- Partition-level: row counts, deleted rows, data size, I/O operations, MTI sizes
- **QSYS2.SYSMEMBERSTAT** -- Member-level: row counts, timestamps, source type, data sizes

### Object Analysis
- **QSYS2.OBJECT_STATISTICS()** -- Table function for object names, types, sizes, last used, source info

### Catalog Health
- **QSYS2.ANALYZE_CATALOG()** -- Check for constraint mismatches, orphan objects, catalog anomalies

### File Comparison & Dependencies
- **QSYS2.COMPARE_FILE()** -- Compare structure, triggers, constraints, data between two file copies
- **SYSTOOLS.RELATED_OBJECTS()** -- Find dependent views, indexes, triggers, constraints, programs

### Data Validation
- **SYSTOOLS.VALIDATE_DATA()** -- Check for invalid numeric data, truncation, encoding problems

## Key Capabilities

### File Inventory & Attributes
- **Library scan** -- List all files in a library with type, record length, CCSID
- **File properties** -- Check reuse deleted records, member count, volatility, keep in memory
- **SQL vs native** -- See both SQL names (TABLE_SCHEMA/TABLE_NAME) and system names

### Partition & Member Analysis
- **Row counts** -- Active rows, deleted rows, overflow records per partition
- **I/O metrics** -- Insert, update, delete, read operations per partition
- **MTI overhead** -- Maintained temporary index sizes per partition
- **Member timestamps** -- Create, change, save, restore, last used dates

### Object Management
- **Object inventory** -- All objects in a library with type, owner, size, description
- **Usage tracking** -- Last used timestamp and days used count
- **Source tracking** -- Source file, library, member, and last update timestamp
- **Unused detection** -- Find objects not used within a specified number of days

### Impact Analysis
- **Dependency mapping** -- All objects that reference a specific file
- **File comparison** -- Attribute-by-attribute comparison between two copies
- **Catalog validation** -- Detect inconsistencies in the SQL catalog

## Common Use Cases

1. **Library inventory** -- List all files and their attributes in a library
2. **Table health check** -- Find tables with excessive deleted rows needing reorg
3. **Impact analysis** -- Before modifying a file, find all dependent objects
4. **Environment comparison** -- Compare test vs. production file attributes
5. **Data validation** -- Verify data integrity after migration or conversion
6. **Dead code cleanup** -- Find programs and files not used in over a year
7. **Source tracking** -- Find the source member for a compiled object

## Quick Examples

### List files in a library
```bash
ibmi tool list_sysfiles --tools tools/ library_filter=MYLIB
```

### Check partition statistics
```bash
ibmi tool get_partition_statistics --tools tools/ schema_filter=MYLIB
```

### Find related objects before changing a file
```bash
ibmi tool find_related_objects --tools tools/ library_name=MYLIB file_name=CUSTMAST
```

### Find objects unused for over a year
```bash
ibmi tool find_unused_objects --tools tools/ library_name=MYLIB unused_days=365
```

### Compare files between libraries
```bash
ibmi tool compare_file --tools tools/ library1=TESTLIB file1=ORDERS library2=PRODLIB file2=ORDERS
```

## Pre-built Tools

The `tools/database-utility.yaml` file provides 9 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_sysfiles` | File inventory with attributes from SYSFILES |
| `get_partition_statistics` | Partition-level row counts, I/O, and MTI sizes |
| `get_member_statistics` | Member-level statistics and timestamps |
| `object_statistics` | Object inventory with sizes and usage tracking |
| `analyze_catalog` | Catalog health checks for a library |
| `compare_file` | Compare file attributes between two libraries |
| `find_related_objects` | Find all objects dependent on a file |
| `validate_data` | Validate data integrity in a file |
| `find_unused_objects` | Find objects not used within N days |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Database Utility Services Catalog](./references/database-utility-services.md) -- Available SQL services
- [Example SQL Patterns](./references/database-utility-examples.sql) -- Working query examples
- [IBM SYSFILES](https://www.ibm.com/docs/en/i/7.5?topic=services-sysfiles-view) -- View documentation
- [IBM SYSPARTITIONSTAT](https://www.ibm.com/docs/en/i/7.5?topic=services-syspartitionstat-view) -- View documentation
- [IBM OBJECT_STATISTICS](https://www.ibm.com/docs/en/i/7.5?topic=services-object-statistics-table-function) -- Function documentation
