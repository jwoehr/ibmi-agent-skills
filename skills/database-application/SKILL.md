---
name: database-application
description: "Analyze IBM i SQL application behavior including error logs, statement parsing, SQLCODE lookups, and system limits. Use when user asks about: (1) SQL errors in applications or error log analysis, (2) most frequent SQL errors, (3) parsing SQL statements to find referenced objects, (4) looking up SQLCODE meanings, (5) properly delimiting SQL identifiers, (6) system size limits for files or indexes, or (7) objects approaching maximum capacity."
---

# IBM i Database Application

Analyze SQL application behavior including error logs, statement parsing, SQLCODE reference, SQL naming utilities, and system limit monitoring.

## Available Tools

The `ibmi` CLI is the primary tool for executing database application queries:

```bash
# List all database application tools
ibmi tools --tools tools/ --toolset database_application_default

# Run a specific tool
ibmi tool list_sql_error_log --tools tools/

# Run with parameters
ibmi tool get_sqlcode_info --tools tools/ sqlcode=-204

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.SQL_ERROR_LOG ORDER BY LOGGED_TIME DESC FETCH FIRST 10 ROWS ONLY"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### SQL Error Analysis
- **QSYS2.SQL_ERROR_LOG** -- Logged SQL errors with SQLCODE, program, statement text, timestamps
- **SYSTOOLS.SQLCODE_INFO()** -- Message ID, text, and help for a given SQLCODE

### SQL Statement Analysis
- **QSYS2.PARSE_STATEMENT()** -- Extract referenced tables, views, schemas from SQL text
- **QSYS2.DELIMIT_NAME()** -- Properly quote/delimit SQL identifiers

### System Limits
- **QSYS2.SYSLIMITS** -- Objects approaching system-defined size or capacity limits

## Key Capabilities

### SQL Error Log Analysis
- **Error listing** -- Recent SQL errors with SQLCODE, SQLSTATE, program, job, and statement text
- **Error summary** -- Aggregate error counts by SQLCODE to find the most frequent issues
- **Program filtering** -- Focus on errors from a specific program or library
- **Occurrence tracking** -- See how many times an error has occurred and when it first appeared

### SQL Statement Parsing
- **Object extraction** -- Parse a SQL statement to find all referenced tables, views, and schemas
- **Usage types** -- Determine how each object is used (SELECT, INSERT, UPDATE, etc.)
- **Static analysis** -- Analyze SQL embedded in programs without executing it

### SQLCODE Reference
- **Message lookup** -- Get the message ID, text, and detailed help for any SQLCODE
- **Diagnosis** -- Understand what a SQL error means and how to resolve it

### SQL Naming Utilities
- **Identifier delimiting** -- Determine if a name needs quoting for safe use in dynamic SQL
- **Reserved word detection** -- Identify names that conflict with SQL reserved words

### System Limit Monitoring
- **Limit inventory** -- All objects with tracked limits (file size, index size, journal, etc.)
- **Near-maximum detection** -- Find objects approaching their system-defined maximums
- **Proactive alerts** -- Identify capacity issues before they cause failures

## Common Use Cases

1. **Error investigation** -- Find SQL errors occurring in production applications
2. **Error trends** -- Identify the most frequent SQL errors across the system
3. **Impact analysis** -- Parse SQL to find all tables referenced by a statement
4. **Error diagnosis** -- Look up what an SQLCODE means and how to fix it
5. **Dynamic SQL safety** -- Determine if identifiers need delimiting
6. **Capacity monitoring** -- Find files or indexes approaching size limits
7. **Proactive maintenance** -- Alert before objects hit system maximums

## Quick Examples

### View recent SQL errors
```bash
ibmi tool list_sql_error_log --tools tools/
```

### Errors for a specific program
```bash
ibmi tool list_sql_error_log --tools tools/ program_name=MYPGM program_library=MYLIB
```

### Look up an SQLCODE
```bash
ibmi tool get_sqlcode_info --tools tools/ sqlcode=-204
```

### Parse a SQL statement
```bash
ibmi tool parse_sql_statement --tools tools/ sql_statement="SELECT * FROM MYLIB.ORDERS JOIN MYLIB.CUSTOMERS ON ORDERS.CUSTID = CUSTOMERS.ID"
```

### Find objects near capacity limits
```bash
ibmi tool get_system_limits_near_max --tools tools/ threshold_pct=75
```

## Pre-built Tools

The `tools/database-application.yaml` file provides 7 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_sql_error_log` | SQL error log entries with program and statement details |
| `get_sql_error_summary` | Error counts grouped by SQLCODE |
| `parse_sql_statement` | Extract referenced objects from SQL text |
| `get_sqlcode_info` | Look up message text for a SQLCODE |
| `delimit_name` | Check if a SQL identifier needs quoting |
| `get_system_limits` | System limit tracking for objects and jobs |
| `get_system_limits_near_max` | Objects approaching their capacity maximums |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Database Application Services Catalog](./references/database-application-services.md) -- Available SQL services
- [Example SQL Patterns](./references/database-application-examples.sql) -- Working query examples
- [IBM SQL_ERROR_LOG](https://www.ibm.com/docs/en/i/7.5?topic=services-sql-error-log-view) -- View documentation
- [IBM SYSLIMITS](https://www.ibm.com/docs/en/i/7.5?topic=services-syslimits-view) -- View documentation
- [IBM PARSE_STATEMENT](https://www.ibm.com/docs/en/i/7.5?topic=services-parse-statement-table-function) -- Function documentation
