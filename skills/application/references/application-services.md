# Application Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'APPLICATION'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | ACTIVATION_GROUP_INFO | VIEW | V7R3M0 |
| QSYS2 | ADD_USER_INDEX_ENTRY | PROCEDURE | V7R4M0 |
| QSYS2 | BINDING_DIRECTORY_INFO | VIEW | V7R3M0 |
| QSYS2 | BOUND_MODULE_INFO | VIEW | V7R3M0 |
| QSYS2 | BOUND_SRVPGM_INFO | VIEW | V7R3M0 |
| QSYS2 | CHANGE_USER_SPACE | PROCEDURE | V7R4M0 |
| QSYS2 | CHANGE_USER_SPACE_ATTRIBUTES | PROCEDURE | V7R4M0 |
| QSYS2 | CLEAR_DATA_QUEUE | PROCEDURE | V7R4M0 |
| QSYS2 | COMMAND_INFO | VIEW | V7R3M0 |
| QSYS2 | CREATE_USER_INDEX | PROCEDURE | V7R4M0 |
| QSYS2 | CREATE_USER_SPACE | PROCEDURE | V7R4M0 |
| QSYS2 | DATA_AREA_INFO | VIEW | V7R3M0 |
| QSYS2 | DATA_AREA_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | DATA_QUEUE_ENTRIES | TABLE FUNCTION | V7R4M0 |
| QSYS2 | DATA_QUEUE_INFO | VIEW | V7R3M0 |
| QSYS2 | DB_TRANSACTION_INFO | TABLE FUNCTION | V7R5M0 |
| QSYS2 | DB_TRANSACTION_JOURNAL_INFO | TABLE FUNCTION | V7R5M0 |
| QSYS2 | DB_TRANSACTION_OBJECT_INFO | TABLE FUNCTION | V7R5M0 |
| QSYS2 | DB_TRANSACTION_RECORD_INFO | TABLE FUNCTION | V7R5M0 |
| QSYS2 | ENVIRONMENT_VARIABLE_INFO | VIEW | V7R3M0 |
| QSYS2 | EXIT_POINT_INFO | VIEW | V7R3M0 |
| QSYS2 | EXIT_PROGRAM_INFO | VIEW | V7R3M0 |
| QSYS2 | PROGRAM_EXPORT_IMPORT_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | PROGRAM_INFO | VIEW | V7R3M0 |
| QSYS2 | QCMDEXC | PROCEDURE | V7R3M0 |
| QSYS2 | QCMDEXC | SCALAR FUNCTION | V7R3M0 |
| QSYS2 | RECEIVE_DATA_QUEUE | TABLE FUNCTION | V7R4M0 |
| QSYS2 | REMOVE_USER_INDEX_ENTRY | PROCEDURE | V7R4M0 |
| QSYS2 | SEND_DATA_QUEUE | PROCEDURE | V7R4M0 |
| QSYS2 | SERVICES_INFO | VIEW | V7R3M0 |
| QSYS2 | SET_PASE_SHELL_INFO | PROCEDURE | V7R4M0 |
| QSYS2 | STACK_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | USER_INDEX_ENTRIES | TABLE FUNCTION | V7R4M0 |
| QSYS2 | USER_INDEX_INFO | VIEW | V7R4M0 |
| QSYS2 | USER_SPACE | TABLE FUNCTION | V7R4M0 |
| QSYS2 | USER_SPACE_INFO | VIEW | V7R4M0 |
| QSYS2 | WATCH_DETAIL | TABLE FUNCTION | V7R4M0 |
| QSYS2 | WATCH_INFO | VIEW | V7R3M0 |
| SYSTOOLS | ERRNO_INFO | VIEW | V7R3M0 |
| SYSTOOLS | GENERATE_SPREADSHEET | PROCEDURE | V7R3M0 |
| SYSTOOLS | LOBJ_BUILD_V2 | PROCEDURE | V7R3M0 |
| SYSTOOLS | LOBJ_CLEANUP | PROCEDURE | V7R3M0 |
| SYSTOOLS | LOBJ_FIND | TABLE FUNCTION | V7R3M0 |
| SYSTOOLS | REMOVE_USER_SPACE | PROCEDURE | V7R4M0 |
| SYSTOOLS | SET_COLUMN_ATTRIBUTE | PROCEDURE | V7R3M0 |

