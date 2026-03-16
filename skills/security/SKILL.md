---
name: security
description: "Assess IBM i security posture including user privileges, object authorities, vulnerability detection, and function usage via SQL services. Use when user asks about: (1) user profiles with special authorities or limited capabilities, (2) object privileges and *PUBLIC authority exposure, (3) files vulnerable to trigger, rename, or library list attacks, (4) user impersonation vulnerabilities, (5) group profile membership, (6) function usage and access control, (7) security audit and compliance, or (8) replacing WRKOBJAUT, DSPUSRPRF, DSPAUTL commands."
---

# IBM i Security & Vulnerability Assessment

Assess security posture including user privileges, object authorities, vulnerability detection, and function usage using SQL services from QSYS2 and SYSTOOLS.

## Available Tools

The `ibmi` CLI is the primary tool for executing security queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/security, ~/.claude/skills/security

ibmi tools --tools "$SKILL_DIR/tools/" --toolset security_default
ibmi tool list_users_with_special_authorities --tools "$SKILL_DIR/tools/"
ibmi sql "SELECT AUTHORIZATION_NAME, SPECIAL_AUTHORITIES FROM QSYS2.USER_INFO_BASIC WHERE SPECIAL_AUTHORITIES IS NOT NULL"
```

The `ibmi-mcp-server` also provides `execute_sql` and `describe_sql_object` for MCP-connected agents.

## Service Selection Guide

### User Profiles & Authorities
- **QSYS2.USER_INFO_BASIC** -- User profiles with status, authorities, password settings
- **SYSTOOLS.SPECIAL_AUTHORITY_DATA_MART** -- Users with special authorities (*ALLOBJ, *SAVSYS, etc.)
- **QSYS2.GROUP_PROFILE_ENTRIES** -- Group profile membership
- **QSYS2.COMMAND_INFO** -- Commands allowed for limited-capability users

### Object & File Privileges
- **QSYS2.OBJECT_PRIVILEGES** -- Object-level authority details for any object type
- **QSYS2.LIBRARY_LIST_INFO** -- Library list entries for library list attack assessment

### Function Access
- **QSYS2.FUNCTION_USAGE** -- Function-level access control settings

## Key Capabilities

### User Security Analysis
- **Limited Capability Users** -- Find users with restricted command access
- **Special Authorities** -- Identify users with *ALLOBJ, *SAVSYS, *SECADM, etc.
- **Group Membership** -- Review who belongs to which group profiles
- **Function Access** -- Check who can use specific system functions

### Vulnerability Assessment
- **Impersonation Risk** -- Profiles where *PUBLIC is not *EXCLUDE
- **Attack Vector Commands** -- *PUBLIC authority on dangerous commands (ADDPFTRG, CRTPGM, etc.)
- **File Exposure** -- Database files readable/writable by *PUBLIC
- **Trigger Attacks** -- Files where *PUBLIC has read plus alter/manage authority
- **Library List Poisoning** -- System libraries where *PUBLIC can create tables

## Common Use Cases

1. **Security audit** -- Review user authorities and object exposure
2. **Vulnerability scan** -- Find files, profiles, and commands at risk
3. **Privilege review** -- List users with elevated special authorities
4. **Group analysis** -- Understand group profile membership and inherited rights
5. **Compliance check** -- Verify *PUBLIC authority is properly restricted
6. **Attack surface mapping** -- Identify library list and trigger attack vectors
7. **Function access review** -- Check who can access specific system functions

## Quick Examples

### Users with *ALLOBJ authority
```bash
ibmi tool list_users_with_special_authorities --tools "$SKILL_DIR/tools/" --authority-filter '*ALLOBJ'
```

### Profiles vulnerable to impersonation
```bash
ibmi tool list_profiles_vulnerable_to_impersonation --tools "$SKILL_DIR/tools/"
```

### Files exposed to trigger attack
```bash
ibmi tool list_files_exposed_to_trigger_attack --tools "$SKILL_DIR/tools/"
```

### Group profile members
```bash
ibmi tool list_group_profile_members --tools "$SKILL_DIR/tools/" --group-filter QSECOFR
```

## Pre-built Tools

The `tools/security.yaml` file provides 12 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_users_with_limited_capabilities` | Users configured with limited capabilities |
| `list_commands_for_limited_users` | Commands executable by limited-capability users |
| `list_users_with_special_authorities` | Users with special authorities from data mart |
| `list_profiles_vulnerable_to_impersonation` | Profiles where *PUBLIC is not *EXCLUDE |
| `list_public_authority_on_attack_commands` | *PUBLIC authority on dangerous commands |
| `list_db_files_readable_by_public` | Database files readable by any user |
| `list_files_exposed_to_trigger_attack` | Files vulnerable to trigger-based attacks |
| `list_system_libs_allowing_table_creation` | System libraries open to table creation |
| `list_group_profile_members` | Group profile membership entries |
| `list_function_usage` | Function-level access control settings |
| `list_authorization_lists` | Authorization lists and their secured objects |
| `list_authorization_list_users` | Users and their authorities on authorization lists |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Security Services Catalog](./references/security-services.md) -- Available SQL services
- [Example SQL Patterns](./references/security-examples.sql) -- Working query examples
- [IBM OBJECT_PRIVILEGES](https://www.ibm.com/docs/en/i/7.5?topic=services-object-privileges-view) -- View documentation
- [IBM USER_INFO_BASIC](https://www.ibm.com/docs/en/i/7.5?topic=services-user-info-basic-view) -- View documentation
