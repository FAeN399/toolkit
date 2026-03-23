# Toolkit — Claude Code Project Context

This repo is an integration hub for developer tools. It provides MCP server configurations, GitHub Actions workflows, setup scripts, and Claude Code plugin/skill integrations. It is a configuration/documentation repository — no application source code, no package.json, no Dockerfile.

## Repository Structure

```
toolkit/
├── .github/workflows/       # CI/CD workflow definitions (5 workflows)
├── .vscode/mcp.json          # MCP server configs for VS Code / Cursor
├── scripts/                  # Bash setup scripts (4 scripts)
│   ├── setup-mcp.sh          # Installs MCP servers via `claude mcp add`
│   ├── setup-skills.sh       # Installs 5 Claude Code skills to ~/.claude/skills/
│   ├── setup-cli-anything.sh # Sets up CLI-Anything plugin
│   └── verify-setup.sh       # Verifies all components are installed correctly
├── CLAUDE.md                 # This file — project context for Claude Code
├── README.md                 # User guide and quickstart
└── .gitignore                # Excludes: node_modules, .env, test artifacts, output/
```

> **Note:** `skills/` is listed as a key path but does not exist in the repo. Skills are installed to `~/.claude/skills/` by `scripts/setup-skills.sh`.

## MCP Servers

Configured in `.vscode/mcp.json` and installed via `scripts/setup-mcp.sh`:

| Server | Type | Package / URL |
|--------|------|---------------|
| Stripe | HTTP | `https://mcp.stripe.com` |
| Supabase | stdio (npx) | `@supabase/mcp-server-supabase@latest` |
| Playwright | stdio (npx) | `@playwright/mcp@latest` |
| GWS (Google Workspace) | stdio | `gws mcp` — Drive, Gmail, Calendar, Sheets, Docs |
| NotebookLM | stdio (npx) | `notebooklm-mcp@latest` |

## Plugins

- **CLI-Anything** (`HKUDS/CLI-Anything`, forked at `FAeN399/CLI-Anything`) — generates CLIs for any software, making them agent-controllable
  - `/cli-anything:cli-anything <path>` — generate a CLI for a target application
  - `/cli-anything:refine <path>` — expand CLI coverage
  - CLI-Hub meta-skill discovers and installs pre-built CLIs from the community registry
  - Requires Python 3.10+

## Claude Code Skills

Installed by `scripts/setup-skills.sh` to `~/.claude/skills/`:

| Skill | Source |
|-------|--------|
| CLI-Hub | HKUDS/CLI-Anything |
| GWS Workflow | googleworkspace/cli |
| LLMfit Advisor | AlexsJones/llmfit |
| NotebookLM | PleasePrompto/notebooklm-skill |
| Playwright CLI | microsoft/playwright-cli |

## CI/CD Workflows

All in `.github/workflows/`:

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| Playwright | `playwright.yml` | Push/PR to main | E2E browser tests, uploads HTML report (30-day retention) |
| Stripe Test | `stripe-test.yml` | Push/PR to main | Webhook integration tests (payment_intent, customer.subscription, invoice) |
| Supabase | `supabase.yml` | Push to main | DB migrations, Edge Function deploy, TypeScript type generation |
| FFmpeg | `ffmpeg.yml` | Manual dispatch | Media pipeline (requires `input_file`, `output_format`) |
| LLMfit | `llmfit.yml` | Manual dispatch | Hardware-aware LLM recommendations (JSON output) |

### Required GitHub Secrets

- `STRIPE_SECRET_KEY`
- `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_ID`, `SUPABASE_DB_PASSWORD`
- `GWS_CREDENTIALS`

## Setup / Quick Start

```bash
git clone https://github.com/FAeN399/toolkit.git
cd toolkit
./scripts/setup-cli-anything.sh
./scripts/setup-mcp.sh
./scripts/setup-skills.sh
```

## Conventions

- Use restricted API keys for Stripe (`rk_*`), never live secret keys
- Supabase MCP should use `read_only` mode for production environments
- Always test Stripe webhooks in sandbox mode before production
- Playwright visual snapshots must be generated in CI, not locally
- CLI-Anything generated CLIs output JSON by default for agent consumption
- Scripts are Bash-only — no Node.js or Python project files in the repo itself
- All setup scripts install tools to user-level directories (`~/.claude/`)
