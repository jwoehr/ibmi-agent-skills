---
name: ibmi
description: "Core skill for working with IBM i systems via the ibmi CLI. Provides text-to-SQL methodology, iterative querying best practices, schema discovery, and SQL validation patterns for Db2 for i. Use as the foundation for ANY IBM i task — install this skill first, then add domain-specific skills (ibmi-database, ibmi-system) as needed."
---

# IBM i Core — CLI & Text-to-SQL

Foundation skill for working with IBM i systems. Provides the iterative querying methodology, CLI usage patterns, and Db2 for i SQL conventions that all other IBM i skills build on.

## Available Tools

### ibmi CLI

The `ibmi` CLI is the primary mechanism for executing SQL and running pre-built tools. Install globally or run on demand:

```bash
# One-shot via npx (no install required)
npx -y @ibm/ibmi-cli --help

# Or install globally
npm i -g @ibm/ibmi-cli
```

```bash
# Ad-hoc SQL
ibmi sql "SELECT * FROM QSYS2.SERVICES_INFO FETCH FIRST 5 ROWS ONLY"
ibmi sql "SELECT ..." --format table     # Human-readable
ibmi sql "SELECT ..." --limit 20         # Limit rows
ibmi sql --file query.sql                # From file

# Schema exploration
ibmi schemas                             # List all schemas
ibmi tables <schema>                     # List tables/views
ibmi columns <schema> <table>            # Column metadata
ibmi describe <schema>.<object>          # Generate DDL / metadata

# Pre-built tools (from YAML files)
ibmi tools --tools <path>                # List available tools
ibmi tool <name> --tools <path>          # Execute a tool
ibmi tool <name> --tools <path> --dry-run # Preview SQL

# SQL validation
ibmi validate "SELECT ..."               # Syntax check
```

## Text-to-SQL Methodology

Follow this iterative process when answering questions that require SQL:

### Step 1: Discover the Schema

Never guess table or column names. Always discover first:

```bash
# What schemas exist?
ibmi schemas

# What tables are in a schema?
ibmi tables QSYS2
ibmi tables MYLIB

# What columns does a table have?
ibmi columns QSYS2 ACTIVE_JOB_INFO
```

### Step 2: Validate Before Executing

Always validate SQL syntax before running queries against data:

```bash
ibmi validate "SELECT JOB_NAME, CPU_TIME FROM TABLE(QSYS2.ACTIVE_JOB_INFO())"
```

For complex queries, use `--dry-run` with pre-built tools:

```bash
ibmi tool list_active_jobs --tools "$SKILL_DIR/tools/" --dry-run
```

### Step 3: Start Small, Iterate

Begin with a narrow query, inspect results, then expand:

```bash
# 1. Sample a few rows to understand the data
ibmi sql "SELECT * FROM QSYS2.JOB_QUEUE_INFO FETCH FIRST 3 ROWS ONLY"

# 2. Refine with specific columns and filters
ibmi sql "SELECT JOB_QUEUE_NAME, NUMBER_OF_JOBS, STATUS FROM QSYS2.JOB_QUEUE_INFO WHERE NUMBER_OF_JOBS > 0 ORDER BY NUMBER_OF_JOBS DESC"

# 3. Add aggregation or joins as needed
ibmi sql "SELECT JOB_QUEUE_NAME, NUMBER_OF_JOBS FROM QSYS2.JOB_QUEUE_INFO ORDER BY NUMBER_OF_JOBS DESC FETCH FIRST 10 ROWS ONLY"
```

### Step 4: Use SERVICES_INFO for Discovery

When you don't know which SQL service to use, search the catalog:

```bash
# Find services by keyword
ibmi sql "SELECT SERVICE_CATEGORY, SERVICE_NAME, SQL_OBJECT_TYPE FROM QSYS2.SERVICES_INFO WHERE UPPER(SERVICE_NAME) LIKE '%JOB%' ORDER BY SERVICE_CATEGORY"

# Get usage example for a service
ibmi sql "SELECT EXAMPLE FROM QSYS2.SERVICES_INFO WHERE SERVICE_NAME = 'ACTIVE_JOB_INFO'"

# Browse services by category
ibmi sql "SELECT SERVICE_NAME, SQL_OBJECT_TYPE FROM QSYS2.SERVICES_INFO WHERE SERVICE_CATEGORY = 'WORK MANAGEMENT' ORDER BY SERVICE_NAME"
```

## Db2 for i SQL Conventions

