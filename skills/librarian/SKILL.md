---
name: librarian
description: "Manage and query IBM i library lists, library contents, authorization lists, and object privileges via SQL services. Use when user asks about: (1) current library list configuration, (2) library contents and object inventory, (3) authorization lists and secured objects, (4) object-level privilege details, (5) library information and sizes, (6) system vs user library list entries, (7) replacing DSPLIBL, DSPLIB, DSPAUTL, DSPOBJAUT commands, or (8) any library management task."
---

# IBM i Library & Object Management

Manage and query library lists, library contents, authorization lists, and object privileges using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing library queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/librarian, ~/.claude/skills/librarian

ibmi tools --tools "$SKILL_DIR/tools/" --toolset librarian_default
ibmi tool get_library_list --tools "$SKILL_DIR/tools/"
ibmi sql "SELECT * FROM QSYS2.LIBRARY_LIST_INFO ORDER BY ORDINAL_POSITION"
```

## Service Selection Guide

### Library List
- **QSYS2.LIBRARY_LIST_INFO** -- Current job library list (system, product, current, user)

### Library & Object Information
- **QSYS2.OBJECT_STATISTICS()** -- Object details: size, owner, type, timestamps
- **QSYS2.OBJECT_PRIVILEGES** -- Authority details for any object

### Authorization Lists
- **QSYS2.AUTHORIZATION_LIST_INFO** -- Objects secured by authorization lists
- **QSYS2.AUTHORIZATION_LIST_USER_INFO** -- User authorities on authorization lists

## Key Capabilities

### Library List Management
- **Complete List** -- View full library list with ordinal positions
- **Type Filtering** -- Filter by SYSTEM, PRODUCT, CURRENT, or USER entries
- **Library Details** -- Size, owner, creation date, last used date

### Object Inventory
- **Library Contents** -- List all objects in a library with type filtering
- **Object Statistics** -- Size, attribute, timestamps, and owner info
- **Pattern Matching** -- Find libraries matching a name pattern

### Authorization Lists
- **List Discovery** -- Find all authorization lists and their secured objects
- **User Authorities** -- See who has what level of access on each list
- **Privilege Details** -- Granular authority breakdown (read/add/update/delete/execute)

### Object Privileges
- **Authority Audit** -- Check all users and their authorities on a specific object
- **Granular Permissions** -- Object operational, management, existence, alter, reference

## Common Use Cases

1. **Library list review** -- Check current system and user library list entries
2. **Object inventory** -- List files, programs, or other objects in a library
3. **Library sizing** -- Check library size and object counts
4. **Authorization audit** -- Review authorization list configurations
5. **Privilege check** -- Verify object-level authorities for a specific object
6. **Library comparison** -- Compare system vs user library list entries

## Quick Examples

### View library list
```bash
ibmi tool get_library_list --tools "$SKILL_DIR/tools/"
```

### System libraries only
```bash
ibmi tool get_library_list_by_type --tools "$SKILL_DIR/tools/" --list-type SYSTEM
```

### Objects in a library
```bash
ibmi tool list_library_objects --tools "$SKILL_DIR/tools/" --library-name QGPL
```

### Check object privileges
```bash
ibmi tool get_object_privileges --tools "$SKILL_DIR/tools/" --object-schema QSYS --object-name QGPL --object-type '*LIB'
```

## Pre-built Tools

The `tools/librarian.yaml` file provides 7 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_library_list` | Complete library list with ordinal positions |
| `get_library_list_by_type` | Library list entries filtered by type |
| `get_library_info` | Detailed library information via OBJECT_STATISTICS |
| `list_library_objects` | Objects in a library with optional type filter |
| `list_authorization_lists` | Authorization lists and secured objects |
| `list_authorization_list_users` | User authorities on authorization lists |
| `get_object_privileges` | Object-level privilege details |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Librarian Services Catalog](./references/librarian-services.md) -- Available SQL services
- [Example SQL Patterns](./references/librarian-examples.sql) -- Working query examples
- [IBM LIBRARY_LIST_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-library-list-info-view) -- View documentation
- [IBM OBJECT_STATISTICS](https://www.ibm.com/docs/en/i/7.5?topic=services-object-statistics-table-function) -- Table function documentation
