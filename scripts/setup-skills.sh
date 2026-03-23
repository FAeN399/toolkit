#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
mkdir -p "$SKILLS_DIR"

echo "=== Installing Claude Code Skills ==="

echo "[1/5] CLI-Hub skill (discover + install CLIs)"
if [ ! -d "$SKILLS_DIR/cli-hub" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/HKUDS/CLI-Anything.git /tmp/cli-hub 2>/dev/null || true
  cd /tmp/cli-hub && git sparse-checkout set cli-hub-skill 2>/dev/null || true
  cp -r /tmp/cli-hub/cli-hub-skill "$SKILLS_DIR/cli-hub" 2>/dev/null && echo "  Installed" || echo "  Manual: copy cli-hub-skill from HKUDS/CLI-Anything"
  rm -rf /tmp/cli-hub
else
  echo "  Already installed"
fi

echo "[2/5] GWS Workflow skill"
if [ ! -d "$SKILLS_DIR/gws-workflow" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/googleworkspace/cli.git /tmp/gws-cli 2>/dev/null || true
  cd /tmp/gws-cli && git sparse-checkout set skills/gws-workflow 2>/dev/null || true
  cp -r /tmp/gws-cli/skills/gws-workflow "$SKILLS_DIR/" 2>/dev/null && echo "  Installed" || echo "  Manual: copy skills/gws-workflow from googleworkspace/cli"
  rm -rf /tmp/gws-cli
else
  echo "  Already installed"
fi

echo "[3/5] LLMfit Advisor skill"
if [ ! -d "$SKILLS_DIR/llmfit-advisor" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/AlexsJones/llmfit.git /tmp/llmfit 2>/dev/null || true
  cd /tmp/llmfit && git sparse-checkout set skills/llmfit-advisor 2>/dev/null || true
  cp -r /tmp/llmfit/skills/llmfit-advisor "$SKILLS_DIR/" 2>/dev/null && echo "  Installed" || echo "  Manual: copy skills/llmfit-advisor from AlexsJones/llmfit"
  rm -rf /tmp/llmfit
else
  echo "  Already installed"
fi

echo "[4/5] NotebookLM skill"
if [ ! -d "$SKILLS_DIR/notebooklm" ]; then
  git clone --depth 1 https://github.com/PleasePrompto/notebooklm-skill.git "$SKILLS_DIR/notebooklm" 2>/dev/null && echo "  Installed" || echo "  Manual: git clone https://github.com/PleasePrompto/notebooklm-skill ~/.claude/skills/notebooklm"
else
  echo "  Already installed"
fi

echo "[5/5] Playwright CLI skill"
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
