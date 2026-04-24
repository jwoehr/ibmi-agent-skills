---
name: system-health
description: "Monitor IBM i system health including CPU, memory, disk, ASPs, system limits, and network status via SQL services. Use when user asks about: (1) CPU utilization or system status, (2) memory pool sizes or page faults, (3) disk capacity or ASP usage, (4) system limits approaching thresholds, (5) TCP/IP connections and network status, (6) system activity overview, (7) replacing WRKSYSSTS, WRKDSKSTS, WRKTCPSTS commands, or (8) any system health monitoring task."
---

# IBM i System Health Monitoring

Monitor system health including CPU, memory, disk, ASPs, system limits, and network status using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing system health queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/system-health, ~/.claude/skills/system-health

# List all system health tools
ibmi tools --tools "$SKILL_DIR/tools/" --toolset system_health_default

# Run a specific tool
ibmi tool get_system_status --tools "$SKILL_DIR/tools/"

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM TABLE(QSYS2.SYSTEM_STATUS(RESET_STATISTICS => 'YES')) X"
```

## Service Selection Guide

### System Status & Activity
- **QSYS2.SYSTEM_STATUS()** -- Comprehensive system metrics: CPU, memory, jobs, partition info
- **QSYS2.SYSTEM_ACTIVITY_INFO()** -- Real-time CPU utilization rates

### Memory
- **QSYS2.MEMORY_POOL()** -- Pool sizes, threads, paging rates, tuning parameters

### Disk & Storage
- **QSYS2.SYSDISKSTAT** -- Disk unit capacity, usage, I/O stats per unit
- **QSYS2.ASP_INFO** -- ASP capacity, thresholds, balance status

### System Limits
- **QSYS2.SYSLIMITS** -- System limits with current vs maximum values
- **QSYS2.SYSLIMITS_BASIC** -- Lightweight limits view

### Network
- **QSYS2.NETSTAT_INFO** -- TCP/IP connections, addresses, ports, transfer counts

## Key Capabilities

### CPU Monitoring
- **Overall Utilization** -- Average, minimum, maximum CPU percentages
- **Capacity Info** -- Configured CPUs, current capacity, sharing attributes
- **Elapsed Metrics** -- CPU used during measurement interval

### Memory Analysis
- **Pool Status** -- Current size, defined size, reserved, thread counts
- **Page Faults** -- Database and non-database fault rates per pool
- **Thread Activity** -- Active, ineligible, and maximum threads per pool
- **Tuning** -- Priority, min/max size, min/max faults settings

### Disk & ASP Health
- **Disk Units** -- Capacity, percent used, type, protection, I/O busy %
- **ASP Status** -- Total/available capacity, threshold, balance status
- **Protected vs Unprotected** -- Breakdown of storage by protection type

### System Limits
- **Threshold Monitoring** -- Find limits approaching maximum values
- **Capacity Planning** -- Current vs maximum with percentage used
- **Category Filtering** -- Filter by limit type and category

### Network Status
- **Active Connections** -- Established TCP connections with addresses and ports
- **Connection Counts** -- Total remote connections excluding loopback
- **Transfer Stats** -- Bytes sent/received per connection

## Common Use Cases

1. **System health check** -- Quick overview of CPU, memory, jobs, and storage
2. **CPU troubleshooting** -- Identify high CPU utilization periods
3. **Memory pressure** -- Find pools with high page fault rates
4. **Disk capacity planning** -- Monitor ASP usage and thresholds
5. **Limit monitoring** -- Find system limits approaching maximum
6. **Network audit** -- Review active TCP connections
7. **Performance baseline** -- Capture system metrics for comparison
8. **IPL planning** -- Check system status before maintenance windows

## Quick Examples

### System status overview
```bash
ibmi tool get_system_status --tools "$SKILL_DIR/tools/"
```

### Memory pool health
```bash
ibmi tool get_memory_pools --tools "$SKILL_DIR/tools/"
```

### Find limits above 80% used
```bash
ibmi tool get_system_limits --tools "$SKILL_DIR/tools/" --pct-threshold 80
```

### ASP capacity check
```sql
SELECT ASP_NUMBER, TOTAL_CAPACITY, TOTAL_CAPACITY_AVAILABLE,
       STORAGE_THRESHOLD_PERCENTAGE
  FROM QSYS2.ASP_INFO
  ORDER BY ASP_NUMBER;
```

### Disk units by busy percentage
```sql
SELECT UNIT_NUMBER, ASP_NUMBER, PERCENT_USED, ELAPSED_PERCENT_BUSY
  FROM QSYS2.SYSDISKSTAT
  WHERE ELAPSED_PERCENT_BUSY > 0
  ORDER BY ELAPSED_PERCENT_BUSY DESC
  FETCH FIRST 10 ROWS ONLY;
```

## Pre-built Tools

The `tools/system-health.yaml` file provides 8 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_system_status` | Comprehensive system status: CPU, memory, jobs, partition |
| `get_system_activity` | Real-time CPU utilization rates |
| `get_memory_pools` | Memory pool sizes, threads, and paging metrics |
| `list_disk_units` | Disk unit capacity, usage, type, and I/O stats |
| `list_asp_info` | ASP capacity, thresholds, and balance status |
| `get_system_limits` | System limits with percentage used filtering |
| `get_tcp_connections` | Established TCP/IP connections with transfer stats |
| `count_remote_connections` | Count of remote connections excluding loopback |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [System Health Services Catalog](./references/system-health-services.md) -- Available SQL services
- [Example SQL Patterns](./references/system-health-examples.sql) -- Working query examples
- [IBM SYSTEM_STATUS](https://www.ibm.com/docs/en/i/7.5?topic=services-system-status-table-function) -- Table function documentation
- [IBM SYSLIMITS](https://www.ibm.com/docs/en/i/7.5?topic=services-syslimits-view) -- View documentation
