#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
mkdir -p "$SKILLS_DIR"

echo "=== Installing Claude Code Skills ==="

echo "[1/4] GWS Workflow skill"
if [ ! -d "$SKILLS_DIR/gws-workflow" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/googleworkspace/cli.git /tmp/gws-cli 2>/dev/null || true
  cd /tmp/gws-cli && git sparse-checkout set skills/gws-workflow 2>/dev/null || true
  cp -r /tmp/gws-cli/skills/gws-workflow "$SKILLS_DIR/" 2>/dev/null && echo "  Installed" || echo "  Manual: copy skills/gws-workflow from googleworkspace/cli"
  rm -rf /tmp/gws-cli
else
  echo "  Already installed"
fi

echo "[2/4] LLMfit Advisor skill"
if [ ! -d "$SKILLS_DIR/llmfit-advisor" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/AlexsJones/llmfit.git /tmp/llmfit 2>/dev/null || true
  cd /tmp/llmfit && git sparse-checkout set skills/llmfit-advisor 2>/dev/null || true
  cp -r /tmp/llmfit/skills/llmfit-advisor "$SKILLS_DIR/" 2>/dev/null && echo "  Installed" || echo "  Manual: copy skills/llmfit-advisor from AlexsJones/llmfit"
  rm -rf /tmp/llmfit
else
  echo "  Already installed"
fi

echo "[3/4] NotebookLM skill"
if [ ! -d "$SKILLS_DIR/notebooklm" ]; then
  git clone --depth 1 https://github.com/PleasePrompto/notebooklm-skill.git "$SKILLS_DIR/notebooklm" 2>/dev/null && echo "  Installed" || echo "  Manual: git clone https://github.com/PleasePrompto/notebooklm-skill ~/.claude/skills/notebooklm"
else
  echo "  Already installed"
fi

echo "[4/4] Playwright CLI skill"
if [ ! -d "$SKILLS_DIR/playwright-cli" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/microsoft/playwright-cli.git /tmp/pw-cli 2>/dev/null || true
  cd /tmp/pw-cli && git sparse-checkout set skills/playwright-cli 2>/dev/null || true
  cp -r /tmp/pw-cli/skills/playwright-cli "$SKILLS_DIR/" 2>/dev/null && echo "  Installed" || echo "  Manual: copy skills/playwright-cli from microsoft/playwright-cli"
  rm -rf /tmp/pw-cli
else
  echo "  Already installed"
fi

echo ""
echo "=== Done. Skills installed to $SKILLS_DIR ==="
