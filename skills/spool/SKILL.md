---
name: spool
description: "Manage and analyze spooled files, output queues, and printer configurations on IBM i via SQL services. Use when user asks about: (1) listing or searching output queues, (2) viewing spooled file entries by queue, user, or status, (3) reading spool file content, (4) identifying top spool consumers or old spool files, (5) printer file definitions, (6) spool storage analysis, (7) replacing WRKSPLF, WRKOUTQ, WRKOBJLCK commands, or (8) any spool file management task."
---

# IBM i Spool File Management

Manage and analyze spooled files, output queues, and printer configurations using SQL services from QSYS2 and SYSTOOLS.

## Available Tools

The `ibmi` CLI is the primary tool for executing spool queries:

```bash
# List all spool tools
ibmi tools --tools skills/spool/tools/ --toolset spool_default

# Run a specific tool
ibmi tool list_output_queues --tools skills/spool/tools/

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.OUTPUT_QUEUE_ENTRIES_BASIC WHERE USER_NAME = 'MYUSER'"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### Output Queue Management
- **QSYS2.OUTPUT_QUEUE_INFO** -- Output queue configuration, status, writer info
- **QSYS2.OUTPUT_QUEUE_ENTRIES** -- Detailed spooled file entries per output queue (51 columns)
- **QSYS2.OUTPUT_QUEUE_ENTRIES_BASIC** -- Lightweight spooled file listing (16 columns, faster)

### Spooled File Operations
- **QSYS2.SPOOLED_FILE_INFO()** -- Detailed spool file attributes per job (table function)
- **SYSTOOLS.SPOOLED_FILE_DATA()** -- Read actual spool file content line by line (table function)

### Printer Configuration
- **QSYS2.SYSTABLES (FILE_TYPE='P')** -- Printer file definitions

## Key Capabilities

### Output Queue Operations
- **List Queues** -- Find output queues by library, see file counts and writer status
- **Browse Entries** -- View spool files in a specific output queue with status and size
- **System-wide Search** -- Search across all queues by user, status, or date

### Spool File Analysis
- **Per-job Detail** -- Get spool file attributes, page counts, and output queue placement
- **Read Content** -- Extract text from spooled files line by line
- **Storage Analysis** -- Identify top consumers, find old files, get storage summaries

### Cleanup Planning
- **Age-based Search** -- Find spool files older than N days
- **User Consumption** -- Show total files, pages, and bytes per user
- **Status Distribution** -- Count files by status (READY, HELD, SAVED)

## Common Use Cases

1. **Find a user's spool files** -- Filter by user across all output queues
2. **Check output queue status** -- See file counts, writer status, queue configuration
3. **Read report output** -- Extract text content from a specific spooled file
4. **Identify cleanup targets** -- Find old spool files or top storage consumers
5. **Storage capacity planning** -- Get total spool usage with status breakdown
6. **Troubleshoot print jobs** -- View spool file details for a specific job
7. **Audit printer files** -- List printer file definitions by library
8. **Monitor output queues** -- Check which queues have the most files waiting

## Quick Examples

### List output queues with most files
```bash
ibmi tool list_output_queues --tools skills/spool/tools/
```

### Find spool files for a user
```bash
ibmi tool list_spool_files_basic --tools skills/spool/tools/ user_filter=MYUSER
```

### Find old spool files (90+ days)
```bash
ibmi tool find_old_spool_files --tools skills/spool/tools/ days_old=90
```

### Read spool file content
```sql
SELECT ORDINAL_POSITION, SPOOLED_DATA
  FROM TABLE(SYSTOOLS.SPOOLED_FILE_DATA(
    JOB_NAME => '123456/MYUSER/MYJOB',
    SPOOLED_FILE_NAME => 'QPJOBLOG'))
  ORDER BY ORDINAL_POSITION;
```

### Top spool storage consumers
```sql
SELECT USER_NAME, COUNT(*) AS TOTAL_FILES,
       SUM(TOTAL_PAGES) AS TOTAL_PAGES, SUM(SIZE) AS TOTAL_SIZE
  FROM QSYS2.OUTPUT_QUEUE_ENTRIES_BASIC
  GROUP BY USER_NAME
  ORDER BY TOTAL_SIZE DESC
  FETCH FIRST 10 ROWS ONLY;
```

## Pre-built Tools

The `tools/spool.yaml` file provides 9 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_output_queues` | Output queues with file counts, writer status, and configuration |
| `list_output_queue_entries` | Spool files in a specific output queue |
| `list_spool_files_basic` | System-wide spool file search by user and status |
| `get_spooled_file_info` | Detailed spool file attributes for a job |
| `read_spooled_file_data` | Read spool file text content line by line |
| `top_spool_consumers` | Top spool storage consumers by user |
| `find_old_spool_files` | Find spool files older than N days |
| `get_printer_file_info` | Printer file definitions on the system |
| `spool_storage_summary` | System-wide spool storage summary with status counts |

```bash
ibmi tool <tool_name> --tools skills/spool/tools/          # Execute
ibmi tool <tool_name> --tools skills/spool/tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools skills/spool/tools/     # View details
```

## Reference Documentation

- [Spool Services Catalog](./references/spool-services.md) -- Available SQL services
- [Example SQL Patterns](./references/spool-examples.sql) -- Working query examples
- [IBM OUTPUT_QUEUE_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-output-queue-info-view) -- View documentation
- [IBM SPOOLED_FILE_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-spooled-file-info-table-function) -- Table function documentation
