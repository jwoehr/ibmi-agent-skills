# IBM i SQL Services — Full Skill Coverage Creation Prompt

> Use this prompt with Claude Code in the `ibmi-agent-skills` project directory.
> Prerequisites: `ibmi` CLI installed and configured (`ibmi system` connected), ixora repo available at `~/Documents/IBM/sandbox/ai/ibmi-agi/ixora`

---

## Prompt

You are building a comprehensive set of **agent skills** for IBM i SQL Services. The goal is **full skill coverage** of every service category exposed by `QSYS2.SERVICES_INFO`.

### Context

**This project** (`ibmi-agent-skills`) contains the skill framework:
- `skills/work-management/` — An existing skill to use as the primary structural template
- `skills/skill-creator/` — Skill creation guide and tooling (`scripts/init_skill.py`, `scripts/package_skill.py`, `scripts/quick_validate.py`)
- `skills/skills-template/` — Minimal SKILL.md template

**The ixora repo** (`~/Documents/IBM/sandbox/ai/ibmi-agi/ixora/tools/`) contains example **tool YAML files** that demonstrate how tools are defined for the IBM i CLI. These are the reference patterns for tool definitions:
- `sys-admin.yaml` — Service discovery/browse/search tools using `QSYS2.SERVICES_INFO`
- `security-ops.yaml` — Security vulnerability assessment tools (complex CTEs, privilege analysis)
- `performance.yaml` — System performance tools (SYSTEM_STATUS, MEMORY_POOL, ACTIVE_JOB_INFO)
- `database-investigation.yaml` — Object statistics, unused objects, file comparison
- `text2sql.yaml` — Schema discovery, query validation, table sampling
- `job-management.yaml` — Job info, job logs, job queues
- `troubleshooting.yaml` — Lock info, stack info, SQLSTATE/SQLCODE lookup
- `db-utility.yaml` — File inventory, data validation, related objects

### The IBM i CLI (`ibmi`)

The `ibmi` CLI is the **primary mechanism** for executing SQL and running tools in this project. All tool YAML files are loaded and executed through this CLI.

#### Key Commands

```bash
# Ad-hoc SQL execution
ibmi sql "SELECT * FROM QSYS2.SERVICES_INFO FETCH FIRST 5 ROWS ONLY"
ibmi sql --file path/to/query.sql
ibmi sql "SELECT ..." --format table          # table, json, csv, markdown
ibmi sql "SELECT ..." --limit 20

# Tool operations (requires --tools <path> pointing to YAML files)
ibmi tools --tools path/to/tools/             # List all available tools
ibmi tools --tools path/to/tools/ --toolset <name>  # List tools in a toolset
ibmi tools show <tool_name> --tools path/to/tools/   # Show tool details (SQL, params)
ibmi tool <tool_name> --tools path/to/tools/         # Execute a tool
ibmi tool <tool_name> --tools path/to/tools/ --dry-run  # Show resolved SQL without executing
ibmi toolsets --tools path/to/tools/                 # List available toolsets

# SQL validation
ibmi validate "SELECT ..."                    # Validate SQL syntax against live system

# Schema exploration
ibmi schemas                                  # List schemas/libraries
ibmi tables <schema>                          # List tables/views in a schema
ibmi columns <schema> <table>                 # Get column metadata
```

#### Output Format

The CLI returns JSON by default:
```json
{
  "ok": true,
  "system": "dev",
  "host": "hostname.com",
  "command": "tool:tool_name",
  "data": [ { "COL1": "val", "COL2": 123 } ],
  "meta": { "rows": 1, "hasMore": false, "elapsed_ms": 467 }
}
```

Use `--format table` for human-readable output, `--format csv` for export.

### Phase 1: Discovery — Explore the Service Catalog

Before creating any skills, query the live IBM i system using the `ibmi` CLI to understand the full service landscape.

**Step 1.1** — Get all service categories with counts:
```bash
ibmi sql "SELECT SERVICE_CATEGORY, COUNT(*) AS SERVICE_COUNT FROM QSYS2.SERVICES_INFO GROUP BY SERVICE_CATEGORY ORDER BY SERVICE_COUNT DESC"
```

