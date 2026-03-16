# Db2 for i SQL Patterns

Common query patterns for working with IBM i SQL services and catalog views.

## Table Function Invocation

Many IBM i services are table functions (UDTFs), not views. They require the `TABLE()` wrapper.

```sql
-- Correct: TABLE() wrapper with correlation name
SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) X

-- Correct: with named parameters
SELECT JOB_NAME, CPU_TIME
  FROM TABLE(QSYS2.ACTIVE_JOB_INFO(
    SUBSYSTEM_LIST_FILTER => 'QBATCH',
    DETAILED_INFO => 'ALL'
  )) X

-- WRONG: missing TABLE() wrapper — will error
SELECT * FROM QSYS2.ACTIVE_JOB_INFO()
```

Check `SQL_OBJECT_TYPE` in SERVICES_INFO to know if something is a TABLE FUNCTION vs VIEW:

```sql
SELECT SERVICE_NAME, SQL_OBJECT_TYPE
  FROM QSYS2.SERVICES_INFO
  WHERE SERVICE_NAME = 'ACTIVE_JOB_INFO'
```

## UDTF Filter Parameters vs WHERE Clause

For UDTFs with built-in filter parameters, always prefer them over WHERE clauses. The filter parameters are processed internally and are significantly faster.

```sql
-- GOOD: filter parameter (fast — processed before result set is built)
SELECT * FROM TABLE(QSYS2.JOB_INFO(
  JOB_STATUS_FILTER => '*ACTIVE',
  JOB_USER_FILTER => 'MYUSER'
)) X

-- BAD: WHERE on unfiltered UDTF (slow — builds entire result set first)
SELECT * FROM TABLE(QSYS2.JOB_INFO()) X
WHERE JOB_STATUS = '*ACTIVE' AND AUTHORIZATION_NAME = 'MYUSER'
```

To discover available filter parameters for a UDTF, check its EXAMPLE in the catalog:

```sql
SELECT EXAMPLE FROM QSYS2.SERVICES_INFO
  WHERE SERVICE_NAME = 'JOB_INFO'
```

## FETCH FIRST Pattern

IBM i views and table functions can return millions of rows. Always limit results.

```sql
-- Basic limit
SELECT * FROM QSYS2.NETSTAT_INFO
  ORDER BY BYTES_SENT_REMOTELY DESC
  FETCH FIRST 20 ROWS ONLY

-- With a parameterized limit in tool YAML
SELECT JOB_NAME, CPU_TIME
  FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) X
  ORDER BY CPU_TIME DESC
  FETCH FIRST :limit ROWS ONLY
```

## Optional Filter Pattern

Use this pattern for parameters that may or may not be provided. When the parameter is empty, the filter is bypassed.

```sql
-- Empty string means "no filter"
WHERE (:filter = '' OR COLUMN_NAME = UPPER(:filter))

-- Special value means "no filter"
WHERE (:status = '*ALL' OR JOB_STATUS = :status)

-- Pattern matching with optional filter
WHERE (:name_filter = '' OR UPPER(TABLE_NAME) LIKE UPPER(:name_filter))
```

With NULLIF for UDTFs that accept NULL to mean "no filter":

```sql
SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO(
  SUBSYSTEM_LIST_FILTER => NULLIF(:subsystem, '')
)) X
```

## Case-Insensitive Matching

IBM i object names are stored uppercase. Always use `UPPER()` for user-supplied values.

```sql
-- Match regardless of input case
WHERE TABLE_SCHEMA = UPPER(:schema_name)
WHERE JOB_NAME LIKE UPPER('%' CONCAT :keyword CONCAT '%')

-- CONCAT for pattern building (no || operator in some contexts)
WHERE UPPER(SERVICE_NAME) LIKE '%' CONCAT UPPER(:keyword) CONCAT '%'
```

## JOIN Patterns

### Standard JOIN (catalog views)

```sql
-- SYSTABLES + SYSTABLESTAT for table metadata with statistics
SELECT T.TABLE_NAME, T.TABLE_TYPE, T.TABLE_TEXT,
       S.NUMBER_ROWS, S.DATA_SIZE, S.LAST_USED_TIMESTAMP
  FROM QSYS2.SYSTABLES T
  INNER JOIN QSYS2.SYSTABLESTAT S
    ON T.TABLE_SCHEMA = S.TABLE_SCHEMA
   AND T.TABLE_NAME = S.TABLE_NAME
  WHERE T.TABLE_SCHEMA = UPPER(:schema_name)
```

### LEFT JOIN (when statistics may not exist)

```sql
-- Views won't have SYSTABLESTAT entries
SELECT T.TABLE_NAME, T.TABLE_TYPE,
       S.NUMBER_ROWS, S.DATA_SIZE
  FROM QSYS2.SYSTABLES T
  LEFT JOIN QSYS2.SYSTABLESTAT S
    ON T.TABLE_SCHEMA = S.TABLE_SCHEMA
   AND T.TABLE_NAME = S.TABLE_NAME
  WHERE T.TABLE_SCHEMA = UPPER(:schema_name)
```

### LATERAL JOIN (with table functions)

Use LATERAL when you need to pass a column value from one table to a table function:

```sql
-- Get job log for each active job
SELECT A.JOB_NAME, L.MESSAGE_ID, L.MESSAGE_TEXT
  FROM TABLE(QSYS2.ACTIVE_JOB_INFO(
    SUBSYSTEM_LIST_FILTER => 'QBATCH'
  )) A,
  LATERAL (
    SELECT MESSAGE_ID, MESSAGE_TEXT
      FROM TABLE(QSYS2.JOBLOG_INFO(A.JOB_NAME))
      ORDER BY MESSAGE_TIMESTAMP DESC
      FETCH FIRST 5 ROWS ONLY
  ) L
```

