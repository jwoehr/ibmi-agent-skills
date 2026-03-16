# MIRROR-RESYNCHRONIZATION Services

Services for monitoring and managing object resynchronization between Db2 Mirror nodes after suspension events.

## Read-Only Views

### RESYNC_STATUS
Object tracking list (OTL) showing objects pending resynchronization with tracking time, resync type, and completion status.
- Note: This view requires an active Db2 Mirror environment. It will return SQL0204 on systems where mirror is not configured.

## Table Functions
- **COMPARE_RESYNC_STATUS** -- Compare resync status between nodes
- **MIRROR_SUSPENDING_JOBS** -- Identify jobs that are causing or have caused mirror suspension

## Procedures (not used by read-only tools)
- CHANGE_RESYNC_ENTRIES -- Modify resync tracking entries
- SET_RESYNC_PRIORITIES -- Set priorities for resync processing order
