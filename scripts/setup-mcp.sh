#!/usr/bin/env bash
set -euo pipefail

echo "=== Setting up MCP servers for Claude Code ==="

echo "[1/5] Stripe (remote HTTP)"
claude mcp add --transport http stripe https://mcp.stripe.com/

echo "[2/5] Supabase"
claude mcp add supabase -- npx -y @supabase/mcp-server-supabase@latest

echo "[3/5] Playwright"
claude mcp add playwright -- npx -y @playwright/mcp@latest

echo "[4/5] GWS (Google Workspace)"
if command -v gws &>/dev/null; then
  claude mcp add gws -- gws mcp -s drive,gmail,calendar,sheets,docs
else
  echo "  ⚠ gws not found. Install with: npm i -g @googleworkspace/cli"
  echo "  Then run: claude mcp add gws -- gws mcp -s drive,gmail,calendar,sheets,docs"
fi

echo "[5/5] NotebookLM"
claude mcp add notebooklm -- npx -y notebooklm-mcp@latest

echo ""
echo "=== Done. Verify with: claude /mcp ==="
