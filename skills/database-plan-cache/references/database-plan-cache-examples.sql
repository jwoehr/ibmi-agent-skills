-- Database Plan Cache SQL Examples
-- Validated against live IBM i system

-- List all plan cache services
SELECT SERVICE_SCHEMA_NAME, SERVICE_NAME, SQL_OBJECT_TYPE,
       EARLIEST_POSSIBLE_RELEASE
  FROM QSYS2.SERVICES_INFO
  WHERE SERVICE_CATEGORY = 'DATABASE-PLAN CACHE'
  ORDER BY SERVICE_NAME;

-- Get procedure parameters for DUMP_PLAN_CACHE
SELECT r.ROUTINE_NAME, p.PARAMETER_NAME, p.PARAMETER_MODE,
       p.DATA_TYPE, p.CHARACTER_MAXIMUM_LENGTH, p.ORDINAL_POSITION
  FROM QSYS2.SYSPARMS p
  JOIN QSYS2.SYSROUTINES r
    ON p.SPECIFIC_SCHEMA = r.SPECIFIC_SCHEMA
   AND p.SPECIFIC_NAME = r.SPECIFIC_NAME
  WHERE r.ROUTINE_SCHEMA = 'QSYS2'
    AND r.ROUTINE_NAME = 'DUMP_PLAN_CACHE'
  ORDER BY p.ORDINAL_POSITION;

-- Find existing plan cache snapshot files
SELECT OBJLIB AS LIBRARY, OBJNAME AS FILE_NAME,
       OBJSIZE, OBJTEXT, OBJCREATED, LAST_USED_TIMESTAMP
  FROM TABLE(QSYS2.OBJECT_STATISTICS('*ALLUSR', '*FILE'))
  WHERE OBJNAME LIKE 'QQQ%'
     OR OBJTEXT LIKE '%Plan Cache%'
     OR OBJTEXT LIKE '%PLAN CACHE%'
  ORDER BY OBJCREATED DESC
  FETCH FIRST 50 ROWS ONLY;

-- Monitor QSQSRVR server jobs (plan cache memory usage)
SELECT JOB_NAME, JOB_STATUS, SUBSYSTEM, MEMORY_POOL,
       TEMPORARY_STORAGE AS TEMP_STORAGE_MB,
       CPU_TIME, TOTAL_DISK_IO_COUNT,
       ELAPSED_CPU_PERCENTAGE
  FROM TABLE(QSYS2.ACTIVE_JOB_INFO(JOB_NAME_FILTER => 'QSQSRVR'))
  ORDER BY TEMPORARY_STORAGE DESC
  FETCH FIRST 25 ROWS ONLY;

-- List database monitors (includes plan cache event monitors)
SELECT MONITOR_ID, MONITOR_TYPE, MONITOR_STATUS,
       MONITOR_LIBRARY, MONITOR_FILE,
       NUMBER_ROWS, DATA_SIZE
  FROM QSYS2.DATABASE_MONITOR_INFO
  ORDER BY MONITOR_STATUS DESC, MONITOR_ID;

----------------------------------------------------------------------
-- Plan Cache Management (requires write-enabled connection)
----------------------------------------------------------------------

-- Dump entire plan cache to a snapshot file
-- CALL QSYS2.DUMP_PLAN_CACHE(
--   FILESCHEMA => 'MYLIB',
--   FILENAME => 'PCSNAP');

-- Dump top 50 queries by total time
-- CALL QSYS2.DUMP_PLAN_CACHE_TOPN(
--   FILESCHEMA => 'MYLIB',
--   FILENAME => 'PCTOP50',
--   TOPN => 50,
--   CATEGORY => 'TOTAL_TIME');

-- Dump plan cache properties
-- CALL QSYS2.DUMP_PLAN_CACHE_PROPERTIES(
--   FILESCHEMA => 'MYLIB',
--   FILENAME => 'PCPROPS');

-- Start plan cache event monitor
-- CALL QSYS2.START_PLAN_CACHE_EVENT_MONITOR(
--   FILESCHEMA => 'MYLIB',
--   FILENAME => 'PCMON');

-- End a specific event monitor
-- CALL QSYS2.END_PLAN_CACHE_EVENT_MONITOR(
--   MONITORID => 'MYMONITOR');

-- Change plan cache size to 2GB
-- CALL QSYS2.CHANGE_PLAN_CACHE_SIZE(SIZE_IN_MEG => 2048);

-- Clear entire plan cache
-- CALL QSYS2.CLEAR_PLAN_CACHE();

----------------------------------------------------------------------
-- Querying snapshot data (after dump)
----------------------------------------------------------------------

-- Query a plan cache snapshot for top queries by elapsed time
-- SELECT QQJOB, QQUSER, QQUCNT, QQETIM, QQSTIM,
--        CAST(QQC21 AS VARCHAR(100)) AS SCHEMA,
--        CAST(QQC11 AS VARCHAR(200)) AS SQL_TEXT
--   FROM MYLIB.PCTOP50
--   ORDER BY QQETIM DESC
--   FETCH FIRST 20 ROWS ONLY;
