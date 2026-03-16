---
name: application
description: "Query and explore IBM i application objects including CL commands, data areas, data queues, programs, environment variables, exit programs, and watches via SQL services. Use when user asks about: (1) CL command attributes or discovery, (2) data area values or inventory, (3) data queue status and messages, (4) program information (ILE/OPM), (5) environment variables, (6) registered exit programs, (7) watch sessions, (8) user spaces or user indexes, or (9) replacing DSPCMD, DSPDTAARA, DSPLIB, DSPPGM commands."
---

# IBM i Application Services

Query and explore application objects on IBM i using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing application queries:

```bash
ibmi tools --tools tools/ --toolset application_default
ibmi tool list_programs --tools tools/
ibmi sql "SELECT * FROM QSYS2.PROGRAM_INFO WHERE PROGRAM_LIBRARY = 'MYLIB' FETCH FIRST 20 ROWS ONLY"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### Object Discovery
- **QSYS2.COMMAND_INFO** — CL command metadata (library, processing program, threadsafe)
- **QSYS2.PROGRAM_INFO** — ILE/OPM program details (language, activation group, size)
- **QSYS2.EXIT_PROGRAM_INFO** — Registered exit programs by exit point

### Data Objects
- **QSYS2.DATA_AREA_INFO** (view) — Broad data area search across libraries
- **QSYS2.DATA_AREA_INFO** (table function) — Targeted lookup by name
- **QSYS2.DATA_QUEUE_INFO** — Data queue status, message counts, configuration

### Runtime & Configuration
- **QSYS2.ENVIRONMENT_VARIABLE_INFO** — System and job environment variables
- **QSYS2.WATCH_INFO** — Watch/service monitor sessions
- **QSYS2.BINDING_DIRECTORY_INFO** — Binding directory entries
- **QSYS2.BOUND_MODULE_INFO** — Modules bound into ILE programs
- **QSYS2.BOUND_SRVPGM_INFO** — Service programs bound into ILE programs

### Data Interchange
- **QSYS2.DATA_QUEUE_ENTRIES** — Read data queue entries
- **QSYS2.USER_SPACE** / **USER_SPACE_INFO** — User space contents and metadata
- **QSYS2.USER_INDEX_INFO** / **USER_INDEX_ENTRIES** — User index data

## Key Capabilities

### Command Discovery
- List commands by library with processing program details
- Check threadsafe and proxy command attributes
- Find validity check programs for commands

### Program Analysis
- Inventory programs by library, type (ILE/OPM), and language
- Check activation groups and creation timestamps
- View program sizes for capacity planning

### Data Object Inspection
- Read data area values and metadata
- Monitor data queue message counts and configuration
- Browse user spaces and user indexes

### Runtime Monitoring
- List active and ended watch sessions
- Check environment variables (system vs job level)
- Review exit program registrations for security auditing

## Common Use Cases

### 1. Library Inventory
List all programs, commands, and data areas in a specific library

### 2. Data Area Lookup
Retrieve the current value of a specific data area

### 3. Data Queue Monitoring
Find data queues with the most pending messages

### 4. Environment Variable Check
List system or job-level environment variables

### 5. Exit Program Audit
Review registered exit programs for security analysis

### 6. Program Analysis
Find ILE vs OPM programs and their languages

### 7. Watch Session Monitoring
Check active watch sessions and their configuration

## CL Command Migration

| CL Command | SQL Service |
|------------|-------------|
| DSPCMD | COMMAND_INFO |
| DSPDTAARA | DATA_AREA_INFO (table function) |
| DSPPGM | PROGRAM_INFO |
| WRKREGINF | EXIT_PROGRAM_INFO / EXIT_POINT_INFO |
| WRKENVVAR | ENVIRONMENT_VARIABLE_INFO |
| WRKWCH | WATCH_INFO |

## Quick Examples

### List commands in a library
```sql
SELECT COMMAND_NAME, THREADSAFE, TEXT_DESCRIPTION
  FROM QSYS2.COMMAND_INFO
  WHERE COMMAND_LIBRARY = 'MYLIB'
  ORDER BY COMMAND_NAME;
```

### Get a data area value
```sql
SELECT DATA_AREA_NAME, DATA_AREA_VALUE
  FROM TABLE(QSYS2.DATA_AREA_INFO('MYDTAARA', '*LIBL'));
```

### Find programs by language
```sql
SELECT PROGRAM_NAME, PROGRAM_TYPE, PROGRAM_LANGUAGE, CREATION_TIMESTAMP
  FROM QSYS2.PROGRAM_INFO
  WHERE PROGRAM_LIBRARY = 'MYLIB'
  ORDER BY PROGRAM_NAME;
```

### Data queues with most messages
```sql
SELECT DATA_QUEUE_LIBRARY, DATA_QUEUE_NAME, CURRENT_MESSAGES
  FROM QSYS2.DATA_QUEUE_INFO
  ORDER BY CURRENT_MESSAGES DESC
  FETCH FIRST 20 ROWS ONLY;
```

## Pre-built Tools

The `tools/application.yaml` file provides 8 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_commands` | CL commands with library and attributes |
| `list_data_areas` | Data area inventory across libraries |
| `get_data_area_value` | Targeted data area value lookup |
| `list_data_queues` | Data queues with message counts |
| `list_environment_variables` | System and job environment variables |
| `list_programs` | ILE/OPM programs by library and type |
| `list_exit_programs` | Registered exit programs |
| `list_watches` | Watch sessions and status |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Application Services Catalog](./references/application-services.md) — All APPLICATION services
- [Application Examples](./references/application-examples.sql) — Working SQL examples
- [IBM i Services - Application](https://www.ibm.com/support/pages/ibm-i-services-sql) — IBM documentation
