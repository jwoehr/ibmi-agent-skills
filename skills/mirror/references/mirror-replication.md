# MIRROR-REPLICATION Services

Services for managing Db2 Mirror replication criteria that control which objects are included or excluded from replication.

## Read-Only Views

### REPLICATION_CRITERIA_INFO
All active replication criteria rules showing inclusion state, apply state, and object matching patterns.
- Key columns: RULE_IDENTIFIER, APPLY_STATE, INCLUSION_STATE, APPLY_LABEL, IASP_NAME, LIBRARY_NAME, OBJECT_TYPE, OBJECT_NAME, RULE_SOURCE, REMOVABLE, RESTRICTED, FAILURE_MESSAGE

## Table Functions
- **INSPECT_REPLICATION_CRITERIA** -- Inspect criteria for a specific object
- **EVALUATE_PENDING_REPLICATION_CRITERIA** -- Evaluate pending criteria changes
- **VALIDATE_PENDING_REPLICATION_CRITERIA** -- Validate before applying
- **CHECK_REPLICATION_CRITERIA** -- Scalar function to check single object

## Procedures (not used by read-only tools)
- ADD_REPLICATION_CRITERIA, REMOVE_REPLICATION_CRITERIA, PROCESS_PENDING_REPLICATION_CRITERIA
