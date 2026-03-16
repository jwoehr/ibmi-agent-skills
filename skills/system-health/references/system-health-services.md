# System Health Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'SYSTEM HEALTH'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | PROCESS_SYSTEM_LIMITS_ALERTS | PROCEDURE | V7R4M0 |
| QSYS2 | SYSLIMITS | VIEW | V6R1M0 |
| QSYS2 | SYSLIMITS_BASIC | VIEW | V7R2M0 |
| QSYS2 | SYSLIMTBL | TABLE | V6R1M0 |

## Additional Services Used by This Skill

These services are categorized elsewhere in SERVICES_INFO but are essential for system health monitoring:

| Schema | Service Name | SQL Object Type | Category |
|--------|-------------|-----------------|----------|
| QSYS2 | SYSTEM_STATUS | TABLE FUNCTION | (PERFORMANCE) |
| QSYS2 | SYSTEM_ACTIVITY_INFO | TABLE FUNCTION | (PERFORMANCE) |
| QSYS2 | MEMORY_POOL | TABLE FUNCTION | (PERFORMANCE) |
| QSYS2 | SYSDISKSTAT | VIEW | (STORAGE) |
| QSYS2 | ASP_INFO | VIEW | (STORAGE) |
| QSYS2 | NETSTAT_INFO | VIEW | (COMMUNICATION) |

## Service Details

### System Limits
- **SYSLIMITS** -- System limits with current/maximum values, job info, and SQL details
- **SYSLIMITS_BASIC** -- Lightweight limits view with fewer columns
- **SYSLIMTBL** -- System limits threshold configuration table

### Procedures
- **PROCESS_SYSTEM_LIMITS_ALERTS** -- Process and send alerts for exceeded limits (V7R4+)

### Cross-category Services
- **SYSTEM_STATUS()** -- Comprehensive CPU, memory, jobs, and partition metrics
- **SYSTEM_ACTIVITY_INFO()** -- Real-time CPU utilization rates
- **MEMORY_POOL()** -- Pool sizes, threads, paging rates, tuning parameters
- **SYSDISKSTAT** -- Disk unit capacity, usage, I/O statistics
- **ASP_INFO** -- ASP capacity, thresholds, balance status
- **NETSTAT_INFO** -- TCP/IP connections, addresses, ports