### Table Functions (UDTFs)

Many IBM i services are table functions, not views. Use `TABLE()` syntax:

```sql
-- Correct: TABLE() wrapper required
SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) X

-- With named parameters (preferred for UDTFs)
SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO(
  SUBSYSTEM_LIST_FILTER => 'QBATCH,QUSRWRK',
  DETAILED_INFO => 'ALL'
)) X

-- WRONG: missing TABLE() wrapper
SELECT * FROM QSYS2.ACTIVE_JOB_INFO()  -- Will error
```

### UDTF Filter Parameters vs WHERE Clause

For performance-critical UDTFs, use **filter parameters** instead of WHERE:

```sql
-- GOOD: Filter parameter (fast — processed internally)
SELECT * FROM TABLE(QSYS2.JOB_INFO(
  JOB_STATUS_FILTER => '*ACTIVE',
  JOB_USER_FILTER => 'MYUSER'
)) X

-- BAD: WHERE clause on unfiltered UDTF (slow — scans everything first)
SELECT * FROM TABLE(QSYS2.JOB_INFO()) X
WHERE JOB_STATUS = '*ACTIVE' AND AUTHORIZATION_NAME = 'MYUSER'
```

### Always FETCH FIRST

IBM i views can return millions of rows. Always limit:

```sql
SELECT * FROM QSYS2.NETSTAT_INFO
ORDER BY BYTES_SENT_REMOTELY DESC
FETCH FIRST 20 ROWS ONLY
```

### Case Sensitivity

IBM i object names are uppercase by default. Use `UPPER()` for parameters:

```sql
WHERE TABLE_SCHEMA = UPPER('mylib')   -- matches MYLIB
WHERE JOB_NAME LIKE UPPER('%batch%')  -- matches BATCH
```

### System vs SQL Naming

IBM i has two naming conventions:
- **SQL naming** (default): `SCHEMA.TABLE` (e.g., `QSYS2.JOB_INFO`)
- **System naming**: `LIBRARY/FILE` (e.g., `QSYS2/JOB_INFO`)

Always use SQL naming in queries.

## Common Patterns

### Optional Filters

Use this pattern for parameters that may or may not be provided:

```sql
WHERE (:filter = '' OR COLUMN = UPPER(:filter))
WHERE (:filter = '*ALL' OR COLUMN = UPPER(:filter))
```

### Aggregate Summaries

Summarize before drilling down:

```sql
-- First: how many jobs per subsystem?
SELECT SUBSYSTEM, COUNT(*) AS JOB_COUNT
FROM TABLE(QSYS2.ACTIVE_JOB_INFO())
GROUP BY SUBSYSTEM
ORDER BY JOB_COUNT DESC

-- Then: drill into the busiest subsystem
SELECT JOB_NAME, CPU_TIME, TEMPORARY_STORAGE
FROM TABLE(QSYS2.ACTIVE_JOB_INFO(
  SUBSYSTEM_LIST_FILTER => 'QBATCH'))
ORDER BY CPU_TIME DESC FETCH FIRST 20 ROWS ONLY
```

### Error Diagnosis

When SQL fails, check the error and adapt:

```bash
# SQL0206 = Column not found → check actual columns
ibmi columns QSYS2 <view_name>

# SQL0204 = Object not found → check if view exists
ibmi sql "SELECT SERVICE_NAME FROM QSYS2.SERVICES_INFO WHERE SERVICE_NAME = '<name>'"

# SQL0443 = Trigger/function error → usually means a feature isn't configured
# (e.g., Db2 Mirror not set up, or missing authority)
```

## Pre-built Tools

The `tools/ibmi.yaml` file provides schema discovery and SQL validation tools:

| Tool | Description |
|------|-------------|
| `list_tables_in_schema` | List tables/views in a schema with row counts |
| `get_column_info` | Get column metadata for a table |
| `validate_query` | Validate SQL syntax without executing |
| `sample_rows` | Generate sample query for a table |
| `get_table_statistics` | Table size, row count, last used |
| `search_services` | Search QSYS2.SERVICES_INFO by keyword |
| `list_service_categories` | Browse all SQL service categories |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
```

## Reference Documentation

- [IBM i SQL Services](https://www.ibm.com/support/pages/ibm-i-services-sql) — Complete service reference
- [Service Catalog](./references/ibmi-services-overview.md) — Category overview with service counts
- [SQL Patterns](./references/ibmi-sql-patterns.md) — Common query patterns and examples