**Step 1.2** — For each category, get the full service list:
```bash
ibmi sql "SELECT SERVICE_CATEGORY, SERVICE_SCHEMA_NAME, SERVICE_NAME, SQL_OBJECT_TYPE, OBJECT_TYPE, SYSTEM_OBJECT_NAME, EARLIEST_POSSIBLE_RELEASE FROM QSYS2.SERVICES_INFO WHERE SERVICE_CATEGORY = '<category_name>' ORDER BY SERVICE_SCHEMA_NAME, SERVICE_NAME"
```

**Step 1.3** — For key services, get usage examples:
```bash
ibmi sql "SELECT SERVICE_NAME, EXAMPLE FROM QSYS2.SERVICES_INFO WHERE SERVICE_CATEGORY = '<category_name>' AND EXAMPLE IS NOT NULL"
```

**Step 1.4** — Explore columns/parameters of specific services:
```bash
ibmi columns QSYS2 <view_name>               # For views
ibmi sql "SELECT * FROM TABLE(QSYS2.<function_name>()) FETCH FIRST 1 ROWS ONLY"  # For table functions
```

**Step 1.5** — Save discovery results to `skills/_catalog/` for reference:
- `skills/_catalog/categories.md` — Summary of all categories with counts
- `skills/_catalog/services-by-category.md` — Full service listing per category

### Phase 2: Skill Architecture — Map Categories to Skills

Create one skill per service category. Each skill lives in `skills/<category-name>/` and contains:

```
skills/<category-name>/
├── SKILL.md                    # Skill definition (frontmatter + instructions)
├── references/
│   ├── <category>-services.md  # Service catalog for this category (from SERVICES_INFO)
│   └── <category>-examples.sql # Example SQL queries for key services
└── tools/
    └── <category>.yaml         # 5-10 default tool definitions (ibmi CLI YAML format)
```

### Phase 3: Create Skills — For Each Category

For each service category discovered in Phase 1:

#### 3a. Initialize the skill

```bash
python skills/skill-creator/scripts/init_skill.py <category-name> --path skills
```

#### 3b. Write the tool YAML file (`tools/<category>.yaml`)

Create 5-10 tools per category following the **ixora YAML format exactly**:

```yaml
sources:
  ibmi-system:
    host: ${DB2i_HOST}
    user: ${DB2i_USER}
    password: ${DB2i_PASS}
    port: 8076
    ignore-unauthorized: true

tools:
  <tool_name>:
    source: ibmi-system
    description: "<clear description of what this tool does>"
    statement: |
      <SQL statement with :parameter_name placeholders>
    parameters:
      - name: <param_name>
        type: string|integer|boolean
        description: "<parameter description>"
        required: true|false
        default: "<default_value>"
        enum: ["val1", "val2"]      # optional
        minLength: N                 # optional
        maxLength: N                 # optional
    security:
      readOnly: true
    annotations:
      readOnlyHint: true
      idempotentHint: true
      domain: "<category>"
      category: "<subcategory>"

toolsets:
  <category>_default:
    title: "<Category Name> Tools"
    description: "<What this toolset provides>"
    tools:
      - tool_name_1
      - tool_name_2
      - ...
```

**Tool selection criteria** — For each category, pick the 5-10 most useful tools by:
1. **High-frequency use cases** — What would an admin/developer query most often?
2. **Discovery tools** — List/browse/search within the category
3. **Diagnostic tools** — Identify problems, bottlenecks, anomalies
4. **Monitoring tools** — Track status, usage, health over time
5. **Detail tools** — Deep-dive into specific objects/resources

**SQL patterns to follow** (from ixora examples):
- Use `:param_name` for parameter binding (never string concatenation)
- Use `UPPER(:param)` for case-insensitive matching
- Use `(:filter = '*ALL' OR COLUMN = UPPER(:filter))` for optional filters
- Use `TABLE(QSYS2.function_name(...))` for table functions
- Use `FETCH FIRST :limit ROWS ONLY` for result limiting
- Use `ORDER BY` for deterministic output
- Prefer QSYS2 filter parameters over WHERE clauses for UDTFs (performance)

#### 3c. Write the SKILL.md

Follow the `work-management` skill as the structural template. Each SKILL.md must have:

**Frontmatter:**
```yaml
---
name: <category-name>
description: "<comprehensive description covering: (1) what it does, (2) specific use cases that trigger it, (3) CL command equivalents if applicable>"
---
```

