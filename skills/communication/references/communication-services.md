# Communication Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'COMMUNICATION'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | CHANGE_CONNECTION | PROCEDURE | V7R5M0 |
| QSYS2 | DISPLAY_JOURNAL_CONNECTION | PROCEDURE | V7R5M0 |
| QSYS2 | END_MIRROR | PROCEDURE | V7R4M0 |
| QSYS2 | HTTP_SERVER_INFO | VIEW | V7R3M0 |
| QSYS2 | NETSTAT_INFO | VIEW | V7R2M0 |
| QSYS2 | NETSTAT_INTERFACE_INFO | VIEW | V7R3M0 |
| QSYS2 | NETSTAT_JOB_INFO | VIEW | V7R2M0 |
| QSYS2 | NETSTAT_ROUTE_INFO | VIEW | V7R2M0 |
| QSYS2 | NETWORK_ATTRIBUTE_INFO | VIEW | V7R5M0 |
| QSYS2 | SERVER_SOS_INFO | VIEW | V7R4M0 |
| QSYS2 | SET_SERVER_SOS_STATUS | PROCEDURE | V7R4M0 |
| QSYS2 | TCPIP_INFO | VIEW | V7R3M0 |
| QSYS2 | TIME_PROTOCOL_INFO | VIEW | V7R3M0 |
| SYSTOOLS | END_MIRROR | PROCEDURE | V7R3M0 |
| SYSTOOLS | MANAGE_MIRROR | PROCEDURE | V7R3M0 |
| SYSTOOLS | SET_COLUMN_ATTRIBUTE | PROCEDURE | V7R3M0 |
| SYSTOOLS | SET_SERVER_SOS_STATUS | PROCEDURE | V7R3M0 |
| SYSTOOLS | SPLIT_MIRROR | PROCEDURE | V7R3M0 |
| SYSTOOLS | START_MIRROR | PROCEDURE | V7R3M0 |
| SYSTOOLS | SUSPEND_MIRROR | PROCEDURE | V7R3M0 |
| SYSTOOLS | VALIDATE_MIRROR | PROCEDURE | V7R4M0 |

## Service Details

### Views (read-only queries -- covered by default tools)
- **NETSTAT_INFO** — Active TCP/IP connections with traffic metrics
- **NETSTAT_INTERFACE_INFO** — Network interface configuration
- **NETSTAT_JOB_INFO** — Network-bound jobs
- **NETSTAT_ROUTE_INFO** — TCP/IP routing table
- **HTTP_SERVER_INFO** — HTTP server instances and status
- **TCPIP_INFO** — TCP/IP stack configuration
- **NETWORK_ATTRIBUTE_INFO** — System-level network attributes
- **TIME_PROTOCOL_INFO** — NTP/SNTP server configuration
- **SERVER_SOS_INFO** — Server short-on-storage status

### Procedures (not in default toolset)
- **CHANGE_CONNECTION** — Modify network connection properties
- **DISPLAY_JOURNAL_CONNECTION** — Display journal connection details
- **END_MIRROR / START_MIRROR / SUSPEND_MIRROR** — Db2 Mirror operations
- **SET_SERVER_SOS_STATUS** — Set server SOS status
- **SPLIT_MIRROR / VALIDATE_MIRROR / MANAGE_MIRROR** — Mirror management
