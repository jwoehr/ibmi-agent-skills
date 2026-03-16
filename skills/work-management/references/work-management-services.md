# Work Management Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'WORK MANAGEMENT'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | ACTIVE_JOB_INFO | TABLE FUNCTION | V7R1M0 |
| QSYS2 | ADD_TRACKED_JOB_QUEUE | PROCEDURE | V7R4M0 |
| QSYS2 | AUTOSTART_JOB_INFO | VIEW | V7R3M0 |
| QSYS2 | CLEAR_TRACKED_JOB_INFO | PROCEDURE | V7R4M0 |
| QSYS2 | COMMUNICATIONS_ENTRY_INFO | VIEW | V7R3M0 |
| SYSTOOLS | END_JOBS | PROCEDURE | V7R4M0 |
| SYSTOOLS | ENDED_JOB_INFO | TABLE FUNCTION | V7R4M0 |
| QSYS2 | GET_JOB_INFO | TABLE FUNCTION | V6R1M0 |
| QSYS2 | JOB_DESCRIPTION_INFO | VIEW | V7R2M0 |
| QSYS2 | JOB_INFO | TABLE FUNCTION | V7R2M0 |
| QSYS2 | JOB_LOCK_INFO | TABLE FUNCTION | V7R3M0 |
| SYSTOOLS | JOB_QUEUE_ENTRIES | VIEW | V7R4M0 |
| QSYS2 | JOB_QUEUE_INFO | VIEW | V7R2M0 |
| QSYS2 | MEMORY_POOL | TABLE FUNCTION | V7R1M0 |
| QSYS2 | MEMORY_POOL_INFO | VIEW | V7R1M0 |
| QSYS2 | OBJECT_LOCK_INFO | VIEW | V7R1M0 |
| QSYS2 | OPEN_FILES | TABLE FUNCTION | V7R3M0 |
| SYSTOOLS | POWER_SCHEDULE_INFO | VIEW | V7R4M0 |
| QSYS2 | PRESTART_JOB_INFO | VIEW | V7R3M0 |
| QSYS2 | PRESTART_JOB_STATISTICS | TABLE FUNCTION | V7R3M0 |
| QSYS2 | RECORD_LOCK_INFO | VIEW | V7R1M0 |
| QSYS2 | REMOVE_TRACKED_JOB_QUEUE | PROCEDURE | V7R4M0 |
| QSYS2 | ROUTING_ENTRY_INFO | VIEW | V7R3M0 |
| QSYS2 | SCHEDULED_JOB_INFO | VIEW | V7R1M0 |
| QSYS2 | SUBSYSTEM_INFO | VIEW | V7R3M0 |
| QSYS2 | SUBSYSTEM_POOL_INFO | VIEW | V7R3M0 |
| QSYS2 | SYSTEM_ACTIVITY_INFO | TABLE FUNCTION | V7R3M0 |
| QSYS2 | SYSTEM_STATUS | TABLE FUNCTION | V7R1M0 |
| QSYS2 | SYSTEM_STATUS_INFO | VIEW | V7R1M0 |
| QSYS2 | SYSTEM_STATUS_INFO_BASIC | VIEW | V7R3M0 |
| QSYS2 | SYSTEM_VALUE_INFO | VIEW | V6R1M0 |
| QSYS2 | TRACKED_JOB_INFO | TABLE FUNCTION | V7R4M0 |
| QSYS2 | TRACKED_JOB_QUEUES | VIEW | V7R4M0 |
| QSYS2 | WORKLOAD_GROUP_INFO | VIEW | V7R3M0 |
| QSYS2 | WORKSTATION_INFO | VIEW | V7R3M0 |

## Service Details

### Views (read-only queries)
- **AUTOSTART_JOB_INFO** -- Autostart job entries defined in subsystem descriptions
- **COMMUNICATIONS_ENTRY_INFO** -- Communications entries in subsystem descriptions
- **JOB_DESCRIPTION_INFO** -- Job description attributes and configuration
- **JOB_QUEUE_INFO** -- Job queue status, active/held counts, and subsystem assignment
- **JOB_QUEUE_ENTRIES** -- Individual entries waiting on job queues (SYSTOOLS)
- **MEMORY_POOL_INFO** -- Shared and private memory pool configuration and usage
- **OBJECT_LOCK_INFO** -- Object-level lock holders and lock states
- **POWER_SCHEDULE_INFO** -- System power-on/power-off schedule entries (SYSTOOLS)
- **PRESTART_JOB_INFO** -- Prestart job entries in subsystem descriptions
- **RECORD_LOCK_INFO** -- Record-level lock holders and wait status
- **ROUTING_ENTRY_INFO** -- Routing entries in subsystem descriptions
- **SCHEDULED_JOB_INFO** -- Jobs scheduled via ADDJOBSCDE (job scheduler entries)
- **SUBSYSTEM_INFO** -- Active subsystem status including pool allocation and max jobs
- **SUBSYSTEM_POOL_INFO** -- Memory pool assignments within active subsystems
- **SYSTEM_STATUS_INFO** -- System-wide CPU, jobs, storage, and status metrics
- **SYSTEM_STATUS_INFO_BASIC** -- Lightweight system status (fewer columns, faster)
- **SYSTEM_VALUE_INFO** -- System value settings (QCCSID, QDATE, QTIME, etc.)
- **TRACKED_JOB_QUEUES** -- Job queues being tracked for job completion monitoring
- **WORKLOAD_GROUP_INFO** -- Workload capping group configuration and activity
- **WORKSTATION_INFO** -- Display station status, signed-on user, and subsystem

### Table Functions (read-only with parameters)
- **ACTIVE_JOB_INFO()** -- Active job details with flexible filtering and column selection
- **ENDED_JOB_INFO()** -- Recently ended jobs with completion status (SYSTOOLS)
- **GET_JOB_INFO()** -- Detailed attributes for a single job by qualified name
- **JOB_INFO()** -- Job details with filtering by status, subsystem, user, etc.
- **JOB_LOCK_INFO()** -- Locks held by or waited on by a specific job
- **MEMORY_POOL()** -- Memory pool statistics with optional counter reset
- **OPEN_FILES()** -- Files currently open by a specific job
- **PRESTART_JOB_STATISTICS()** -- Runtime statistics for prestart job entries
- **SYSTEM_ACTIVITY_INFO()** -- Periodic system activity snapshots (CPU, I/O, faults)
- **SYSTEM_STATUS()** -- System status with optional counter reset
- **TRACKED_JOB_INFO()** -- Completion status for jobs submitted to tracked queues

### Procedures (write operations -- not in default toolset)
- **ADD_TRACKED_JOB_QUEUE** -- Begin tracking a job queue for completion monitoring
- **CLEAR_TRACKED_JOB_INFO** -- Clear tracked job completion data
- **REMOVE_TRACKED_JOB_QUEUE** -- Stop tracking a job queue
- **END_JOBS** -- End one or more jobs by qualified name (SYSTOOLS)
