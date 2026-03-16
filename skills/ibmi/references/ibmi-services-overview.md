# IBM i SQL Services Overview

**375 services across 28 categories** (from QSYS2.SERVICES_INFO)

## Service Categories by Count

| Category | Services |
|----------|----------|
| JOURNAL | 50 |
| APPLICATION | 45 |
| WORK MANAGEMENT | 35 |
| MIRROR-PRODUCT | 27 |
| SECURITY | 22 |
| COMMUNICATION | 21 |
| DATABASE-UTILITY | 18 |
| STORAGE | 17 |
| DATABASE-PLAN CACHE | 14 |
| IFS | 12 |
| DATABASE-PERFORMANCE | 10 |
| DATABASE-APPLICATION | 9 |
| MIGRATE WHILE ACTIVE | 9 |
| SPOOL | 9 |
| MIRROR-COMMUNICATION | 8 |
| PTF | 8 |
| MESSAGE HANDLING | 8 |
| MIRROR-REPLICATION | 8 |
| MIRROR-RECLONE | 7 |
| MIRROR-SERVICEABILITY | 7 |
| BACKUP AND RECOVERY | 5 |
| LIBRARIAN | 5 |
| MIRROR-RESYNCHRONIZATION | 5 |
| CONFIGURATION | 4 |
| PRODUCT | 4 |
| SYSTEM HEALTH | 4 |
| JAVA | 3 |
| PERFORMANCE | 1 |

## Skill Plugin Mapping

### ibmi-core (this skill)

The foundation layer. Provides schema discovery, SQL validation, and service catalog browsing. No domain-specific service queries -- those live in the domain skills below.

- `list_tables_in_schema` -- QSYS2.SYSTABLES + SYSTABLESTAT
- `get_column_info` -- QSYS2.SYSCOLUMNS
- `validate_query` -- QSYS2.PARSE_STATEMENT
- `sample_rows` -- QSYS2.SYSCOLUMNS (generates query text)
- `get_table_statistics` -- QSYS2.SYSTABLES + SYSTABLESTAT
- `search_services` -- QSYS2.SERVICES_INFO
- `list_service_categories` -- QSYS2.SERVICES_INFO

### ibmi-database (planned)

Categories focused on database internals:

| Category | Services | Description |
|----------|----------|-------------|
| JOURNAL | 50 | Journal receivers, audit journals, journaled objects |
| DATABASE-UTILITY | 18 | File comparison, catalog analysis, SQL generation |
| DATABASE-PLAN CACHE | 14 | Query plan cache analysis, event monitors, snapshots |
| DATABASE-PERFORMANCE | 10 | Active queries, MTI, query supervisor, index advice |
| DATABASE-APPLICATION | 9 | SQL error logs, statement parsing, SQLCODE info |

**Total: 101 services**

### ibmi-system (planned)

Categories focused on system operations:

| Category | Services | Description |
|----------|----------|-------------|
| APPLICATION | 45 | Commands, data areas, queues, programs, watches |
| WORK MANAGEMENT | 35 | Jobs, subsystems, job queues, scheduling |
| SECURITY | 22 | User profiles, authorities, certificates, auditing |
| COMMUNICATION | 21 | Network, TCP/IP, HTTP servers, DNS |
| STORAGE | 17 | ASP, disk, temporary storage, NVMe |
| IFS | 12 | Integrated File System objects, locks, privileges |
| SPOOL | 9 | Output queues, spooled files, PDF generation |
| MIGRATE WHILE ACTIVE | 9 | System migration tools |
| PTF | 8 | Program Temporary Fix management |
| MESSAGE HANDLING | 8 | Message queues, history log, job log |
| BACKUP AND RECOVERY | 5 | Save files, media, tape |
| LIBRARIAN | 5 | Library management, object statistics |
| CONFIGURATION | 4 | System values, hardware resources |
| PRODUCT | 4 | Licensed products, software info |
| SYSTEM HEALTH | 4 | System limits, status indicators |
| JAVA | 3 | JVM info, Java properties |
| PERFORMANCE | 1 | Collection services |

**Total: 212 services**

### mirror (specialized)

Categories for Db2 Mirror:

| Category | Services |
|----------|----------|
| MIRROR-PRODUCT | 27 |
| MIRROR-COMMUNICATION | 8 |
| MIRROR-REPLICATION | 8 |
| MIRROR-RECLONE | 7 |
| MIRROR-SERVICEABILITY | 7 |
| MIRROR-RESYNCHRONIZATION | 5 |

**Total: 62 services**
