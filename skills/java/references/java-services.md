# Java Services Catalog

SQL services used by the java skill for JVM monitoring and analysis.

## Primary Services

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | JVM_INFO | VIEW | Quick overview of active JVMs with memory and GC stats |
| QSYS2 | JVM_INFO | TABLE FUNCTION | Detailed JVM data with wait time and memory breakdown |
| QSYS2 | SET_JVM | PROCEDURE | Modify JVM properties (not used by read-only tools) |

## Key Column References

### JVM_INFO (VIEW and TABLE FUNCTION)
- JOB_NAME, JOB_NAME_SHORT, JOB_USER, JOB_NUMBER, PROCESS_ID
- START_TIME, JAVA_THREAD_COUNT, INITIAL_THREAD_TASKCOUNT
- TOTAL_GC_TIME, GC_CYCLE_NUMBER, GC_POLICY_NAME
- JAVA_HOME, USER_DIRECTORY, NUM_CURRENT_PROPERTIES
- INITIAL_HEAP_SIZE, CURRENT_HEAP_SIZE, IN_USE_HEAP_SIZE, MAX_HEAP_SIZE
- MALLOC_MEMORY_SIZE, INTERNAL_MEMORY_SIZE, JIT_MEMORY_SIZE, SHARED_CLASS_SIZE
- BIT_MODE

### TABLE FUNCTION Parameters
- WAIT_TIME -- Maximum seconds to wait for each JVM's data
