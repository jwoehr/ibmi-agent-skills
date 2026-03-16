---
name: message-handling
description: "Read and analyze message queues, system history log, reply lists, and message file definitions on IBM i via SQL services. Use when user asks about: (1) reading QSYSOPR or other message queues, (2) searching the system history log (QHST), (3) finding high-severity messages, (4) viewing the system reply list, (5) looking up message definitions (CPF, MCH, SQL messages), (6) message severity analysis, (7) replacing DSPMSG, DSPLOG, WRKMSGQ commands, or (8) any message handling or troubleshooting task."
---

# IBM i Message Handling

Read and analyze message queues, system history log, reply lists, and message file definitions using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing message queries:

```bash
# List all message handling tools
ibmi tools --tools tools/ --toolset message_handling_default

# Run a specific tool
ibmi tool read_message_queue --tools tools/

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.MESSAGE_QUEUE_INFO WHERE MESSAGE_QUEUE_NAME = 'QSYSOPR' AND MESSAGE_QUEUE_LIBRARY = 'QSYS' FETCH FIRST 10 ROWS ONLY"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### Message Queues
- **QSYS2.MESSAGE_QUEUE_INFO** (view) -- Read messages from any message queue
- **QSYS2.MESSAGE_QUEUE_INFO()** (table function) -- Parameterized message queue access

### System History Log
- **QSYS2.HISTORY_LOG_INFO()** -- System-wide history log entries (QHST equivalent)

### Reply Management
- **QSYS2.REPLY_LIST_INFO** -- System reply list entries for automatic responses

### Message Definitions
- **QSYS2.MESSAGE_FILE_DATA** -- Message templates, severity, and reply configuration

## Key Capabilities

### Message Queue Operations
- **Read Messages** -- View messages from any queue (QSYSOPR, QPGMR, user queues)
- **Severity Filtering** -- Focus on warnings (30+) or errors (40+)
- **Severity Distribution** -- Count messages by severity level
- **Sender Tracking** -- See which users and jobs sent messages

### History Log Analysis
- **Full Log Access** -- Read the system history log with severity filtering
- **Text Search** -- Search by message ID or message text content
- **Source Tracking** -- See originating user, job, and program

### Message Definitions
- **Message Lookup** -- Find message definitions by ID or prefix (CPF, MCH, SQL)
- **Reply Config** -- See default replies and valid reply values
- **Cross-file Search** -- Query any message file (QCPFMSG, QRPGMSG, etc.)

### Reply List
- **Auto-reply Rules** -- View the system reply list entries
- **Comparison Data** -- See which messages trigger automatic replies

## Common Use Cases

1. **System operator messages** -- Check QSYSOPR for pending operator messages
2. **Error investigation** -- Search history log for specific error messages
3. **High-severity alerts** -- Find messages at severity 40+ across queues
4. **Message lookup** -- Look up what a CPF or MCH message means
5. **Severity audit** -- Get distribution of message severities in a queue
6. **Reply list review** -- Check what automatic replies are configured
7. **Job troubleshooting** -- Search history log for messages from a specific job
8. **Security monitoring** -- Monitor message queues for security-related events

## Quick Examples

### Read system operator messages
```bash
ibmi tool read_message_queue --tools tools/
```

### Find high-severity messages (40+)
```bash
ibmi tool read_high_severity_messages --tools tools/ severity_min=40
```

### Search history log
```bash
ibmi tool search_history_log --tools tools/ search_term=CPF1124
```

### Look up a message definition
```sql
SELECT MESSAGE_ID, MESSAGE_TEXT, SEVERITY
  FROM QSYS2.MESSAGE_FILE_DATA
  WHERE MESSAGE_FILE = 'QCPFMSG'
    AND MESSAGE_FILE_LIBRARY = 'QSYS'
    AND MESSAGE_ID = 'CPF1124';
```

### Count messages by severity
```sql
SELECT SEVERITY, COUNT(*) AS MESSAGE_COUNT
  FROM QSYS2.MESSAGE_QUEUE_INFO
  WHERE MESSAGE_QUEUE_NAME = 'QSYSOPR'
    AND MESSAGE_QUEUE_LIBRARY = 'QSYS'
  GROUP BY SEVERITY
  ORDER BY SEVERITY DESC;
```

## Pre-built Tools

The `tools/message-handling.yaml` file provides 8 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `read_message_queue` | Read messages from any message queue (defaults to QSYSOPR) |
| `read_high_severity_messages` | Messages filtered by minimum severity level |
| `get_history_log` | System history log entries with severity filter |
| `search_history_log` | Search history log by message ID or text |
| `get_reply_list` | System reply list entries for automatic responses |
| `search_message_file` | Look up message definitions by ID or prefix |
| `count_messages_by_severity` | Message count distribution by severity level |
| `get_joblog_info` | Job log messages for a specific job or the current job |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Message Handling Services Catalog](./references/message-handling-services.md) -- Available SQL services
- [Example SQL Patterns](./references/message-handling-examples.sql) -- Working query examples
- [IBM MESSAGE_QUEUE_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-message-queue-info-view) -- View documentation
- [IBM HISTORY_LOG_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-history-log-info-table-function) -- Table function documentation