**Body sections:**
1. **Title & one-line summary**
2. **Available Tools** — Explain that the `ibmi` CLI is the primary tool for execution. Mention both ad-hoc SQL (`ibmi sql`) and pre-built tools (`ibmi tool <name> --tools tools/`). Also note `ibmi-mcp-server` provides `execute_sql` and `describe_sql_object` for MCP-connected agents.
3. **Service Selection Guide** — Which QSYS2/SYSTOOLS services to use and when
4. **Key Capabilities** — Organized by use case (discovery, monitoring, diagnostics, etc.)
5. **Common Use Cases** — 5-10 numbered scenarios with brief descriptions
6. **Quick Examples** — 3-5 examples showing both `ibmi` CLI usage and raw SQL:
   ```bash
   # List all tools in this skill's toolset
   ibmi tools --tools tools/ --toolset <category>_default

   # Run a specific pre-built tool
   ibmi tool <tool_name> --tools tools/

   # Ad-hoc SQL for custom queries
   ibmi sql "SELECT ... FROM QSYS2.<service> ..."
   ```
7. **Pre-built Tools** — Reference the `tools/<category>.yaml` file and list each tool with a one-line description. Explain how to use them:
   ```bash
   ibmi tool <tool_name> --tools tools/          # Execute
   ibmi tool <tool_name> --tools tools/ --dry-run # Preview SQL
   ibmi tools show <tool_name> --tools tools/     # View details
   ```
8. **Reference Documentation** — Links to `references/` files and IBM documentation

**Keep SKILL.md under 250 lines.** Move detailed service documentation to `references/`.

#### 3d. Write reference files

- `references/<category>-services.md` — Service catalog pulled from SERVICES_INFO (name, schema, SQL type, description, example for each service in this category)
- `references/<category>-examples.sql` — Working SQL examples for the most useful services

### Phase 4: Validate & Test with the IBM i CLI

For each created skill, use the `ibmi` CLI to validate every tool:

#### 4a. Validate skill structure
```bash
python skills/skill-creator/scripts/quick_validate.py skills/<category-name>
```

#### 4b. Verify tools load correctly
```bash
# List all tools in the new skill's YAML — confirms YAML parses correctly
ibmi tools --tools skills/<category-name>/tools/

# List toolsets — confirms toolset definitions are valid
ibmi toolsets --tools skills/<category-name>/tools/

# Show each tool's details — confirms SQL and parameters are well-formed
ibmi tools show <tool_name> --tools skills/<category-name>/tools/
```

#### 4c. Dry-run each tool
```bash
# Preview resolved SQL without executing — catches parameter binding issues
ibmi tool <tool_name> --tools skills/<category-name>/tools/ --dry-run
```

#### 4d. Execute each tool against the live system
```bash
# Run the tool and verify it returns data
ibmi tool <tool_name> --tools skills/<category-name>/tools/

# For tools with required parameters, pass them as prompted or via flags
ibmi tool <tool_name> --tools skills/<category-name>/tools/
```

#### 4e. Validate raw SQL from examples
```bash
# Validate SQL syntax for example queries in references
ibmi validate "SELECT * FROM TABLE(QSYS2.<function>()) FETCH FIRST 5 ROWS ONLY"

# Execute example SQL to confirm it works
ibmi sql --file skills/<category-name>/references/<category>-examples.sql --limit 5
```

#### 4f. Test report

After testing each skill, produce a test summary:

```
Skill: <category-name>
Tools: <N> defined, <N> passed, <N> failed

| Tool Name           | YAML Parse | Dry Run | Execute | Status |
|---------------------|------------|---------|---------|--------|
| tool_name_1         | OK         | OK      | OK (5r) | PASS   |
| tool_name_2         | OK         | OK      | FAIL    | FIX    |

Failed tools:
- tool_name_2: <error message from ibmi CLI>

Examples SQL: <N> tested, <N> passed
```

Fix any failures before moving to the next skill.

### Mapping Guidance — Categories to Skill Names

Use the exact `SERVICE_CATEGORY` values from `QSYS2.SERVICES_INFO` as the basis for skill names, converted to lowercase-hyphenated format:

