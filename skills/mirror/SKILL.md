---
name: mirror
description: "Monitor Db2 Mirror for IBM i including replication status, cluster topology, NRG communication, RDMA links, replication criteria, resynchronization, reclone readiness, and flight recorder diagnostics. Use when user asks about: (1) mirror replication status or health, (2) cluster node topology, (3) NRG or RDMA link status, (4) takeover IP addresses, (5) replication inclusion/exclusion rules, (6) resynchronization progress, (7) reclone security objects, (8) mirror version compatibility, (9) flight recorder logging, or (10) ObjectConnect state."
---

# IBM i Db2 Mirror Monitoring

Monitor Db2 Mirror replication, cluster topology, NRG communication, RDMA links, replication criteria, and diagnostics using QSYS2 SQL services.

## Available Tools

The `ibmi` CLI is the primary tool for mirror monitoring:

```bash
ibmi tools --tools skills/mirror/tools/ --toolset mirror_default
ibmi tool list_mirror_status --tools skills/mirror/tools/
ibmi sql "SELECT IASP_NAME, REPLICATION_STATE FROM QSYS2.MIRROR_INFO"
```

## Service Selection Guide

### Product Status (MIRROR-PRODUCT)
- **QSYS2.MIRROR_INFO** -- Replication state, node roles, auto-resume
- **QSYS2.MIRROR_CLUSTER_INFO** -- Cluster topology and IP addresses
- **QSYS2.MIRROR_HEALTH_MONITOR_INFO** -- Health monitor configuration
- **QSYS2.MIRROR_TAKEOVER_INFO** -- Takeover IP groups and addresses
- **QSYS2.MIRROR_VERSION_LIST** -- Version compatibility tracking
- **QSYS2.MIRROR_OBJECTCONNECT_INFO** -- ObjectConnect subsystem state

### Communication (MIRROR-COMMUNICATION)
- **QSYS2.NRG_INFO** -- Network redundancy group configuration and stats
- **QSYS2.NRG_LINK_INFO** -- Individual NRG link state and priority
- **QSYS2.RDMA_LINK_INFO** -- RDMA link traffic and error statistics
- **QSYS2.RDMA_CONNECTION_INFO** -- RDMA connection details

### Replication (MIRROR-REPLICATION)
- **QSYS2.REPLICATION_CRITERIA_INFO** -- Inclusion/exclusion rules

### Reclone (MIRROR-RECLONE)
- **QSYS2.CONFIRM_RECLONE_SECURITY_OBJECTS** -- Security objects for reclone

### Serviceability (MIRROR-SERVICEABILITY)
- **QSYS2.MIRROR_FLIGHT_RECORDER_INFO** -- Flight recorder config and logging levels

## Key Capabilities

### Replication Health
- **Status Check** -- Replication state per IASP (ACTIVE, SUSPENDED, etc.)
- **Node Roles** -- Primary/secondary node identification
- **Auto-Resume** -- Whether replication auto-resumes after interruption
- **NRG State** -- Network redundancy group health

### Cluster Topology
- **Node Info** -- Cluster name, device domain, node names
- **IP Addresses** -- Primary and secondary IPs for each node
- **Takeover Groups** -- IP takeover configuration and current placement
- **Version Tracking** -- Mirror version compatibility between nodes

### Communication Monitoring
- **NRG Health** -- Link counts, active links, load balancing
- **NRG Links** -- Individual link state, priority, and type
- **RDMA Traffic** -- Bytes in/out, message counts, error statistics
- **Link Failures** -- Dropped packets, sequence errors

### Replication Management
- **Criteria Rules** -- Which objects are included or excluded
- **Rule State** -- Applied vs pending criteria
- **Reclone Readiness** -- Security objects that need confirmation

## Common Use Cases

1. **Health check** -- Verify replication is active and healthy
2. **Topology review** -- Understand cluster nodes and IPs
3. **Network diagnosis** -- Check NRG/RDMA link status and errors
4. **Takeover readiness** -- Verify IP groups on preferred nodes
5. **Replication audit** -- Review inclusion/exclusion criteria
6. **Version check** -- Ensure mirror versions are compatible
7. **Diagnostics** -- Review flight recorder settings

## Quick Examples

### Check replication status
```bash
ibmi tool list_mirror_status --tools skills/mirror/tools/
```

### View cluster topology
```bash
ibmi tool list_mirror_cluster --tools skills/mirror/tools/
```

### Check NRG link health
```bash
ibmi tool list_nrg_links --tools skills/mirror/tools/
```

### Review replication criteria
```bash
ibmi tool list_replication_criteria --tools skills/mirror/tools/
```

## Pre-built Tools

The `tools/mirror.yaml` file provides 12 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_mirror_status` | Replication state per IASP |
| `list_mirror_cluster` | Cluster topology and IPs |
| `list_mirror_health_monitor` | Health monitor configuration |
| `list_mirror_takeover` | Takeover IP groups |
| `list_mirror_versions` | Version compatibility tracking |
| `list_nrg_info` | NRG configuration and stats |
| `list_nrg_links` | Individual NRG link state |
| `list_rdma_links` | RDMA link traffic and errors |
| `list_replication_criteria` | Inclusion/exclusion rules |
| `list_mirror_flight_recorder` | Flight recorder config |
| `list_confirm_reclone_security` | Reclone security objects |
| `get_mirror_objectconnect_info` | ObjectConnect state |

```bash
ibmi tool <tool_name> --tools skills/mirror/tools/          # Execute
ibmi tool <tool_name> --tools skills/mirror/tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools skills/mirror/tools/     # View details
```

## Reference Documentation

- [Mirror Services Catalog](./references/mirror-services.md) -- All mirror SQL services
- [Example SQL Patterns](./references/mirror-examples.sql) -- Working query examples
- [Mirror Product](./references/mirror-product.md) -- MIRROR-PRODUCT services
- [Mirror Communication](./references/mirror-communication.md) -- MIRROR-COMMUNICATION services
- [Mirror Replication](./references/mirror-replication.md) -- MIRROR-REPLICATION services
- [Mirror Reclone](./references/mirror-reclone.md) -- MIRROR-RECLONE services
- [Mirror Serviceability](./references/mirror-serviceability.md) -- MIRROR-SERVICEABILITY services
- [Mirror Resynchronization](./references/mirror-resynchronization.md) -- MIRROR-RESYNCHRONIZATION services
