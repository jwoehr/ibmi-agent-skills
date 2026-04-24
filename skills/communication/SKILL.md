---
name: communication
description: "Monitor and analyze IBM i network and communication resources including TCP/IP connections, network interfaces, routing, HTTP servers, and DNS configuration via SQL services. Use when user asks about: (1) active network connections and traffic, (2) network interface status and IP addresses, (3) routing tables, (4) HTTP server configuration and status, (5) TCP/IP settings and hostname, (6) NTP/SNTP time synchronization, (7) network attributes, or (8) replacing NETSTAT, WRKTCPSTS, CFGTCP, WRKhttpsrvr commands."
---

# IBM i Communication & Network Services

Monitor and analyze network and communication resources on IBM i using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing network queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/communication, ~/.claude/skills/communication

ibmi tools --tools "$SKILL_DIR/tools/" --toolset communication_default
ibmi tool get_netstat_info --tools "$SKILL_DIR/tools/"
ibmi sql "SELECT * FROM QSYS2.NETSTAT_INFO WHERE TCP_STATE = 'ESTABLISHED' FETCH FIRST 20 ROWS ONLY"
```

## Service Selection Guide

### Network Connections
- **QSYS2.NETSTAT_INFO** — Active connections with bytes, addresses, ports, state
- **QSYS2.NETSTAT_JOB_INFO** — Network jobs associated with connections
- **QSYS2.NETSTAT_INTERFACE_INFO** — Network interface configuration and status
- **QSYS2.NETSTAT_ROUTE_INFO** — TCP/IP routing table

### Server & Configuration
- **QSYS2.HTTP_SERVER_INFO** — HTTP server instances, ports, and status
- **QSYS2.TCPIP_INFO** — TCP/IP stack configuration (hostname, DNS, version)
- **QSYS2.NETWORK_ATTRIBUTE_INFO** — System-level network attributes
- **QSYS2.TIME_PROTOCOL_INFO** — NTP/SNTP server configuration and sync status

## Key Capabilities

### Network Monitoring
- List active connections sorted by traffic volume
- Identify busiest remote addresses and ports
- Monitor connection states (ESTABLISHED, LISTEN, etc.)
- Track bytes sent and received per connection

### Interface & Routing
- View all network interfaces with IP addresses and status
- Check subnet masks, MTU, and line descriptions
- Review routing table entries and precedence
- Identify active vs inactive interfaces

### Server Management
- List HTTP server instances with status and ports
- Check autostart configuration
- View server root directories and descriptions

### Configuration Review
- Retrieve hostname, domain, and DNS settings
- Check network authentication parameters
- Verify NTP/SNTP time synchronization status

## Common Use Cases

### 1. Connection Analysis
Identify active network connections and top bandwidth consumers

### 2. Network Troubleshooting
Check interface status, routing, and connection states

### 3. HTTP Server Monitoring
Verify web server status and port assignments

### 4. DNS & Network Config
Review TCP/IP settings, hostname, and DNS configuration

### 5. Time Sync Verification
Check NTP/SNTP server connectivity and synchronization

### 6. Security Audit
Identify unexpected remote connections or open ports

## CL Command Migration

| CL Command | SQL Service |
|------------|-------------|
| NETSTAT | NETSTAT_INFO + NETSTAT_INTERFACE_INFO |
| WRKTCPSTS | NETSTAT_INFO + NETSTAT_JOB_INFO |
| CFGTCP (display) | NETWORK_ATTRIBUTE_INFO + TCPIP_INFO |
| WRKHTTPSRVR | HTTP_SERVER_INFO |

## Quick Examples

### List established connections
```sql
SELECT REMOTE_ADDRESS, REMOTE_PORT, LOCAL_PORT, BIND_USER,
       BYTES_SENT_REMOTELY, BYTES_RECEIVED_LOCALLY
  FROM QSYS2.NETSTAT_INFO
  WHERE TCP_STATE = 'ESTABLISHED'
  ORDER BY BYTES_SENT_REMOTELY DESC
  FETCH FIRST 20 ROWS ONLY;
```

### Check network interfaces
```sql
SELECT INTERNET_ADDRESS, LINE_DESCRIPTION, INTERFACE_STATUS
  FROM QSYS2.NETSTAT_INTERFACE_INFO
  ORDER BY INTERFACE_STATUS;
```

### View HTTP servers
`QSYS2.HTTP_SERVER_INFO` is a performance-stats view — it returns per-server activity, not configuration.
```sql
SELECT SERVER_NAME, JOB_NAME, SERVER_ACTIVE_THREADS,
       SERVER_TOTAL_REQUESTS, BYTES_SENT, BYTES_RECEIVED
  FROM QSYS2.HTTP_SERVER_INFO
  ORDER BY SERVER_NAME;
```

## Pre-built Tools

The `tools/communication.yaml` file provides 11 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `get_netstat_info` | Active network connections with traffic |
| `get_netstat_interface_info` | Network interfaces and IP addresses |
| `get_netstat_job_info` | Network jobs and their connections |
| `get_netstat_route_info` | TCP/IP routing table |
| `get_http_server_info` | HTTP server instances and per-server request stats |
| `get_tcpip_info` | TCP/IP stack configuration |
| `get_network_attribute_info` | System network attributes |
| `get_time_protocol_info` | NTP/SNTP time server status |
| `list_active_db_connections` | Active DRDA/DDM database connections |
| `get_rdb_entry_info` | Relational database directory entries |
| `dns_lookup` | Resolve a hostname to IPv4/IPv6 addresses from the IBM i |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Communication Services Catalog](./references/communication-services.md) — All COMMUNICATION services
- [Communication Examples](./references/communication-examples.sql) — Working SQL examples
- [IBM i Services - Communication](https://www.ibm.com/support/pages/ibm-i-services-sql) — IBM documentation