| SERVICE_CATEGORY | Skill Name |
|---|---|
| `WORK MANAGEMENT` | `work-management` (already exists — enhance) |
| `SECURITY` | `security` |
| `PERFORMANCE` | `performance` |
| `APPLICATION` | `application` |
| `COMMUNICATION` | `communication` |
| `PRODUCT` | `product` |
| `JOURNAL` | `journal` |
| `STORAGE` | `storage` |
| `IFS` | `ifs` |
| `SPOOL` | `spool` |
| `PTF` | `ptf` |
| `MESSAGE HANDLING` | `message-handling` |
| `DATABASE-UTILITY` | `database-utility` |
| `DATABASE-PLAN CACHE` | `database-plan-cache` |
| `DATABASE-PERFORMANCE` | `database-performance` |
| `DATABASE-APPLICATION` | `database-application` |
| `BACKUP AND RECOVERY` | `backup-and-recovery` |
| `LIBRARIAN` | `librarian` |
| `CONFIGURATION` | `configuration` |
| `SYSTEM HEALTH` | `system-health` |
| `JAVA` | `java` |
| `MIGRATE WHILE ACTIVE` | `migrate-while-active` |
| `MIRROR-*` categories | `mirror-product`, `mirror-communication`, `mirror-replication`, `mirror-reclone`, `mirror-serviceability`, `mirror-resynchronization` |
| ... | ... (discover any remaining from live system) |

### Execution Strategy

**Do NOT create all 28+ skills at once.** Work in batches:

1. **Batch 1**: Run Phase 1 (discovery). Save the full catalog. Present the complete list of categories and proposed skill names for user review.

2. **Batch 2**: Create the first 3 skills (pick the most impactful categories after user input). For each, complete phases 3a-3d fully, then run Phase 4 validation before moving to the next.

3. **Batch 3+**: Continue in batches of 3-5 skills, validating each batch before proceeding.

After each batch, report:
- Skills created (name, tool count, line count)
- `ibmi` CLI test results (YAML parse / dry-run / execute per tool)
- Any services that couldn't be covered and why

### Important Constraints

- **All SQL must be read-only** (`security.readOnly: true`) unless the tool explicitly modifies state (rare — flag these for user approval)
- **Use QSYS2/SYSTOOLS services** — Do not write ad-hoc SQL when a service exists
- **Match ixora YAML format exactly** — Tools must be compatible with the `ibmi` CLI and `ibmi-mcp-server`
- **No duplicate tools across skills** — If a service spans categories, put it in the most natural one
- **Test with `ibmi` CLI** — Every tool must pass: YAML parse → dry-run → live execution
- **Use `ibmi columns` and `ibmi validate`** — Before writing SQL against any view/function, verify its columns and syntax
- **Preserve the existing work-management skill** — Enhance it, don't replace it

### Reference: IBM i CLI Quick Reference

```bash
# Connection verification
ibmi sql "VALUES CURRENT_TIMESTAMP"

# Schema exploration
ibmi schemas                              # List all schemas
ibmi tables QSYS2                         # List QSYS2 tables/views
ibmi columns QSYS2 SERVICES_INFO          # Column metadata

# SQL execution
ibmi sql "SELECT ..." --limit 10          # Limit rows
ibmi sql "SELECT ..." --format table      # Human-readable
ibmi sql "SELECT ..." --format csv        # CSV export
ibmi sql --file query.sql                 # From file

# Tool lifecycle
ibmi tools --tools tools/                 # List tools
ibmi toolsets --tools tools/              # List toolsets
ibmi tools show <name> --tools tools/     # Tool details
ibmi tool <name> --tools tools/ --dry-run # Preview SQL
ibmi tool <name> --tools tools/           # Execute tool

# Validation
ibmi validate "SELECT ..."               # Syntax check
```

### Reference: QSYS2.SERVICES_INFO Columns

Key columns available in the catalog view:
- `SERVICE_CATEGORY` — Category grouping
- `SERVICE_SCHEMA_NAME` — Schema (QSYS2, SYSTOOLS, etc.)
- `SERVICE_NAME` — SQL object name
- `SQL_OBJECT_TYPE` — VIEW, PROCEDURE, TABLE FUNCTION, SCALAR FUNCTION, TABLE
- `OBJECT_TYPE` — IBM i object type (*FILE, *SRVPGM, etc.)
- `SYSTEM_OBJECT_NAME` — System name
- `EARLIEST_POSSIBLE_RELEASE` — Minimum IBM i version
- `LATEST_DB2_GROUP_LEVEL` — Latest PTF group level
- `INITIAL_DB2_GROUP_LEVEL` — Initial PTF group level
- `EXAMPLE` — Usage example SQL snippet
