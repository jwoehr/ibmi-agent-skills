---
name: ptf
description: "Monitor and analyze PTFs, PTF groups, and system patching status on IBM i via SQL services. Use when user asks about: (1) PTF group currency or update status, (2) finding outdated or critical PTF groups, (3) individual PTF details by product, (4) installed PTF group levels, (5) defective PTF checks, (6) PTF patching summaries, (7) replacing DSPPTF, WRKPTFGRP commands, or (8) any PTF management or compliance task."
---

# IBM i PTF Management

Monitor and analyze Program Temporary Fixes (PTFs), PTF groups, and patching status using SQL services from QSYS2 and SYSTOOLS.

## Available Tools

The `ibmi` CLI is the primary tool for executing PTF queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/ptf, ~/.claude/skills/ptf

# List all PTF tools
ibmi tools --tools "$SKILL_DIR/tools/" --toolset ptf_default

# Run a specific tool
ibmi tool check_ptf_currency --tools "$SKILL_DIR/tools/"

# Ad-hoc SQL for custom queries
ibmi sql "SELECT * FROM QSYS2.GROUP_PTF_INFO WHERE PTF_GROUP_STATUS = 'INSTALLED'"
```

## Service Selection Guide

### PTF Group Currency (requires internet access)
- **SYSTOOLS.GROUP_PTF_CURRENCY** -- Compare installed vs available PTF group levels
- **SYSTOOLS.DEFECTIVE_PTF_CURRENCY** -- Check for IBM-identified defective PTFs

### PTF Group Information (local data)
- **QSYS2.GROUP_PTF_INFO** -- Installed PTF groups, levels, status, and target release
- **SYSTOOLS.GROUP_PTF_DETAILS** -- Individual PTFs within a PTF group

### Individual PTFs
- **QSYS2.PTF_INFO** -- All individual PTFs with product, status, and timestamps

## Key Capabilities

### Currency Monitoring
- **Group Currency** -- Compare installed vs available levels for all PTF groups
- **Outdated Groups** -- Find groups with updates available, ranked by levels behind
- **Critical Updates** -- Identify groups significantly behind threshold
- **Summary Dashboard** -- Count of current, outdated, and unavailable groups

### PTF Group Management
- **Installed Groups** -- List all PTF groups with status and release filtering
- **Group Details** -- Drill into a specific PTF group's installed levels
- **Status Tracking** -- Filter by INSTALLED, APPLY AT NEXT IPL, etc.

### Individual PTF Tracking
- **Product Filtering** -- List PTFs by product ID (5770SS1, 5770WDS, etc.)
- **Status Filtering** -- Find APPLIED, PERMANENTLY APPLIED, SUPERSEDED PTFs
- **Supersession Chain** -- Track which PTFs supersede others

### Compliance
- **Defective PTFs** -- Check for PTFs IBM has flagged as defective
- **Patch Level Summary** -- Overall system patching health at a glance

## Common Use Cases

1. **Patch compliance check** -- Verify all PTF groups are current
2. **Find outdated groups** -- Identify which groups need updates
3. **Critical update triage** -- Prioritize groups most levels behind
4. **Pre-IPL planning** -- Find PTFs pending apply at next IPL
5. **Product-specific PTFs** -- List PTFs for a specific licensed program
6. **Defective PTF scan** -- Check if any installed PTFs are defective
7. **PTF group drill-down** -- Examine levels within a specific group
8. **Patching summary** -- Quick dashboard of overall PTF health

## Quick Examples

### Check all PTF group currency
```bash
ibmi tool check_ptf_currency --tools "$SKILL_DIR/tools/"
```

### Find groups with updates available
```bash
ibmi tool list_outdated_ptf_groups --tools "$SKILL_DIR/tools/"
```

### List PTFs for a product
```bash
ibmi tool list_individual_ptfs --tools "$SKILL_DIR/tools/" --product-filter 5770SS1
```

### PTF currency summary
```sql
WITH iLevel(iVersion, iRelease) AS (
  SELECT OS_VERSION, OS_RELEASE FROM SYSIBMADM.ENV_SYS_INFO
)
SELECT PTF_GROUP_CURRENCY, COUNT(*) AS CNT
  FROM iLevel, SYSTOOLS.GROUP_PTF_CURRENCY P
  WHERE PTF_GROUP_RELEASE = 'R' CONCAT iVersion CONCAT iRelease CONCAT '0'
  GROUP BY PTF_GROUP_CURRENCY;
```

### Find superseded PTFs
```sql
SELECT PTF_IDENTIFIER, PTF_PRODUCT_ID, PTF_SUPERSEDED_BY_PTF
  FROM QSYS2.PTF_INFO
  WHERE PTF_SUPERSEDED_BY_PTF IS NOT NULL
  ORDER BY PTF_STATUS_TIMESTAMP DESC
  FETCH FIRST 20 ROWS ONLY;
```

## Pre-built Tools

The `tools/ptf.yaml` file provides 8 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `check_ptf_currency` | PTF group currency status for current release |
| `list_outdated_ptf_groups` | Groups with updates available, ranked by levels behind |
| `get_ptf_group_details` | Detailed levels for a specific PTF group |
| `list_installed_ptf_groups` | All installed PTF groups with status and release filters |
| `summarize_ptf_status` | High-level PTF currency summary with counts |
| `find_critical_ptf_updates` | Groups significantly behind a threshold |
| `list_individual_ptfs` | Individual PTFs filtered by product and status |
| `check_defective_ptfs` | Check for IBM-identified defective PTFs |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [PTF Services Catalog](./references/ptf-services.md) -- Available SQL services
- [Example SQL Patterns](./references/ptf-examples.sql) -- Working query examples
- [IBM GROUP_PTF_CURRENCY](https://www.ibm.com/docs/en/i/7.5?topic=services-group-ptf-currency-view) -- View documentation
- [IBM PTF_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-ptf-info-view) -- View documentation
