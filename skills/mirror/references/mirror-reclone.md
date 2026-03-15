# MIRROR-RECLONE Services

Services for evaluating and executing reclone operations to resynchronize specific objects between Db2 Mirror nodes.

## Read-Only Views

### CONFIRM_RECLONE_SECURITY_OBJECTS
Security objects that need confirmation before recloning, showing presence and tracking status on source and target nodes.
- Key columns: OBJECT_TYPE, OBJECT_NAME, OBJECT_ON_SOURCE, OBJECT_ON_TARGET, TRACKED_ON_SOURCE, TRACKED_ON_TARGET

## Table Functions
- **CONFIRM_RECLONED_LIBRARY_DIFFERENCES** -- Identify library-level differences between nodes
- **EVALUATE_RECLONE_JOURNALED_OBJECTS** -- Check journaled objects for reclone readiness
- **EVALUATE_RECLONE_RELATED_OBJECTS** -- Find related objects that may need recloning
- **EVALUATE_RECLONE_REPLICATION_CRITERIA** -- Evaluate replication criteria impact

## Procedures (not used by read-only tools)
- RECLONE_OBJECT -- Reclone a single object
- RECLONE_REPLICATED_OBJECTS -- Reclone all replicated objects
