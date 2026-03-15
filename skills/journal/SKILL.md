---
name: journal
description: "Manage and inspect IBM i journals, journal receivers, journaled objects, journal entries, remote journals, and audit journal data marts. Use when user asks about: (1) listing journals or journal receivers, (2) which objects are journaled, (3) reading journal entries, (4) remote journal configuration and lag, (5) journal receiver sizes or chains, (6) SMAPP access path protection, (7) audit journal data marts, (8) journal storage consumption, or (9) replacing WRKJRN, DSPJRN, WRKJRNA command output."
---

# IBM i Journal Management

Manage and inspect journals, journal receivers, journaled objects, journal entries, remote journals, and audit data marts using QSYS2 SQL services.

## Available Tools

The `ibmi` CLI is the primary tool for journal queries:

```bash
ibmi tools --tools tools/ --toolset journal_default
ibmi tool list_journals --tools tools/
ibmi sql "SELECT JOURNAL_NAME, JOURNAL_LIBRARY, JOURNAL_TYPE FROM QSYS2.JOURNAL_INFO"
```

## Service Selection Guide

### Journal Configuration
- **QSYS2.JOURNAL_INFO** -- Journal properties, receiver counts, object counts
- **QSYS2.JOURNAL_RECEIVER_INFO** -- Receiver timestamps, sizes, entry counts, chain
- **QSYS2.JOURNALED_OBJECTS** -- Objects being journaled and their options

### Journal Entries
- **QSYS2.DISPLAY_JOURNAL** -- Read journal entries with filtering by time
- **SYSTOOLS.AUDIT_JOURNAL_xx** -- Typed audit journal entry readers (AD, AF, PW, etc.)
- **QSYS2.AUDIT_JOURNAL_DATA_MART_INFO** -- Audit data mart build status

### Remote & Access Paths
- **QSYS2.REMOTE_JOURNAL_INFO** -- Remote journal state, delivery mode, lag metrics
- **QSYS2.SMAPP_ACCESS_PATHS** -- System-managed access path protection

## Key Capabilities

### Journal Inventory
- **List Journals** -- Show all journals with type, state, and receiver info
- **Receiver Chain** -- Navigate the chain of receivers for a journal
- **Large Receivers** -- Find receivers consuming excessive storage
- **Detailed Config** -- Review journal settings including ESD and cache

### Entry Analysis
- **Display Entries** -- Read journal entries filtered by time range
- **Entry Metadata** -- Journal code, type, object, user, program info
- **Audit Trails** -- Track security-relevant events via audit journal

### Journaled Objects
- **Object Inventory** -- List all objects journaled by a specific journal
- **Journaling Options** -- Image settings and omit configurations
- **Remote Journals** -- Monitor remote journal lag and delivery mode

## Common Use Cases

1. **Journal inventory** -- List all journals and their current state
2. **Receiver management** -- Check receiver sizes and chain sequence
3. **Storage analysis** -- Find largest receivers consuming disk space
4. **Read entries** -- View recent journal entries for a journal
5. **Remote journal monitoring** -- Check replication lag
6. **Audit trail** -- Review audit journal data mart status
7. **SMAPP review** -- Check access path protection status

## Quick Examples

### List all journals
```bash
ibmi tool list_journals --tools tools/
```

### List receivers for a specific journal
```bash
ibmi tool list_journal_receiver_chain --tools tools/ --journal-library QSYS --journal-name QAUDJRN
```

### Read recent journal entries
```bash
ibmi tool display_journal_entries --tools tools/ --journal-library QSYS --journal-name QAUDJRN --minutes-ago 30
```

### Find largest receivers
```bash
ibmi tool list_large_journal_receivers --tools tools/ --min-size-mb 100
```

## Pre-built Tools

The `tools/journal.yaml` file provides 10 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_journals` | List journals with type, state, and receiver info |
| `list_journal_receivers` | Receivers with timestamps, status, and sizes |
| `list_journaled_objects` | Objects journaled by a specific journal |
| `display_journal_entries` | Read journal entries filtered by time |
| `list_remote_journals` | Remote journal config and lag metrics |
| `list_journal_receiver_chain` | Receiver chain for a specific journal |
| `list_large_journal_receivers` | Find largest receivers by size |
| `get_journal_detail` | Detailed journal configuration |
| `list_smapp_access_paths` | SMAPP access path protection status |
| `get_audit_journal_data_mart_info` | Audit data mart build status |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Journal Services Catalog](./references/journal-services.md) -- Available SQL services
- [Example SQL Patterns](./references/journal-examples.sql) -- Working query examples
- [IBM JOURNAL_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-journal-info-view) -- View documentation
- [IBM DISPLAY_JOURNAL](https://www.ibm.com/docs/en/i/7.5?topic=services-display-journal-table-function) -- Table function documentation