## Service Details

### Views (read-only queries)
- **ACTIVATION_GROUP_INFO** — Active activation groups with program and library details
- **BINDING_DIRECTORY_INFO** — Binding directory entries showing bound modules and service programs
- **BOUND_MODULE_INFO** — Modules bound into ILE programs and service programs
- **BOUND_SRVPGM_INFO** — Service programs bound into ILE programs and service programs
- **COMMAND_INFO** — CL command metadata (library, processing program, threadsafe, proxy)
- **DATA_AREA_INFO** (view) — Data area inventory across libraries with values and types
- **DATA_QUEUE_INFO** — Data queue configuration, message counts, and sequence
- **ENVIRONMENT_VARIABLE_INFO** — System-level and job-level environment variables
- **EXIT_POINT_INFO** — Registered exit points on the system
- **EXIT_PROGRAM_INFO** — Exit programs registered at each exit point
- **PROGRAM_INFO** — ILE and OPM program attributes (language, activation group, size)
- **SERVICES_INFO** — Catalog of all available IBM i SQL services
- **USER_INDEX_INFO** — User index objects with attributes and entry counts
- **USER_SPACE_INFO** — User space objects with size and attributes
- **WATCH_INFO** — Watch sessions with status, type, user, and timestamps
- **ERRNO_INFO** (SYSTOOLS) — PASE errno values and descriptions

### Table Functions (read-only with parameters)
- **DATA_AREA_INFO()** — Targeted data area lookup by name and library
- **DATA_QUEUE_ENTRIES()** — Read entries from a data queue without removing them
- **DB_TRANSACTION_INFO()** — Database transaction details for commitment control
- **DB_TRANSACTION_JOURNAL_INFO()** — Journal information for database transactions
- **DB_TRANSACTION_OBJECT_INFO()** — Objects involved in database transactions
- **DB_TRANSACTION_RECORD_INFO()** — Record-level detail for database transactions
- **PROGRAM_EXPORT_IMPORT_INFO()** — Exports and imports for ILE programs and service programs
- **RECEIVE_DATA_QUEUE()** — Receive (read and remove) entries from a data queue
- **STACK_INFO()** — Call stack entries for a specified job
- **USER_INDEX_ENTRIES()** — Read entries from a user index
- **USER_SPACE()** — Read contents of a user space
- **WATCH_DETAIL()** — Detailed information for a specific watch session
- **LOBJ_FIND** (SYSTOOLS) — Find large objects in the database

### Procedures (write operations — not in default toolset)
- **ADD_USER_INDEX_ENTRY** — Add an entry to a user index
- **CHANGE_USER_SPACE** — Modify the contents of a user space
- **CHANGE_USER_SPACE_ATTRIBUTES** — Modify user space attributes (size, auto-extend)
- **CLEAR_DATA_QUEUE** — Remove all entries from a data queue
- **CREATE_USER_INDEX** — Create a new user index object
- **CREATE_USER_SPACE** — Create a new user space object
- **QCMDEXC** (procedure) — Execute a CL command from SQL
- **REMOVE_USER_INDEX_ENTRY** — Remove an entry from a user index
- **SEND_DATA_QUEUE** — Send an entry to a data queue
- **SET_PASE_SHELL_INFO** — Set the default PASE shell for a user profile
- **REMOVE_USER_SPACE** (SYSTOOLS) — Delete a user space object
- **GENERATE_SPREADSHEET** (SYSTOOLS) — Generate a spreadsheet from SQL query results
- **LOBJ_BUILD_V2** (SYSTOOLS) — Build large object tracking data
- **LOBJ_CLEANUP** (SYSTOOLS) — Clean up large object tracking data
- **SET_COLUMN_ATTRIBUTE** (SYSTOOLS) — Set column-level attributes for display

### Scalar Functions
- **QCMDEXC** (scalar function) — Execute a CL command from SQL and return result inline
