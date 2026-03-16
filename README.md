# IBM i Agent Skills

Agent skills for AI coding assistants to work with IBM i systems. **24 skills** covering all IBM i SQL Service categories with **219+ pre-built tools**.

## What are Agent Skills?

Agents are increasingly capable, but often don't have the context they need to do real work reliably. Skills solve this by giving agents access to procedural knowledge and **company**, **team**, and **user-specific context** they can load on demand. Agents with access to a set of skills can extend their capabilities based on the task they're working on.

## Installation

Skills are organized into **plugins** so you can install only what you need:

| Plugin | Skills | Tools | Audience |
|--------|--------|-------|----------|
| **ibmi-core** | 1 (ibmi) | 7 | Everyone — CLI, text-to-SQL, schema discovery |
| **ibmi-database** | 5 | 51 | DBAs, SQL developers |
| **ibmi-system** | 18 | 161 | Sysadmins, operators, security, DevOps |
| **ibmi-all** | 24 | 219+ | Install everything |

### Option 1: Claude Code Plugin Marketplace

```
/plugin marketplace add ajshedivy/ibmi-agent-skills

# Install by role:
/plugin install ibmi-core@ibmi-agent-skills          # Start here
/plugin install ibmi-database@ibmi-agent-skills       # For DBAs
/plugin install ibmi-system@ibmi-agent-skills          # For sysadmins

# Or install everything:
/plugin install ibmi-all@ibmi-agent-skills
```

### Option 2: npx skills (Multi-Agent)

Install skills using [`npx skills`](https://github.com/vercel-labs/agent-skills). Works with Claude Code, Cursor, GitHub Copilot, and 40+ other agents.

```bash
# Install from GitHub
npx skills add ajshedivy/ibmi-agent-skills

# Or clone and install locally
git clone https://github.com/ajshedivy/ibmi-agent-skills.git
cd ibmi-agent-skills
npx skills add ./skills --list           # List available skills
npx skills add ./skills/ibmi             # Core skill (start here)
npx skills add ./skills                  # Install all skills
```

#### Options

| Option | Description |
|--------|-------------|
| `-g, --global` | Install to user directory instead of project |
| `-a, --agent <agents...>` | Target specific agents (e.g., `claude-code`, `cursor`) |
| `-s, --skill <skills...>` | Install specific skills by name |
| `-l, --list` | List available skills without installing |
| `-y, --yes` | Skip all confirmation prompts |
| `--all` | Install all skills to all agents without prompts |

#### Examples

```bash
# Install to Claude Code only
npx skills add ./skills -a claude-code

# Install globally (available across all projects)
npx skills add ./skills -g

# Non-interactive installation
npx skills add ./skills -g -a claude-code -y --all
```

## Prerequisites

The [`ibmi-mcp-server`](https://github.com/IBM/ibmi-mcp-server) must be connected to your agent, providing:
- `describe_sql_object` - Get DDL/metadata for IBM i objects
- `execute_sql` - Run SQL SELECT statements on IBM i

### Setting up the MCP Server

Add the following to your agent's MCP settings (`.mcp.json` for Claude Code):

```json
{
  "mcpServers": {
    "ibmi-mcp-server": {
      "command": "npx",
      "args": ["-y", "@ibm/ibmi-mcp-server@latest"],
      "env": {
        "NODE_OPTIONS": "--no-deprecation",
        "DB2i_HOST": "your-hostname.com",
        "DB2i_USER": "your-username",
        "DB2i_PASS": "your-password",
        "DB2i_PORT": "8076",
        "MCP_TRANSPORT_TYPE": "stdio",
        "IBMI_ENABLE_EXECUTE_SQL": "true"
      }
    }
  }
}
```

### IBM i CLI (Optional)

The [`ibmi` CLI](https://github.com/ajshedivy/ibmi-cli) provides direct tool execution:

```bash
ibmi tool list_active_jobs --tools skills/work-management/tools/
ibmi sql "SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) FETCH FIRST 10 ROWS ONLY"
```

## Available Skills

### Core (ibmi-core plugin)

| Skill | Tools | Description |
|-------|-------|-------------|
| `ibmi` | 7 | CLI usage, text-to-SQL methodology, schema discovery, SQL validation |

### Database (ibmi-database plugin)

| Skill | Tools | Description |
|-------|-------|-------------|
| `database-utility` | 9 | File inventory, object stats, data validation |
| `database-application` | 7 | SQL error logs, SQLCODE info, system limits |
| `database-performance` | 8 | Indexes, MTI, monitors, MQTs, active queries |
| `database-plan-cache` | 7 | Plan cache snapshots, events, procedures |
| `journal` | 13 | Journals, receivers, journaled objects, audit events |

### System (ibmi-system plugin)

#### Core System

| Skill | Tools | Description |
|-------|-------|-------------|
| `work-management` | 15 | Jobs, subsystems, locks, job queues, scheduled jobs, ended jobs, SQL activity |
| `storage` | 9 | ASPs, disk units, temp storage, NVMe, user storage |
| `backup-and-recovery` | 5 | Save files, media libraries, tape cartridges |
| `communication` | 11 | Network connections, routing, HTTP servers, TCP/IP, DB connections, DNS |
| `application` | 13 | Commands, data areas, data queues, programs, transactions, call stacks |

#### Operations & Monitoring

| Skill | Tools | Description |
|-------|-------|-------------|
| `spool` | 9 | Output queues, spooled files, spool consumers |
| `ptf` | 11 | PTF currency, groups, firmware, cover letters, defective PTFs |
| `message-handling` | 8 | Message queues, history log, reply lists, job logs |
| `system-health` | 8 | System status, memory pools, disk, limits |
| `performance` | 7 | Collection services, temp storage, I/O metrics |

#### Security & Infrastructure

| Skill | Tools | Description |
|-------|-------|-------------|
| `security` | 17 | User profiles, authorities, certificates, vulnerability assessment, auth lists |
| `librarian` | 7 | Library lists, authorization lists, object privileges |
| `configuration` | 7 | System values, hardware, JVM info |
| `product` | 5 | Software products, licenses |

### Specialized

| Skill | Tools | Description |
|-------|-------|-------------|
| `java` | 5 | JVM monitoring, heap/GC analysis |
| `ifs` | 10 | IFS browsing, search, authorities, file reading, comparison |
| `migrate-while-active` | 9 | Migration status, library/IFS tracking |
| `journal` | 13 | Journals, receivers, journaled objects, audit events |
| `mirror` | 12 | Db2 Mirror status, replication, NRG, reclone |

**Total: 24 skills, 219+ tools**

## Managing Skills

```bash
# List installed skills
npx skills list

# Check for updates
npx skills check

# Update all skills
npx skills update

# Remove a skill
npx skills remove work-management
```

## Creating a Basic Skill

Skills are simple to create — just a folder with a `SKILL.md` file containing YAML frontmatter and instructions:

```markdown
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---

# My Skill Name

[Instructions that the Agent will follow when this skill is active]
```

See the [skill-creator](./skills/skill-creator/) skill for detailed guidance and the [Agent Skills Documentation](https://agentskills.io/home) for the full specification.

## License

Apache-2.0
