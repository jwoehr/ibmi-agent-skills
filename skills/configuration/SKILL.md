---
name: configuration
description: "Query IBM i system configuration including system values, hardware resources, device status, environment variables, and JVM settings via SQL services. Use when user asks about: (1) system value settings like QSECURITY or QCCSID, (2) security-related system values, (3) hardware resource inventory, (4) controller, device, or line status, (5) environment variable settings, (6) active JVM information, (7) replacing DSPSYSVAL, DSPHDWRSC, WRKCFGSTS, WRKENVVAR commands, or (8) any system configuration review."
---

# IBM i System Configuration

Query system configuration including system values, hardware resources, device status, environment variables, and JVM settings using SQL services from QSYS2 and SYSTOOLS.

## Available Tools

The `ibmi` CLI is the primary tool for executing configuration queries:

```bash
ibmi tools --tools tools/ --toolset configuration_default
ibmi tool get_system_values --tools tools/
ibmi sql "SELECT * FROM QSYS2.SYSTEM_VALUE_INFO WHERE SYSTEM_VALUE_NAME = 'QSECURITY'"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### System Values
- **QSYS2.SYSTEM_VALUE_INFO** -- All system values with current and default settings

### Hardware & Devices
- **QSYS2.HARDWARE_RESOURCE_INFO** -- Processors, storage, communication adapters, etc.
- **SYSTOOLS.CONFIGURATION_STATUS** -- Controllers, devices, and lines with status

### Environment
- **QSYS2.ENVIRONMENT_VARIABLE_INFO** -- System and job-level environment variables
- **QSYS2.JVM_INFO** -- Active Java Virtual Machines with heap and GC metrics

## Key Capabilities

### System Values
- **Full Catalog** -- Browse all system values by category
- **Single Lookup** -- Get a specific system value by name
- **Security Focus** -- Dedicated security system values view (QSECURITY, QAUDCTL, etc.)
- **Default Comparison** -- Compare current values against shipped defaults

### Hardware Inventory
- **Resource Listing** -- All hardware resources with status and identification
- **Status Filtering** -- Find operational, failed, or varied-off resources
- **Device Types** -- Processors, disk, tape, communication, crypto, optical

### Configuration Status
- **Device Health** -- Controllers, devices, and lines with current status
- **Type Filtering** -- Filter by *CTLD, *DEV, or *LIN
- **Timestamp Tracking** -- Creation and last-change timestamps

### Runtime Environment
- **Environment Variables** -- System and job-level PASE/ILE settings
- **JVM Monitoring** -- Active Java runtimes with heap, GC, and thread info

## Common Use Cases

1. **Security review** -- Check security-related system values
2. **Configuration audit** -- Compare system values against best practices
3. **Hardware inventory** -- List all system hardware resources
4. **Device troubleshooting** -- Find failed or varied-off devices
5. **JVM monitoring** -- Review active Java environments and heap usage
6. **Environment check** -- Verify PATH, LANG, and other environment settings
7. **System value lookup** -- Quick lookup of any specific system value

## Quick Examples

### Security system values
```bash
ibmi tool get_security_system_values --tools tools/
```

### Look up a specific system value
```bash
ibmi tool get_system_value --tools tools/ --sysval-name QSECURITY
```

### Hardware resources
```bash
ibmi tool get_hardware_resources --tools tools/
```

### Configuration object status
```bash
ibmi tool get_configuration_status --tools tools/
```

## Pre-built Tools

The `tools/configuration.yaml` file provides 7 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_system_values` | System values with category filtering |
| `get_system_value` | Single system value lookup by name |
| `get_security_system_values` | Security-related system values |
| `get_hardware_resources` | Hardware resource inventory with status filter |
| `get_configuration_status` | Controller, device, and line status |
| `get_environment_variables` | System and job environment variables |
| `get_jvm_info` | Active JVM heap, GC, and thread information |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Configuration Services Catalog](./references/configuration-services.md) -- Available SQL services
- [Example SQL Patterns](./references/configuration-examples.sql) -- Working query examples
- [IBM SYSTEM_VALUE_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-system-value-info-view) -- View documentation
- [IBM HARDWARE_RESOURCE_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-hardware-resource-info-view) -- View documentation
