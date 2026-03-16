# Database Application Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'DATABASE-APPLICATION'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | DELIMIT_NAME | SCALAR FUNCTION | V7R1M0 |
| QSYS2 | OVERRIDE_QAQQINI | PROCEDURE | V6R1M0 |
| QSYS2 | OVERRIDE_TABLE | PROCEDURE | V6R1M0 |
| QSYS2 | PARSE_STATEMENT | TABLE FUNCTION | V7R2M0 |
| SYSIBMADM | SELFCODES | GLOBAL VARIABLE | V7R4M0 |
| QSYS2 | SQL_ERROR_LOG | VIEW | V7R4M0 |
| SYSTOOLS | SQLCODE_INFO | TABLE FUNCTION | V7R4M0 |
| SYSIBMADM | VALIDATE_SELF | SCALAR FUNCTION | V7R4M0 |
| SYSPROC | WLM_SET_CLIENT_INFO | PROCEDURE | V6R1M0 |

## Additional Services Used by This Skill

| Schema | Service Name | SQL Object Type | Category |
|--------|-------------|-----------------|----------|
| QSYS2 | SYSLIMITS | VIEW | (cross-cutting) |

## Service Details

### SQL Error Analysis
- **SQL_ERROR_LOG** -- View of logged SQL errors with SQLCODE, SQLSTATE, program, statement text, occurrence count, job, user, and timestamps
- **SQLCODE_INFO()** -- Table function returning message ID, text, and second-level help text for a given SQLCODE

### SQL Statement Analysis
- **PARSE_STATEMENT()** -- Table function that parses SQL text and returns referenced objects with schema, name, type, and usage
- **DELIMIT_NAME()** -- Scalar function that returns a properly delimited SQL identifier

### System Limits
- **SYSLIMITS** -- View tracking objects and jobs approaching system-defined size or capacity limits with current and maximum values

### Additional Services (not covered by pre-built tools)
- **OVERRIDE_QAQQINI** -- Override query attributes for the current connection
- **OVERRIDE_TABLE** -- Override a table reference for the current connection
- **SELFCODES** -- Global variable containing self-referencing SQL codes
- **VALIDATE_SELF** -- Validate self-referencing integrity
- **WLM_SET_CLIENT_INFO** -- Set workload management client information

## Notes

- SQL_ERROR_LOG requires V7R4M0 or later
- SQLCODE_INFO requires V7R4M0 or later
- PARSE_STATEMENT uses named parameter SQL_STATEMENT (not positional)
- SYSLIMITS shows both file and index limits; filter by LIMIT_CATEGORY for specific types
- STATEMENT_TEXT in SQL_ERROR_LOG is DBCLOB; cast to VARCHAR for display
