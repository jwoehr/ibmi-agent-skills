# Message Handling Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'MESSAGE HANDLING'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | HISTORY_LOG_INFO | TABLE FUNCTION | V7R2M0 |
| QSYS2 | JOBLOG_INFO | TABLE FUNCTION | V6R1M0 |
| QSYS2 | MESSAGE_FILE_DATA | VIEW | V7R3M0 |
| QSYS2 | MESSAGE_QUEUE_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | MESSAGE_QUEUE_INFO | VIEW | V7R2M0 |
| SYSTOOLS | REPLY_INQUIRY_MESSAGES | SCALAR FUNCTION | V7R4M0 |
| QSYS2 | REPLY_LIST_INFO | VIEW | V6R1M0 |
| QSYS2 | SEND_MESSAGE | PROCEDURE | V7R3M0 |

## Service Details

### Views (read-only queries)
- **MESSAGE_QUEUE_INFO** -- Read messages from any message queue (view variant)
- **REPLY_LIST_INFO** -- System reply list entries for automatic message responses
- **MESSAGE_FILE_DATA** -- Message definitions, templates, severity, and reply config

### Table Functions (read-only with parameters)
- **HISTORY_LOG_INFO()** -- System history log entries (QHST equivalent)
- **MESSAGE_QUEUE_INFO()** -- Parameterized message queue access (V7R3+)
- **JOBLOG_INFO()** -- Job log entries for a specific job

### Procedures (write operations)
- **SEND_MESSAGE** -- Send a message to a message queue

### Scalar Functions
- **REPLY_INQUIRY_MESSAGES** -- Reply to inquiry messages (SYSTOOLS, V7R4+)

## Notes

- MESSAGE_QUEUE_INFO exists as both a view (V7R2+) and table function (V7R3+)
- The view variant is used in the pre-built tools for broader compatibility
- HISTORY_LOG_INFO is a table function and requires parentheses: `TABLE(QSYS2.HISTORY_LOG_INFO())`
- JOBLOG_INFO is part of MESSAGE HANDLING but is used in the work-management skill
