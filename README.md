# Toolkit

[![Playwright Tests](https://github.com/FAeN399/toolkit/actions/workflows/playwright.yml/badge.svg)](https://github.com/FAeN399/toolkit/actions/workflows/playwright.yml)
[![Stripe Webhook Tests](https://github.com/FAeN399/toolkit/actions/workflows/stripe-test.yml/badge.svg)](https://github.com/FAeN399/toolkit/actions/workflows/stripe-test.yml)
[![Supabase Deploy](https://github.com/FAeN399/toolkit/actions/workflows/supabase.yml/badge.svg)](https://github.com/FAeN399/toolkit/actions/workflows/supabase.yml)
[![Toolkit Health](https://github.com/FAeN399/toolkit/actions/workflows/verify.yml/badge.svg)](https://github.com/FAeN399/toolkit/actions/workflows/verify.yml)
[![Consistency](https://github.com/FAeN399/toolkit/actions/workflows/consistency.yml/badge.svg)](https://github.com/FAeN399/toolkit/actions/workflows/consistency.yml)

Unified integration hub — MCP servers, GitHub Actions workflows, Claude Code skills/plugins, and setup scripts for the full stack.

## What's Included

### MCP Servers (AI Agent Access)
| Service | Description |
|---------|-------------|
| **Stripe** | Payments, customers, invoices via AI |
| **Supabase** | Tables, SQL, Edge Functions, types |
| **Playwright** | AI-driven browser automation |
| **GWS** | Google Drive, Gmail, Calendar |
| **NotebookLM** | Citation-backed notebook queries |

### Claude Code Plugins
| Plugin | Source | Description |
|--------|--------|-------------|
| **CLI-Anything** | [`HKUDS/CLI-Anything`](https://github.com/HKUDS/CLI-Anything) | Make ANY software agent-native — generates full CLIs for any app (GIMP, Blender, LibreOffice, etc.) so AI agents can control them |

### GitHub Actions Workflows
| Workflow | Trigger | What It Does |
|----------|---------|--------------|
| `playwright.yml` | Push/PR to main | E2E browser tests + report upload |
| `supabase.yml` | Push to main | DB migrations + Edge Function deploy |
| `stripe-test.yml` | Push/PR to main | Webhook integration tests |
| `ffmpeg.yml` | Manual dispatch | Media processing pipeline |
| `llmfit.yml` | Manual dispatch | Hardware-aware LLM recommendations |
| `verify.yml` | Weekly schedule / Manual | Toolkit health check (MCP endpoints, skill repos, CLI tools) |
| `consistency.yml` | Push/PR to main | Internal drift detection (docs, configs, and scripts stay in sync) |
| `dependency-monitor.yml` | Weekly schedule / Manual | Upstream version tracking (npm packages, skill repos, fork sync) |
| `cli-anything-bridge.yml` | Weekly schedule / Manual | CLI-Anything coverage inventory (finds unbridged local tools) |

### Claude Code Skills
| Skill | Source |
|-------|--------|
| CLI-Hub | `HKUDS/CLI-Anything` (discover + install CLIs) |
| GWS Workflow | `googleworkspace/cli` |
| LLMfit Advisor | `AlexsJones/llmfit` |
| NotebookLM | `PleasePrompto/notebooklm-skill` |
| Playwright CLI | `microsoft/playwright-cli` |

## Quick Start

```bash
# Clone
git clone https://github.com/FAeN399/toolkit.git
cd toolkit

# Install CLI-Anything plugin (Claude Code)
./scripts/setup-cli-anything.sh

# Install all MCP servers into Claude Code
./scripts/setup-mcp.sh

# Install Claude Code skills
./scripts/setup-skills.sh

# Verify everything installed correctly
./scripts/verify-setup.sh
```

## CLI-Anything Usage

Once installed, generate a CLI for any software:

```bash
# In Claude Code — generate a full CLI for any app
/cli-anything:cli-anything ./path-to-software

# Refine and expand coverage
/cli-anything:refine ./path-to-software

# Browse the CLI Hub for pre-built CLIs
# https://hkuds.github.io/CLI-Anything/
```

Supports: GIMP, Blender, LibreOffice, Inkscape, Audacity, OBS, Shotcut, VLC, Zoom, MuseScore, and any software with APIs.

### Bridge Inventory

Scan local tools and report CLI-Anything coverage gaps:

```bash
./scripts/cli-anything-inventory.sh
```

Outputs JSON with bridged, unbridged, and missing tools. The `cli-anything-bridge.yml` workflow runs this weekly in CI.

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

## Fork

CLI-Anything is forked at [`FAeN399/CLI-Anything`](https://github.com/FAeN399/CLI-Anything) for customization.
