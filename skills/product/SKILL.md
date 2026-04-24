---
name: product
description: "Query IBM i software products, licensing, and product health via SQL services. Use when user asks about: (1) installed software products and versions, (2) product details for a specific product ID, (3) software products with load errors, (4) license compliance and usage limits, (5) unsupported or incompatible products, (6) replacing DSPSFWRSC, WRKLICINF, DSPPTF commands, or (7) any software product management task."
---

# IBM i Software Product & License Management

Query installed software products, licensing, and product health using SQL services from QSYS2.

## Available Tools

The `ibmi` CLI is the primary tool for executing product queries. Set `SKILL_DIR` to this skill's installed location (the directory containing this SKILL.md file):

```bash
# SKILL_DIR = directory containing this SKILL.md
# Examples: ./skills/product, ~/.claude/skills/product

ibmi tools --tools "$SKILL_DIR/tools/" --toolset product_default
ibmi tool list_software_products --tools "$SKILL_DIR/tools/"
ibmi sql "SELECT * FROM QSYS2.SOFTWARE_PRODUCT_INFO WHERE INSTALLED = 'YES' AND LOAD_ERROR = 'YES'"
```

## Service Selection Guide

### Software Products
- **QSYS2.SOFTWARE_PRODUCT_INFO** -- Installed products with release, state, errors, compatibility

### Licensing
- **QSYS2.LICENSE_INFO** -- License terms, usage limits, peak usage, expiration dates

## Key Capabilities

### Software Inventory
- **Product Listing** -- All installed products with release level and status
- **Product Detail** -- Deep dive into a specific product's options and loads
- **Error Detection** -- Find products with load errors or broken installations
- **Compatibility Check** -- Identify unsupported or incompatible products

### License Management
- **Usage Tracking** -- Current usage count vs usage limit per product
- **Peak Usage** -- Historical peak usage for capacity planning
- **Compliance** -- Compliance type and violation logging status
- **Expiration** -- License expiration dates and grace periods

## Common Use Cases

1. **Software inventory** -- List all installed products and versions
2. **Product lookup** -- Get details for a specific product ID (e.g., 5770SS1)
3. **Error detection** -- Find products with load errors needing attention
4. **License audit** -- Review license compliance and usage
5. **Upgrade planning** -- Identify unsupported or incompatible products
6. **Capacity planning** -- Check peak usage against license limits

## Quick Examples

### List installed products
```bash
ibmi tool list_software_products --tools "$SKILL_DIR/tools/"
```

### Details for a specific product
```bash
ibmi tool get_software_product_detail --tools "$SKILL_DIR/tools/" --product-id 5770SS1
```

### Products with errors
```bash
ibmi tool list_software_errors --tools "$SKILL_DIR/tools/"
```

### License compliance
```bash
ibmi tool get_license_info --tools "$SKILL_DIR/tools/"
```

### Unsupported products
```bash
ibmi tool list_unsupported_products --tools "$SKILL_DIR/tools/"
```

## Pre-built Tools

The `tools/product.yaml` file provides 5 ready-to-use tools:

| Tool | Description |
|------|-------------|
| `list_software_products` | Installed software products with status and release |
| `get_software_product_detail` | Detailed product info by product ID |
| `list_software_errors` | Products with load errors |
| `get_license_info` | License compliance, usage, and expiration |
| `list_unsupported_products` | Unsupported, incompatible, or errored products |

```bash
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/"          # Execute
ibmi tool <tool_name> --tools "$SKILL_DIR/tools/" --dry-run # Preview SQL
ibmi tools show <tool_name> --tools "$SKILL_DIR/tools/"     # View details
```

## Reference Documentation

- [Product Services Catalog](./references/product-services.md) -- Available SQL services
- [Example SQL Patterns](./references/product-examples.sql) -- Working query examples
- [IBM SOFTWARE_PRODUCT_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-software-product-info-view) -- View documentation
- [IBM LICENSE_INFO](https://www.ibm.com/docs/en/i/7.5?topic=services-license-info-view) -- View documentation
