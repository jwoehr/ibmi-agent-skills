# Security Services Catalog

SQL services used by the security skill for vulnerability assessment and audit.

## Primary Services

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | USER_INFO_BASIC | VIEW | User profiles with authorities and password settings |
| QSYS2 | OBJECT_PRIVILEGES | VIEW | Object-level authority details |
| QSYS2 | GROUP_PROFILE_ENTRIES | VIEW | Group profile membership |
| QSYS2 | FUNCTION_USAGE | VIEW | Function-level access control |
| QSYS2 | COMMAND_INFO | VIEW | Command metadata including limited user access |
| QSYS2 | LIBRARY_LIST_INFO | VIEW | Library list for attack surface analysis |
| SYSTOOLS | SPECIAL_AUTHORITY_DATA_MART | MQT | Users with special authorities |

## Key Column References

### USER_INFO_BASIC
- AUTHORIZATION_NAME, STATUS, SPECIAL_AUTHORITIES, USER_CLASS_NAME
- LIMIT_CAPABILITIES, PASSWORD_EXPIRATION_INTERVAL, PREVIOUS_SIGNON

### OBJECT_PRIVILEGES
- SYSTEM_OBJECT_SCHEMA, SYSTEM_OBJECT_NAME, OBJECT_TYPE, AUTHORIZATION_NAME
- OBJECT_AUTHORITY, OWNER, OBJECT_OPERATIONAL, OBJECT_MANAGEMENT
- OBJECT_ALTER, DATA_READ, DATA_ADD, DATA_UPDATE, DATA_DELETE, DATA_EXECUTE

### GROUP_PROFILE_ENTRIES
- GROUP_PROFILE_NAME, USER_PROFILE_NAME, USER_TEXT

### FUNCTION_USAGE
- FUNCTION_ID, USER_NAME, USAGE, USER_TYPE

### COMMAND_INFO
- COMMAND_NAME, COMMAND_LIBRARY, ALLOW_LIMITED_USER, TEXT_DESCRIPTION

### SPECIAL_AUTHORITY_DATA_MART
- AUTHORIZATION_NAME, SPECIAL_AUTHORITY, AUTHORITY_SOURCE, STATUS
