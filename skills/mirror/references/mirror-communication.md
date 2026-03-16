# MIRROR-COMMUNICATION Services

Services for monitoring network redundancy groups (NRGs) and RDMA communication between Db2 Mirror nodes.

## Read-Only Views

### NRG_INFO
Network redundancy group configuration, link counts, and aggregate traffic statistics.
- Key columns: NRG_NAME, NRG_STATE, LINK_COUNT, ACTIVE_LINK_COUNT, LOAD_BALANCE_LINK_COUNT, CONNECTIONS, LINK_FAILURES, OUTBOUND_RDMA_BYTES, INBOUND_RDMA_BYTES

### NRG_LINK_INFO
Individual NRG link details including addresses, state, and priority.
- Key columns: NRG_NAME, SOURCE_ADDRESS, TARGET_ADDRESS, LINK_STATE, LINK_PRIORITY, LINK_IN_USE, RDMA_TYPE

### RDMA_LINK_INFO
RDMA link traffic statistics and error counts.
- Key columns: SOURCE_ADDRESS, TARGET_ADDRESS, LINK_STATE, OUTBOUND_RDMA_BYTES, INBOUND_RDMA_BYTES, ACTIVE_CONNECTIONS, LINK_FAILURES, DROPPED_PACKETS, OUT_OF_SEQUENCE_PACKETS

### RDMA_CONNECTION_INFO
Individual RDMA connection details including ports, state, and buffer sizes.
- Key columns: SOURCE_ADDRESS, TARGET_ADDRESS, SOURCE_PORT, TARGET_PORT, CONNECTION_STATE, NRG_NAME, JOB_NAME, BYTES_IN, BYTES_OUT

## Procedures (not used by read-only tools)
- ADD_NRG_LINK, CHANGE_NRG, CHANGE_NRG_LINK, REMOVE_NRG_LINK
