#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
  local label="$1" path="$2"
  if [ -e "$path" ]; then
    echo "  [OK] $label"
    ((PASS++))
  else
    echo "  [MISSING] $label — $path"
    ((FAIL++))
  fi
}

echo "=== Verifying Toolkit Setup ==="

echo ""
echo "MCP Servers:"
if command -v claude &>/dev/null; then
  for server in stripe supabase playwright gws notebooklm; do
    if claude mcp list 2>/dev/null | grep -qi "$server"; then
      echo "  [OK] $server"
      ((PASS++))
    else
      echo "  [MISSING] $server MCP server"
      ((FAIL++))
    fi
  done
else
  echo "  [SKIP] claude CLI not found — cannot verify MCP servers"
fi

echo ""
echo "Skills:"
SKILLS_DIR="${HOME}/.claude/skills"
check "CLI-Hub"        "$SKILLS_DIR/cli-hub"
check "GWS Workflow"   "$SKILLS_DIR/gws-workflow"
check "LLMfit Advisor" "$SKILLS_DIR/llmfit-advisor"
check "NotebookLM"     "$SKILLS_DIR/notebooklm"
check "Playwright CLI" "$SKILLS_DIR/playwright-cli"

echo ""
echo "Plugins:"
check "CLI-Anything" "${HOME}/.claude/plugins/cli-anything"

echo ""
echo "=== Summary: $PASS passed, $FAIL missing ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
