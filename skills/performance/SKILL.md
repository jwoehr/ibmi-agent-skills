---
name: performance
description: "Monitor IBM i performance including collection services, temporary storage, disk I/O metrics, and memory pool performance via SQL services. Use when user asks about: (1) collection services configuration or categories, (2) temporary storage usage by bucket or job, (3) disk I/O performance per unit, (4) memory pool page fault rates, (5) performance data collection settings, (6) replacing WRKSYSSTS performance views, or (7) any performance analysis or capacity planning task."
---

# IBM i Performance Monitoring

Monitor system performance including collection services configuration, temporary storage usage, disk I/O metrics, and memory pool performance using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing performance queries:

```bash
# List all performance tools
ibmi tools --tools tools/ --toolset performance_default

# Run a specific tool
ibmi tool get_collection_services_config --tools tools/

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.COLLECTION_SERVICES_INFO"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### Collection Services
- **QSYS2.COLLECTION_SERVICES_INFO** -- Configuration, intervals, retention, categories

### Temporary Storage
- **QSYS2.SYSTMPSTG** -- Temporary storage per bucket and per job

### Disk I/O
- **QSYS2.SYSDISKSTAT** -- Elapsed I/O statistics per disk unit

### Memory Performance
- **QSYS2.MEMORY_POOL()** -- Page faults, thread transitions, tuning settings

## Key Capabilities

### Collection Services Management
- **Configuration** -- Active collection, library, profile, intervals
- **Categories** -- What data categories are collected and at what interval
- **Retention** -- How long performance data is kept
- **Monitoring** -- Whether system monitoring is enabled

### Temporary Storage Analysis
- **Named Buckets** -- System-level named temporary storage areas with current/peak sizes
- **Unnamed Storage** -- Aggregate usage of unnamed temporary storage
- **Per-job Usage** -- Which jobs consume the most temporary storage
- **Limit Tracking** -- Job-level storage limits vs current usage

### Disk I/O Performance
- **Per-unit Metrics** -- Read/write requests, data transferred, busy percentage
- **Elapsed Statistics** -- I/O during the measurement interval
- **Hot Spots** -- Identify the busiest disk units

### Memory Pool Performance
- **Fault Rates** -- Database and non-database page faults per pool
- **Thread Transitions** -- Active-to-wait, wait-to-ineligible counts
- **Tuning Parameters** -- Priority, min/max size, fault thresholds

## Common Use Cases

1. **Collection services audit** -- Verify performance data is being collected
2. **Temp storage investigation** -- Find jobs using excessive temporary storage
3. **Named bucket monitoring** -- Track system temp storage bucket growth
4. **Disk I/O hot spots** -- Identify the busiest disk units
5. **Memory pressure detection** -- Find pools with high page fault rates
6. **Performance baseline** -- Capture metrics for trend analysis
7. **Capacity planning** -- Analyze storage and I/O trends

## Quick Examples

### Check collection services configuration
```bash
ibmi tool get_collection_services_config --tools tools/
```

### View collection categories
```bash
ibmi tool get_collection_categories --tools tools/
```

### Top temp storage consumers by job
```bash
ibmi tool get_temp_storage_by_job --tools tools/
```

### Disk I/O performance
```sql
SELECT UNIT_NUMBER, ASP_NUMBER,
       ELAPSED_READ_REQUESTS, ELAPSED_WRITE_REQUESTS,
       ELAPSED_PERCENT_BUSY
  FROM QSYS2.SYSDISKSTAT
  WHERE ELAPSED_IO_REQUESTS > 0
  ORDER BY ELAPSED_PERCENT_BUSY DESC
  FETCH FIRST 10 ROWS ONLY;
```

### Named temp storage buckets
```sql
SELECT GLOBAL_BUCKET_NAME, BUCKET_CURRENT_SIZE, BUCKET_PEAK_SIZE
  FROM QSYS2.SYSTMPSTG
  WHERE GLOBAL_BUCKET_NAME IS NOT NULL
  ORDER BY BUCKET_CURRENT_SIZE DESC;
```

## Pre-built Tools

The `tools/performance.yaml` file provides 7 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_collection_services_config` | Collection services configuration and settings |
| `get_collection_categories` | Collection categories with their intervals |
| `get_temp_storage_buckets` | Named temporary storage bucket usage |
| `get_unnamed_temp_storage` | Aggregate unnamed temporary storage usage |
| `get_temp_storage_by_job` | Temporary storage consumption by job |
| `get_disk_io_performance` | Disk I/O performance stats per unit |
| `get_memory_pool_performance` | Memory pool fault rates and tuning metrics |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Performance Services Catalog](./references/performance-services.md) -- Available SQL services
- [Example SQL Patterns](./references/performance-examples.sql) -- Working query examples
- [IBM COLLECTION_SERVICES_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-collection-services-info-view) -- View documentation
- [IBM SYSTMPSTG](https://www.ibm.com/docs/en/i/7.5?topic=services-systmpstg-view) -- View documentation
