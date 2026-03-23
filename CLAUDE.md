# Toolkit — Claude Code Project Context

This repo is an integration hub for developer tools.

## MCP Servers Available
- Stripe (`https://mcp.stripe.com/`)
- Supabase (`@supabase/mcp-server-supabase`)
- Playwright (`@playwright/mcp`)
- GWS — Google Workspace (`gws mcp`)
- NotebookLM (`notebooklm-mcp`)

## Key Paths
- `.github/workflows/` — CI/CD workflows
- `.vscode/mcp.json` — MCP configs for VS Code/Cursor
- `scripts/` — Setup scripts for MCP + skills
- `skills/` — Claude Code skill definitions

## Conventions
- Use restricted API keys for Stripe (`rk_*`)
- Supabase MCP should use `read_only` mode for production
- Always test Stripe webhooks in sandbox mode
- Playwright visual snapshots should be generated in CI, not locally
