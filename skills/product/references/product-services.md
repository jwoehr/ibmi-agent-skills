# Product Services Catalog

SQL services used by the product skill for software and license management.

## Primary Services

| Schema | Service Name | SQL Object Type | Purpose |
|--------|-------------|-----------------|---------|
| QSYS2 | SOFTWARE_PRODUCT_INFO | VIEW | Installed software products and status |
| QSYS2 | LICENSE_INFO | VIEW | Software license terms, usage, and compliance |

## Key Column References

### SOFTWARE_PRODUCT_INFO
- PRODUCT_ID, PRODUCT_OPTION, LOAD_ID, LOAD_TYPE
- RELEASE_LEVEL, INSTALLED, SYMBOLIC_LOAD_STATE
- LOAD_ERROR, SUPPORTED, COMPATIBLE
- TEXT_DESCRIPTION, RELEASE_DATE, MINIMUM_TARGET_RELEASE

### LICENSE_INFO
- PRODUCT_ID, LICENSE_TERM, RELEASE_LEVEL, FEATURE_ID
- INSTALLED, PRODUCT_TEXT, USAGE_LIMIT, USAGE_TYPE
- USAGE_COUNT, PEAK_USAGE, LAST_PEAK
- COMPLIANCE_TYPE, LOG_VIOLATION
- LICENSE_EXPIRATION, GRACE_PERIOD, GRACE_END
