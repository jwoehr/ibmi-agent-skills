---
name: java
description: "Monitor Java Virtual Machines running on IBM i including heap memory usage, garbage collection activity, thread counts, and JVM configuration. Use when user asks about: (1) active JVMs on the system, (2) JVM heap or memory consumption, (3) garbage collection performance, (4) Java thread counts, (5) JVM home directories or properties, (6) identifying JVMs at risk of OutOfMemoryError, or (7) replacing WRKJVMJOB command output."
---

# IBM i Java & JVM Monitoring

Monitor Java Virtual Machines running on IBM i including heap memory, garbage collection, thread counts, and configuration using QSYS2.JVM_INFO.

## Available Tools

The `ibmi` CLI is the primary tool for executing JVM queries:

```bash
ibmi tools --tools tools/ --toolset java_default
ibmi tool list_jvms --tools tools/
ibmi sql "SELECT JOB_NAME, CURRENT_HEAP_SIZE, IN_USE_HEAP_SIZE FROM QSYS2.JVM_INFO"
```

## Service Selection Guide

### JVM Monitoring
- **QSYS2.JVM_INFO (VIEW)** -- Quick overview of all active JVMs
- **QSYS2.JVM_INFO (TABLE FUNCTION)** -- Detailed JVM data with wait time parameter for memory breakdown (malloc, internal, JIT, shared class)

## Key Capabilities

### Memory Analysis
- **Heap Usage** -- Current, in-use, and maximum heap sizes per JVM
- **Memory Breakdown** -- Malloc, internal, JIT, and shared class memory (via table function)
- **Threshold Alerts** -- Find JVMs exceeding heap usage percentages

### Performance Monitoring
- **Garbage Collection** -- Total GC time and cycle counts
- **Thread Counts** -- Java thread count per JVM
- **Uptime** -- JVM start times for stability tracking

### Configuration
- **Java Home** -- Which Java version each JVM uses
- **User Directory** -- Working directory for each JVM
- **Properties** -- Number of configured properties per JVM
- **Bit Mode** -- 32-bit vs 64-bit JVM identification

## Common Use Cases

1. **Find memory-hungry JVMs** -- Sort by heap usage to identify top consumers
2. **Detect GC pressure** -- High GC time or cycle count indicates memory issues
3. **Capacity planning** -- Track heap growth trends across JVMs
4. **Java version audit** -- Identify which Java homes are in use
5. **Troubleshoot OutOfMemoryError** -- Find JVMs near max heap

## Quick Examples

### List all active JVMs
```bash
ibmi tool list_jvms --tools tools/
```

### Find JVMs using more than 80% heap
```bash
ibmi tool list_jvms_by_heap_usage --tools tools/ --min-heap-pct 80
```

### Get detailed memory breakdown
```bash
ibmi tool get_jvm_detail --tools tools/ --wait-time 10
```

### Find JVMs with high GC activity
```bash
ibmi tool list_jvms_by_gc_activity --tools tools/ --min-gc-cycles 100
```

## Pre-built Tools

The `tools/java.yaml` file provides 5 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_jvms` | List all active JVMs with memory and GC stats |
| `get_jvm_detail` | Detailed JVM info including memory breakdown |
| `list_jvms_by_heap_usage` | Find JVMs by heap consumption percentage |
| `list_jvms_by_gc_activity` | Find JVMs with highest GC activity |
| `get_jvm_properties` | JVM configuration and property counts |

```bash
ibmi tool <tool_name> --tools tools/          # Execute
ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
ibmi tools show <tool_name> --tools tools/     # View details
```

## Reference Documentation

- [Java Services Catalog](./references/java-services.md) -- Available SQL services
- [Example SQL Patterns](./references/java-examples.sql) -- Working query examples
- [IBM JVM_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-jvm-info-view) -- View documentation
