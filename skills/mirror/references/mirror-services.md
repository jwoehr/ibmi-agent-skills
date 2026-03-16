# Mirror Services Catalog

SQL services used by the mirror skill across all six Db2 Mirror sub-categories.

## Services by Category

### MIRROR-PRODUCT (25 services)

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | MIRROR_INFO | VIEW | Replication state per IASP |
| QSYS2 | MIRROR_CLUSTER_INFO | VIEW | Cluster topology and IPs |
| QSYS2 | MIRROR_HEALTH_MONITOR_INFO | VIEW | Health monitor config |
| QSYS2 | MIRROR_TAKEOVER_INFO | VIEW | Takeover IP groups |
| QSYS2 | MIRROR_VERSION_LIST | VIEW | Version compatibility |
| QSYS2 | MIRROR_OBJECTCONNECT_INFO | VIEW | ObjectConnect state |
| QSYS2 | SETUP_MIRROR | PROCEDURE | Initial mirror setup |
| QSYS2 | TERMINATE_MIRROR | PROCEDURE | Remove mirror config |
| QSYS2 | SWAP_MIRROR_ROLES | PROCEDURE | Switch primary/secondary |

### MIRROR-COMMUNICATION (8 services)

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | NRG_INFO | VIEW | NRG configuration and stats |
| QSYS2 | NRG_LINK_INFO | VIEW | Individual NRG link state |
| QSYS2 | RDMA_CONNECTION_INFO | VIEW | RDMA connection details |
| QSYS2 | RDMA_LINK_INFO | VIEW | RDMA link traffic and errors |
| QSYS2 | ADD_NRG_LINK | PROCEDURE | Add NRG link |
| QSYS2 | CHANGE_NRG | PROCEDURE | Modify NRG settings |

### MIRROR-REPLICATION (8 services)

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | REPLICATION_CRITERIA_INFO | VIEW | Inclusion/exclusion rules |
| QSYS2 | ADD_REPLICATION_CRITERIA | PROCEDURE | Add rule |
| QSYS2 | REMOVE_REPLICATION_CRITERIA | PROCEDURE | Remove rule |
| QSYS2 | INSPECT_REPLICATION_CRITERIA | TABLE FUNCTION | Inspect criteria |
| QSYS2 | EVALUATE_PENDING_REPLICATION_CRITERIA | TABLE FUNCTION | Evaluate pending |

### MIRROR-RECLONE (7 services)

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | CONFIRM_RECLONE_SECURITY_OBJECTS | VIEW | Security objects |
| QSYS2 | CONFIRM_RECLONED_LIBRARY_DIFFERENCES | TABLE FUNCTION | Library diffs |
| QSYS2 | EVALUATE_RECLONE_JOURNALED_OBJECTS | TABLE FUNCTION | Journaled objects |
| QSYS2 | EVALUATE_RECLONE_RELATED_OBJECTS | TABLE FUNCTION | Related objects |
| QSYS2 | EVALUATE_RECLONE_REPLICATION_CRITERIA | TABLE FUNCTION | Criteria |
| QSYS2 | RECLONE_OBJECT | PROCEDURE | Reclone single object |
| QSYS2 | RECLONE_REPLICATED_OBJECTS | PROCEDURE | Reclone all |

### MIRROR-RESYNCHRONIZATION (5 services)

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | RESYNC_STATUS | VIEW | Resync tracking list |
| QSYS2 | COMPARE_RESYNC_STATUS | TABLE FUNCTION | Compare resync |
| QSYS2 | MIRROR_SUSPENDING_JOBS | TABLE FUNCTION | Jobs causing suspend |
| QSYS2 | CHANGE_RESYNC_ENTRIES | PROCEDURE | Modify resync entries |
| QSYS2 | SET_RESYNC_PRIORITIES | PROCEDURE | Set resync priorities |

### MIRROR-SERVICEABILITY (7 services)

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | MIRROR_FLIGHT_RECORDER_INFO | VIEW | Flight recorder config |
| QSYS2 | MIRROR_COMPARE_OBJECT | TABLE FUNCTION | Compare objects |
| QSYS2 | MIRROR_DISPLAY_JOURNAL | TABLE FUNCTION | Mirror journal |
| QSYS2 | MIRROR_COMPARE_LIBRARY | PROCEDURE | Compare library |
| QSYS2 | MIRROR_COMPARE_NODE | PROCEDURE | Compare nodes |
