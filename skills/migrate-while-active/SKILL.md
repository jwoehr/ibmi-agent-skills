---
name: migrate-while-active
description: "Monitor IBM i Migrate While Active environments including migration manager state, library and IFS object tracking, migrated objects, compression factors, synchronization estimates, and network bandwidth. Use when user asks about: (1) migration status or progress, (2) library or IFS objects being migrated, (3) migration failures or errors, (4) completed migrations, (5) data compression ratios, (6) final synchronization time estimates, (7) migration network bandwidth, or (8) cutover planning."
---

# IBM i Migrate While Active Monitoring

Monitor Migrate While Active environments including migration manager state, library and IFS tracking, compression, and synchronization estimates using QSYS2 SQL services.

## Available Tools

The `ibmi` CLI is the primary tool for migration monitoring:

```bash
ibmi tools --tools skills/migrate-while-active/tools/ --toolset migrate_while_active_default
ibmi tool get_migration_manager_info --tools skills/migrate-while-active/tools/
ibmi sql "SELECT * FROM QSYS2.MIGRATION_MANAGER_INFO"
```

## Service Selection Guide

### Migration Status
- **QSYS2.MIGRATION_MANAGER_INFO** -- Overall migration state, phase, and node info
- **QSYS2.LIBRARY_MIGRATION_LIST** -- Library objects being tracked for migration
- **QSYS2.IFS_MIGRATION_LIST** -- IFS objects being tracked for migration

### Completed Migrations
- **QSYS2.MIGRATED_LIBRARY** -- Successfully migrated library objects
- **QSYS2.MIGRATED_IFS** -- Successfully migrated IFS objects

### Planning & Estimation
- **SYSIBMADM.DATA_COMPRESSION_FACTOR** -- Compression ratios for data types
- **QSYS2.ESTIMATE_FINAL_SYNCHRONIZATION_TIME** -- Final sync time estimate
- **QSYS2.MIGRATION_NETWORK_BANDWIDTH** -- Network bandwidth measurements

## Key Capabilities

### Migration Tracking
- **Manager Status** -- Current migration phase, stage, and node states
- **Library Migration** -- Track library-based object migration progress
- **IFS Migration** -- Track IFS object migration progress
- **Failure Detection** -- Identify objects that failed to migrate

### Completion Monitoring
- **Migrated Libraries** -- Verify library objects completed migration
- **Migrated IFS** -- Verify IFS objects completed migration
- **Time-based Filtering** -- Show objects migrated within recent hours

### Cutover Planning
- **Compression Analysis** -- Understand data compression ratios
- **Sync Time Estimate** -- Predict final synchronization duration
- **Bandwidth Testing** -- Measure network throughput to copy node

## Common Use Cases

1. **Check migration status** -- Get overall migration phase and progress
2. **Monitor library progress** -- Track which libraries are migrating
3. **Identify failures** -- Find objects that failed to migrate
4. **Verify completion** -- Confirm objects successfully migrated
5. **Plan cutover** -- Estimate final sync time and bandwidth
6. **Troubleshoot** -- Investigate migration failures and bottlenecks

## Quick Examples

### Check overall migration status
```bash
ibmi tool get_migration_manager_info --tools skills/migrate-while-active/tools/
```

### List objects being migrated
```bash
ibmi tool list_library_migration --tools skills/migrate-while-active/tools/
```

### Find migration failures
```bash
ibmi tool list_migration_failures --tools skills/migrate-while-active/tools/
```

### Estimate final sync time
```bash
ibmi tool estimate_final_sync_time --tools skills/migrate-while-active/tools/
```

## Pre-built Tools

The `tools/migrate-while-active.yaml` file provides 9 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_migration_manager_info` | Overall migration state, phase, and nodes |
| `list_library_migration` | Library objects being tracked for migration |
| `list_ifs_migration` | IFS objects being tracked for migration |
| `list_migrated_libraries` | Successfully migrated library objects |
| `list_migrated_ifs` | Successfully migrated IFS objects |
| `list_migration_failures` | Library migration objects with failures |
| `get_data_compression_factor` | Compression ratios by type |
| `estimate_final_sync_time` | Final synchronization time estimate |
| `check_migration_network_bandwidth` | Network bandwidth to copy node |

```bash
ibmi tool <tool_name> --tools skills/migrate-while-active/tools/          # Execute
ibmi tool <tool_name> --tools skills/migrate-while-active/tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools skills/migrate-while-active/tools/     # View details
```

## Reference Documentation

- [Migration Services Catalog](./references/migrate-while-active-services.md) -- Available SQL services
- [Example SQL Patterns](./references/migrate-while-active-examples.sql) -- Working query examples
- [IBM MIGRATION_MANAGER_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-migration-manager-info-view) -- View documentation
