# PTF Services Catalog

Services from `QSYS2.SERVICES_INFO` where `SERVICE_CATEGORY = 'PTF'`.

| Schema | Service Name | SQL Object Type | Min Release |
|--------|-------------|-----------------|-------------|
| SYSTOOLS | DEFECTIVE_PTF_CURRENCY | VIEW | V7R4M0 |
| QSYS2 | ELECTRONIC_SERVICE_AGENT_INFO | VIEW | V7R3M0 |
| SYSTOOLS | FIRMWARE_CURRENCY | VIEW | V7R3M0 |
| SYSTOOLS | GROUP_PTF_CURRENCY | VIEW | V7R1M0 |
| SYSTOOLS | GROUP_PTF_DETAILS | VIEW | V7R1M0 |
| QSYS2 | GROUP_PTF_INFO | VIEW | V6R1M0 |
| SYSTOOLS | PTF_COVER_LETTER | TABLE FUNCTION | V7R4M0 |
| QSYS2 | PTF_INFO | VIEW | V6R1M0 |

## Service Details

### Views (read-only queries)
- **GROUP_PTF_CURRENCY** -- Compare installed vs available PTF group levels (requires internet, SYSTOOLS)
- **DEFECTIVE_PTF_CURRENCY** -- Check for IBM-identified defective PTFs (requires internet, SYSTOOLS)
- **FIRMWARE_CURRENCY** -- Firmware version and update availability (SYSTOOLS)
- **GROUP_PTF_INFO** -- Installed PTF groups, levels, status, target release
- **GROUP_PTF_DETAILS** -- Individual PTFs within each PTF group (SYSTOOLS)
- **PTF_INFO** -- All individual PTFs with product, status, timestamps
- **ELECTRONIC_SERVICE_AGENT_INFO** -- Electronic Service Agent connection status

### Table Functions (read-only with parameters)
- **PTF_COVER_LETTER()** -- PTF cover letter details (SYSTOOLS, V7R4+)

## Notes

- GROUP_PTF_CURRENCY and DEFECTIVE_PTF_CURRENCY require outbound internet access to IBM servers
- FIRMWARE_CURRENCY may fail with CLOB errors on some system configurations
- GROUP_PTF_INFO is local-only and always available
