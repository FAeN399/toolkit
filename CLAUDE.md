# Toolkit — Claude Code Project Context

This repo is an integration hub for developer tools. It provides MCP server configurations, GitHub Actions workflows, setup scripts, and Claude Code plugin/skill integrations. It is a configuration/documentation repository — no application source code, no package.json, no Dockerfile.

## Repository Structure

```
toolkit/
├── .github/workflows/       # CI/CD workflow definitions (5 workflows)
├── .vscode/mcp.json          # MCP server configs for VS Code / Cursor
├── scripts/                  # Bash setup scripts (3 scripts)
│   ├── setup-mcp.sh          # Installs MCP servers via `claude mcp add`
│   ├── setup-skills.sh       # Installs 5 Claude Code skills to ~/.claude/skills/
│   └── setup-cli-anything.sh # Sets up CLI-Anything plugin
├── CLAUDE.md                 # This file — project context for Claude Code
├── README.md                 # User guide and quickstart
└── .gitignore                # Excludes: node_modules/, .env, .env.local, *.secret, playwright-report/, test-results/, output/, model_recommendations.json
```

## MCP Servers

Configured in `.vscode/mcp.json` (auto-loaded when you open the repo in VS Code / Cursor) and installed into Claude Code via `scripts/setup-mcp.sh`:

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
  - CLI-Hub meta-skill discovers and installs pre-built CLIs from the community registry (browse at https://hkuds.github.io/CLI-Anything/)
  - Supported apps include: GIMP, Blender, LibreOffice, Inkscape, Audacity, OBS, Shotcut, VLC, Zoom, MuseScore, and any software with APIs
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

| Workflow | File | Trigger | Purpose | Notes |
|----------|------|---------|---------|-------|
| Playwright | `playwright.yml` | Push/PR to main | E2E browser tests, HTML report upload | 15-min timeout, 30-day retention, PR comment via `daun/playwright-report-summary` |
| Stripe Test | `stripe-test.yml` | Push/PR to main | Webhook integration tests | Starts app with `npm run dev &`, forwards webhooks to `localhost:3000/api/webhooks` |
| Supabase | `supabase.yml` | Push to main | DB migrations, Edge Function deploy, type generation | Generates types to `src/database.types.ts`; push-only, no PR trigger |
| FFmpeg | `ffmpeg.yml` | Manual dispatch | Media pipeline | Inputs: `input_file` (required), `output_format` (mp4/webm/gif/mp3); 7-day retention |
| LLMfit | `llmfit.yml` | Manual dispatch | Hardware-aware LLM recommendations | Outputs JSON to `$GITHUB_STEP_SUMMARY`; installs via `llmfit.axjns.dev/install.sh` |

### Required GitHub Secrets

- `STRIPE_SECRET_KEY`
- `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_ID`, `SUPABASE_DB_PASSWORD`
- `GWS_CREDENTIALS` — Google Workspace service account JSON

## Setup / Quick Start

```bash
git clone https://github.com/FAeN399/toolkit.git
cd toolkit
./scripts/setup-cli-anything.sh
./scripts/setup-mcp.sh
./scripts/setup-skills.sh
```

### Script Behavior

- All scripts use `set -euo pipefail` — fail fast on any error, undefined variable, or pipe failure
- `setup-mcp.sh`: GWS server install is conditional — skipped with a warning if `gws` CLI is not on `$PATH`
- `setup-cli-anything.sh`: Validates Python 3.10+ at startup; exits if check fails. Run `/reload-plugins` after install
- `setup-skills.sh`: Uses sparse git clones to minimize download. Idempotent — re-running skips already-installed skills

## Repo Notes

- No LICENSE, CONTRIBUTING, SECURITY, or CODE_OF_CONDUCT files exist yet
- Local default branch is `master`; remote tracks `main` — use `main` for all push/PR targets
- The `skills/` directory does not exist in the repo; skills install to `~/.claude/skills/` via setup script

## Conventions

- Use restricted API keys for Stripe (`rk_*`), never live secret keys
- Supabase MCP should use `read_only` mode for production environments
- Always test Stripe webhooks in sandbox mode before production
- Playwright visual snapshots must be generated in CI, not locally
- CLI-Anything generated CLIs output JSON by default for agent consumption
- Scripts are Bash-only — no Node.js or Python project files in the repo itself
- All setup scripts install tools to user-level directories (`~/.claude/`)
- Workflow dispatch inputs are validated — FFmpeg accepts only mp4/webm/gif/mp3; do not add formats without updating the workflow
