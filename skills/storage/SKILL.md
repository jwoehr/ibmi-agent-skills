---
name: storage
description: "Monitor and analyze IBM i storage resources including ASPs, disk units, temporary storage, user storage consumption, and NVMe devices via SQL services. Use when user asks about: (1) ASP capacity, usage, or health, (2) disk unit status or I/O performance, (3) temporary storage consumption by jobs, (4) storage used per user profile, (5) NVMe device health, (6) IASP vary operations, or (7) replacing WRKDSKSTS, WRKSYSSTS storage info, or WRKSTG commands."
---

# IBM i Storage Management

Monitor and analyze storage resources on IBM i using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing storage queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/storage, ~/.claude/skills/storage

# List all storage tools
ibmi tools --tools "$SKILL_DIR/tools/" --toolset storage_default

# Run a specific tool
ibmi tool get_asp_info --tools "$SKILL_DIR/tools/"

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.ASP_INFO ORDER BY ASP_NUMBER"
```

## Service Selection Guide

### ASP Management
- **QSYS2.ASP_INFO** — ASP capacity, usage %, storage type, disk unit counts
- **QSYS2.ASP_JOB_INFO** — Jobs active on Independent ASPs
- **QSYS2.ASP_VARY_INFO** — IASP vary-on/vary-off history and timing

### Disk & Hardware
- **QSYS2.SYSDISKSTAT** (view) — Quick disk status overview
- **QSYS2.SYSDISKSTAT** (table function) — Detailed I/O counters and response times
- **QSYS2.NVME_INFO** — NVMe device health, temperature, firmware
- **QSYS2.LOCKING_POLICY_INFO** — NVMe locking policy status

### Storage Consumption
- **QSYS2.SYSTMPSTG** — Temporary storage usage by job
- **QSYS2.USER_STORAGE** — Storage used per user profile

## Key Capabilities

### ASP Health & Capacity
- View all ASPs with capacity, usage percentage, and storage type
- Monitor Independent ASP (IASP) availability and vary operations
- Identify jobs running against specific IASPs before maintenance

### Disk Performance
- Check disk utilization percentages across all units
- Identify SSD vs spinning disk storage
- Monitor I/O read/write counters and response times

### Storage Consumption Analysis
- Find jobs consuming the most temporary storage
- Identify peak temp storage by job for capacity planning
- Track storage used per user profile and ASP
- Check user storage limits vs actual usage

### Hardware Monitoring
- NVMe device inventory with firmware and serial numbers
- Temperature monitoring (controller and composite)
- Available spare capacity and percentage used
- Locking policy status for encrypted storage

## Common Use Cases

### 1. System Storage Overview
Check overall ASP capacity and usage across all pools

### 2. Disk Health Check
Identify disk units with high utilization or poor I/O response

### 3. Temp Storage Troubleshooting
Find jobs consuming excessive temporary storage

### 4. User Storage Audit
Identify top storage consumers and users exceeding limits

### 5. IASP Maintenance
Check what jobs are active on an IASP before vary-off

### 6. Hardware Inventory
List NVMe devices with health and firmware status

## CL Command Migration

| CL Command | SQL Service |
|------------|-------------|
| WRKDSKSTS | SYSDISKSTAT (view or table function) |
| WRKSYSSTS (storage) | ASP_INFO + SYSTMPSTG |
| WRKSTG | USER_STORAGE |

## Quick Examples

### Check ASP usage
```sql
SELECT ASP_NUMBER, TOTAL_CAPACITY,
       DECIMAL((TOTAL_CAPACITY - TOTAL_CAPACITY_AVAILABLE) * 100.0
               / NULLIF(TOTAL_CAPACITY, 0), 5, 2) AS PCT_USED,
       STORAGE_THRESHOLD_PERCENTAGE
  FROM QSYS2.ASP_INFO ORDER BY ASP_NUMBER;
```

### Find top temp storage consumers
```sql
SELECT JOB_NAME, JOB_USER_NAME, BUCKET_CURRENT_SIZE, BUCKET_PEAK_SIZE
  FROM QSYS2.SYSTMPSTG
  WHERE JOB_STATUS = '*ACTIVE'
  ORDER BY BUCKET_CURRENT_SIZE DESC
  FETCH FIRST 10 ROWS ONLY;
```

### Check disk I/O performance
```sql
SELECT RESOURCE_NAME, PERCENT_USED,
       ELAPSED_READ_REQUESTS, ELAPSED_WRITE_REQUESTS, ELAPSED_PERCENT_BUSY
  FROM QSYS2.SYSDISKSTAT
  WHERE ELAPSED_IO_REQUESTS > 0
  ORDER BY ELAPSED_PERCENT_BUSY DESC
  FETCH FIRST 10 ROWS ONLY;
```

## Pre-built Tools

The `tools/storage.yaml` file provides 9 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_asp_info` | ASP capacity, usage, and storage type |
| `get_asp_job_info` | Jobs active on Independent ASPs |
| `get_asp_vary_info` | IASP vary-on/vary-off history |
| `get_disk_status` | Quick disk utilization overview |
| `get_disk_status_detailed` | Detailed disk I/O counters |
| `get_temp_storage` | Temp storage by active job |
| `get_user_storage` | Storage used per user profile |
| `get_nvme_info` | NVMe device health and firmware |
| `get_locking_policy_info` | NVMe locking policy status |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Storage Services Catalog](./references/storage-services.md) — All STORAGE category services from SERVICES_INFO
- [Storage Examples](./references/storage-examples.sql) — Working SQL query examples
- [IBM i Services - Storage](https://www.ibm.com/support/pages/ibm-i-services-sql) — IBM documentation
