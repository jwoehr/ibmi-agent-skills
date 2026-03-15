# MIRROR-SERVICEABILITY Services

Services for Db2 Mirror diagnostics including flight recorder configuration, object comparison, and mirror-specific journal display.

## Read-Only Views

### MIRROR_FLIGHT_RECORDER_INFO
Flight recorder configuration including retention, storage limits, error counts, and per-component logging levels.
- Key columns: ARCHIVE_RETENTION_DAY_COUNT, MAX_SYSBAS_PERCENTAGE, ENQUEUE_ERROR_COUNT, DEQUEUE_ERROR_COUNT, LOGGING_ERROR_COUNT
- Logging levels: FLIGHT_RECORDER_LOGGING_LEVEL, ENGINE_CONTROLLER_LOGGING_LEVEL, OBJECT_REPLICATION_MANAGER_LOGGING_LEVEL, ENGINE_COMMUNICATION_LOGGING_LEVEL, RCL_LOGGING_LEVEL, NRG_LOGGING_LEVEL, RESYNC_LOGGING_LEVEL, HEALTH_MONITOR_LOGGING_LEVEL

## Table Functions
- **MIRROR_COMPARE_OBJECT** -- Compare a specific object between nodes
- **MIRROR_DISPLAY_JOURNAL** -- Display mirror-specific journal entries

## Procedures (not used by read-only tools)
- MIRROR_COMPARE_LIBRARY -- Compare all objects in a library
- MIRROR_COMPARE_NODE -- Compare entire node
- SET_MIRROR_FLIGHT_RECORDER_INFO -- Change flight recorder settings
- SET_MIRROR_FLIGHT_RECORDER_ALL_LEVELS -- Set all logging levels
