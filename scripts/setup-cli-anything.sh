#!/usr/bin/env bash
set -euo pipefail

echo "=== Setting up CLI-Anything for Claude Code ==="

# Check Python version
if ! python3 -c "import sys; assert sys.version_info >= (3, 10)" 2>/dev/null; then
  echo "ERROR: Python 3.10+ required"
  exit 1
fi

echo "[1/2] Installing CLI-Anything plugin via marketplace"
echo "  In Claude Code, run:"
echo "    /plugin marketplace add HKUDS/CLI-Anything"
echo "    /plugin install cli-anything"
echo ""

echo "[2/2] Alternative: manual installation"
PLUGIN_DIR="${HOME}/.claude/plugins/cli-anything"
if [ ! -d "$PLUGIN_DIR" ]; then
  echo "  Cloning HKUDS/CLI-Anything..."
  git clone --depth 1 https://github.com/HKUDS/CLI-Anything.git /tmp/cli-anything
  mkdir -p "${HOME}/.claude/plugins"
  cp -r /tmp/cli-anything/cli-anything-plugin "$PLUGIN_DIR"
  rm -rf /tmp/cli-anything
  echo "  Installed to $PLUGIN_DIR"
  echo "  Run /reload-plugins in Claude Code to activate"
else
  echo "  Already installed at $PLUGIN_DIR"
fi

echo ""
echo "=== Done ==="
echo "In Claude Code, use:"
echo "  /cli-anything:cli-anything <path>  — generate a CLI for any software"
echo "  /cli-anything:refine <path>        — expand CLI coverage"
echo ""
echo "For CLI-Hub and other skills, run: ./scripts/setup-skills.sh"
