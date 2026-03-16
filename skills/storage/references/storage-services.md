# Storage Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'STORAGE'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| QSYS2 | ASP_INFO | VIEW | V7R3M0 |
| QSYS2 | ASP_JOB_INFO | VIEW | V7R3M0 |
| QSYS2 | ASP_VARY_INFO | VIEW | V7R4M0 |
| QSYS2 | CHANGE_STORAGE_THRESHOLD | PROCEDURE | V7R5M0 |
| QSYS2 | LOCKING_POLICY_INFO | VIEW | V7R5M0 |
| QSYS2 | MANAGE_DISK | PROCEDURE | V7R5M0 |
| QSYS2 | MANAGE_MEDIA | PROCEDURE | V7R5M0 |
| QSYS2 | NVME_INFO | VIEW | V7R5M0 |
| QSYS2 | SET_DISK_ENCRYPTION | PROCEDURE | V7R5M0 |
| QSYS2 | SYSDISKSTAT | TABLE FUNCTION | V7R2M0 |
| QSYS2 | SYSDISKSTAT | VIEW | V7R2M0 |
| QSYS2 | SYSTMPSTG | VIEW | V7R2M0 |
| QSYS2 | USER_STORAGE | VIEW | V7R3M0 |
| SYSTOOLS | CHANGE_DISK_ATTRIBUTE | PROCEDURE | V7R3M0 |
| SYSTOOLS | CONFIGURE_OBJECT_STORAGE_THRESHOLD | PROCEDURE | V7R5M0 |
| SYSTOOLS | QUERY_DISK_USAGE | TABLE FUNCTION | V7R5M0 |
| SYSTOOLS | SET_DISK_ENCRYPTION | PROCEDURE | V7R5M0 |

## Service Details

### Views (read-only queries)
- **ASP_INFO** — Auxiliary Storage Pool capacity, usage, and configuration
- **ASP_JOB_INFO** — Jobs active on Independent ASPs
- **ASP_VARY_INFO** — IASP vary-on/vary-off operation history
- **LOCKING_POLICY_INFO** — NVMe device locking policy status
- **NVME_INFO** — NVMe device health, temperature, firmware
- **SYSDISKSTAT** (view) — Disk unit status and utilization
- **SYSTMPSTG** — Temporary storage usage per job
- **USER_STORAGE** — Storage used per user profile

### Table Functions (read-only with parameters)
- **SYSDISKSTAT()** — Detailed disk I/O statistics with optional counter reset
- **QUERY_DISK_USAGE()** — Disk usage analysis (V7R5+, SYSTOOLS)

### Procedures (write operations — not in default toolset)
- **CHANGE_STORAGE_THRESHOLD** — Modify storage alert thresholds
- **MANAGE_DISK** — Disk management operations
- **MANAGE_MEDIA** — Media management operations
- **SET_DISK_ENCRYPTION** — Configure disk encryption
- **CHANGE_DISK_ATTRIBUTE** — Modify disk attributes
- **CONFIGURE_OBJECT_STORAGE_THRESHOLD** — Set object storage thresholds