## Aggregate-then-Drill-Down Pattern

Start with a summary to understand the landscape, then drill into specifics.

```sql
-- Step 1: Aggregate — how many jobs per subsystem?
SELECT SUBSYSTEM, COUNT(*) AS JOB_COUNT
  FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) X
  GROUP BY SUBSYSTEM
  ORDER BY JOB_COUNT DESC

-- Step 2: Drill down — details for the busiest subsystem
SELECT JOB_NAME, CPU_TIME, TEMPORARY_STORAGE
  FROM TABLE(QSYS2.ACTIVE_JOB_INFO(
    SUBSYSTEM_LIST_FILTER => 'QBATCH'
  )) X
  ORDER BY CPU_TIME DESC
  FETCH FIRST 20 ROWS ONLY
```

Another example with service categories:

```sql
-- Step 1: Category counts
SELECT SERVICE_CATEGORY, COUNT(*) AS CNT
  FROM QSYS2.SERVICES_INFO
  GROUP BY SERVICE_CATEGORY
  ORDER BY CNT DESC

-- Step 2: Services in a specific category
SELECT SERVICE_NAME, SQL_OBJECT_TYPE, EXAMPLE
  FROM QSYS2.SERVICES_INFO
  WHERE SERVICE_CATEGORY = 'WORK MANAGEMENT'
  ORDER BY SERVICE_NAME
```

## Error Handling

### Common SQLSTATEs and Codes

| SQLCODE | SQLSTATE | Meaning | Fix |
|---------|----------|---------|-----|
| SQL0204 | 42704 | Object not found | Check object/view exists: `ibmi tables SCHEMA` |
| SQL0206 | 42703 | Column not found | Check actual columns: `ibmi columns SCHEMA TABLE` |
| SQL0418 | 42610 | Parameter marker misuse | Cannot use `:param` in CAST, CHAR, or type functions directly |
| SQL0443 | 38501 | Trigger/function error | Feature not configured (e.g., Db2 Mirror not set up) |
| SQL0551 | 42501 | Not authorized | User lacks authority to the object |
| SQL0666 | 57055 | SQL not allowed | SQL not allowed in this context (e.g., trigger body) |
| SQL0952 | 57014 | Query timed out | Add FETCH FIRST or filter parameters to narrow results |

### Diagnosis Workflow

```bash
# SQL0206 — Column not found: check actual columns
ibmi columns QSYS2 <view_name>

# SQL0204 — Object not found: check if it exists
ibmi sql "SELECT SERVICE_NAME FROM QSYS2.SERVICES_INFO WHERE SERVICE_NAME = '<name>'"

# Unknown service: search by keyword
ibmi sql "SELECT SERVICE_NAME, SQL_OBJECT_TYPE FROM QSYS2.SERVICES_INFO WHERE UPPER(SERVICE_NAME) LIKE '%KEYWORD%'"
```

## System vs SQL Naming

IBM i has two naming conventions. Always use SQL naming in queries.

| Convention | Separator | Example | Usage |
|-----------|-----------|---------|-------|
| SQL naming | `.` (dot) | `QSYS2.JOB_INFO` | Default for SQL statements |
| System naming | `/` (slash) | `QSYS2/JOB_INFO` | CL commands, some APIs |

When using PARSE_STATEMENT, specify the naming convention:

```sql
SELECT * FROM TABLE(QSYS2.PARSE_STATEMENT(
  SQL_STATEMENT => :sql,
  NAMING => '*SQL'    -- or '*SYS' for system naming
)) AS P
```

## CCSID Considerations

IBM i uses CCSID (Coded Character Set Identifier) for character encoding. Common values:

| CCSID | Description |
|-------|-------------|
| 37 | EBCDIC US/Canada (default for system objects) |
| 65535 | Binary / no conversion |
| 1200 | UTF-16 (used by graphic/DBCLOB columns) |
| 1208 | UTF-8 |

When querying columns with different CCSIDs, Db2 handles conversion automatically in most cases. Watch for:

- **CCSID 65535 columns**: May need explicit CAST for proper display
- **Mixed CCSID joins**: Ensure compatible CCSIDs or use CAST

```sql
-- Check CCSID of columns in a table
SELECT COLUMN_NAME, CCSID
  FROM QSYS2.SYSCOLUMNS
  WHERE TABLE_SCHEMA = 'MYLIB'
    AND TABLE_NAME = 'MYFILE'
    AND CCSID IS NOT NULL

-- Cast to ensure proper encoding
SELECT CAST(COLUMN_NAME AS VARCHAR(100) CCSID 1208)
  FROM MYLIB.MYFILE
```

## String Concatenation

Use `CONCAT` (not `||`) for maximum compatibility across SQL naming modes:

```sql
-- Preferred: CONCAT keyword
SELECT 'SELECT * FROM ' CONCAT :schema CONCAT '.' CONCAT :table

-- Also works: double-pipe operator
SELECT 'SELECT * FROM ' || :schema || '.' || :table
```

## LISTAGG for Comma-Separated Lists

Useful for building dynamic column lists or aggregating values:

```sql
-- Build a column list from SYSCOLUMNS
SELECT LISTAGG(COLUMN_NAME, ', ')
       WITHIN GROUP (ORDER BY ORDINAL_POSITION)
  FROM QSYS2.SYSCOLUMNS
  WHERE TABLE_SCHEMA = 'QSYS2'
    AND TABLE_NAME = 'SYSTABLES'
    AND HIDDEN = 'N'
```
