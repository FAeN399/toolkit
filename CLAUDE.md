# Toolkit — Claude Code Project Context

This repo is an integration hub for developer tools.

## MCP Servers Available
- Stripe (`https://mcp.stripe.com/`)
- Supabase (`@supabase/mcp-server-supabase`)
- Playwright (`@playwright/mcp`)
- GWS — Google Workspace (`gws mcp`)
- NotebookLM (`notebooklm-mcp`)

## Plugins
- CLI-Anything (`HKUDS/CLI-Anything`) — generates CLIs for any software, making them agent-controllable
  - Use `/cli-anything:cli-anything <path>` to generate a CLI
  - Use `/cli-anything:refine <path>` to expand coverage
  - CLI-Hub meta-skill discovers and installs pre-built CLIs from the community registry

## Key Paths
- `.github/workflows/` — CI/CD workflows
- `.vscode/mcp.json` — MCP configs for VS Code/Cursor
- `scripts/` — Setup scripts for MCP + skills + plugins
- `skills/` — Claude Code skill definitions

## Conventions
- Use restricted API keys for Stripe (`rk_*`)
- Supabase MCP should use `read_only` mode for production
- Always test Stripe webhooks in sandbox mode
- Playwright visual snapshots should be generated in CI, not locally
- CLI-Anything generated CLIs output JSON by default for agent consumption
