#!/usr/bin/env bash
set -euo pipefail

echo "=== Setting up MCP servers for Claude Code ==="

echo "[1/6] Stripe (remote HTTP)"
claude mcp add --transport http stripe https://mcp.stripe.com/

echo "[2/6] Supabase"
claude mcp add supabase -- npx -y @supabase/mcp-server-supabase@latest

echo "[3/6] Playwright"
claude mcp add playwright -- npx -y @playwright/mcp@latest

echo "[4/6] GWS (Google Workspace)"
if command -v gws &>/dev/null; then
  claude mcp add gws -- gws mcp -s drive,gmail,calendar,sheets,docs
else
  echo "  ⚠ gws not found. Install with: npm i -g @googleworkspace/cli"
  echo "  Then run: claude mcp add gws -- gws mcp -s drive,gmail,calendar,sheets,docs"
fi

echo "[5/6] NotebookLM"
claude mcp add notebooklm -- npx -y notebooklm-mcp@latest

echo "[6/6] FFmpeg"
claude mcp add ffmpeg -- npx -y ffmpeg-mcp@latest

echo ""
echo "=== Done. Verify with: claude /mcp ==="
