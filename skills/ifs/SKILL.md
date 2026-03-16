---
name: ifs
description: "Browse, search, read, and inspect files in the IBM i Integrated File System (IFS) including authorities, locks, and server shares. Use when user asks about: (1) listing IFS directory contents, (2) searching for files by name or pattern, (3) reading text file contents, (4) checking file authorities or permissions, (5) diagnosing file lock contention, (6) finding large files consuming disk space, (7) viewing NetServer file shares, or (8) replacing WRKLNK, DSPAUT, DSPLNK command output."
---

# IBM i Integrated File System (IFS) Operations

Browse, search, read, and inspect files in the IFS including authorities, locks, and server shares using QSYS2 SQL services.

## Available Tools

The `ibmi` CLI is the primary tool for IFS operations:

```bash
ibmi tools --tools skills/ifs/tools/ --toolset ifs_default
ibmi tool list_ifs_directory --tools skills/ifs/tools/ --path /home
ibmi sql "SELECT PATH_NAME, DATA_SIZE FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS(START_PATH_NAME => '/tmp', SUBTREE_DIRECTORIES => 'NO'))"
```

## Service Selection Guide

### Browsing & Search
- **QSYS2.IFS_OBJECT_STATISTICS** -- List directory contents, search by name, find large files
- **QSYS2.SERVER_SHARE_INFO** -- NetServer file and print shares

### Security & Locks
- **QSYS2.IFS_OBJECT_PRIVILEGES** -- Authority settings for IFS objects
- **QSYS2.IFS_OBJECT_LOCK_INFO** -- Lock information and job contention

### Content
- **QSYS2.IFS_READ** -- Read text file contents line by line

## Key Capabilities

### File Browsing
- **Directory Listing** -- List contents of any IFS directory with type, size, owner
- **Recursive Search** -- Find files matching name patterns across directory trees
- **Large File Detection** -- Identify biggest files consuming disk space

### Security Analysis
- **Authority Review** -- Check read/write/execute authorities per user
- **Lock Diagnosis** -- Identify which jobs hold locks on files
- **Owner Information** -- Track file ownership across the IFS

### Content Access
- **Text File Reading** -- Read configuration files, logs, scripts
- **Share Management** -- View NetServer shares and connection counts

## Common Use Cases

1. **Browse directories** -- List contents of /home, /tmp, or application paths
2. **Find files** -- Search for configuration files, logs, or specific extensions
3. **Disk space analysis** -- Find largest files in a directory tree
4. **Authority audit** -- Check who has access to sensitive files
5. **Lock troubleshooting** -- Identify jobs blocking file access
6. **Read config files** -- View application configuration or properties files
7. **Share inventory** -- List all NetServer file shares

## Quick Examples

### List root directory
```bash
ibmi tool list_ifs_directory --tools skills/ifs/tools/ --path /
```

### Search for log files
```bash
ibmi tool search_ifs_by_name --tools skills/ifs/tools/ --path /home --name-pattern '%.log'
```

### Read a text file
```bash
ibmi tool read_ifs_file --tools skills/ifs/tools/ --path /etc/hosts
```

### Check file authorities
```bash
ibmi tool get_ifs_object_authorities --tools skills/ifs/tools/ --path /home/myuser
```

## Pre-built Tools

The `tools/ifs.yaml` file provides 8 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_ifs_directory` | List directory contents with type, size, owner |
| `get_ifs_object_info` | Detailed object info including journaling and CCSID |
| `search_ifs_by_name` | Recursive file search by name pattern |
| `list_ifs_large_objects` | Find largest files in a directory tree |
| `get_ifs_object_authorities` | Authority settings for IFS objects |
| `read_ifs_file` | Read text file contents line by line |
| `list_ifs_object_locks` | Lock information for file contention diagnosis |
| `list_server_shares` | NetServer file and print shares |

```bash
ibmi tool <tool_name> --tools skills/ifs/tools/          # Execute
ibmi tool <tool_name> --tools skills/ifs/tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools skills/ifs/tools/     # View details
```

## Reference Documentation

- [IFS Services Catalog](./references/ifs-services.md) -- Available SQL services
- [Example SQL Patterns](./references/ifs-examples.sql) -- Working query examples
- [IBM IFS_OBJECT_STATISTICS](https://www.ibm.com/docs/en/i/7.5?topic=services-ifs-object-statistics-table-function) -- Table function documentation
