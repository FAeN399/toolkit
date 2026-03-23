# Toolkit

Unified integration hub — MCP servers, GitHub Actions workflows, Claude Code skills, and setup scripts for the full stack.

## What's Included

### MCP Servers (AI Agent Access)
| Service | Description |
|---------|-------------|
| **Stripe** | Payments, customers, invoices via AI |
| **Supabase** | Tables, SQL, Edge Functions, types |
| **Playwright** | AI-driven browser automation |
| **GWS** | Google Drive, Gmail, Calendar |
| **NotebookLM** | Citation-backed notebook queries |

### GitHub Actions Workflows
| Workflow | Trigger | What It Does |
|----------|---------|--------------|
| `playwright.yml` | Push/PR to main | E2E browser tests + report upload |
| `supabase.yml` | Push to main | DB migrations + Edge Function deploy |
| `stripe-test.yml` | Push/PR to main | Webhook integration tests |
| `ffmpeg.yml` | Manual dispatch | Media processing pipeline |
| `llmfit.yml` | Manual dispatch | Hardware-aware LLM recommendations |

### Claude Code Skills
| Skill | Source |
|-------|--------|
| GWS Workflow | `googleworkspace/cli` |
| LLMfit Advisor | `AlexsJones/llmfit` |
| NotebookLM | `PleasePrompto/notebooklm-skill` |
| Playwright CLI | `microsoft/playwright-cli` |

## Quick Start

```bash
# Clone
git clone https://github.com/FAeN399/toolkit.git
cd toolkit

# Install all MCP servers into Claude Code
./scripts/setup-mcp.sh

# Install Claude Code skills
./scripts/setup-skills.sh
```

## Required GitHub Secrets

Set these in your repo Settings > Secrets:

| Secret | For |
|--------|-----|
| `STRIPE_SECRET_KEY` | Stripe webhook tests |
| `SUPABASE_ACCESS_TOKEN` | Supabase CLI auth |
| `SUPABASE_PROJECT_ID` | Supabase project ref |
| `SUPABASE_DB_PASSWORD` | DB migrations |
| `GWS_CREDENTIALS` | Google Workspace service account JSON |

## VS Code / Cursor

MCP servers are pre-configured in `.vscode/mcp.json` — just open the repo.
