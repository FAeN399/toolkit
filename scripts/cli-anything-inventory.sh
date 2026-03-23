#!/usr/bin/env bash
set -euo pipefail

# CLI-Anything Bridge Inventory
# Scans for locally installed tools that could be made agent-native via CLI-Anything.
# Checks each tool against the CLI-Hub registry for existing coverage.
# Outputs JSON for agent consumption.

BRIDGED=0
UNBRIDGED=0
MISSING=0

# Tools the toolkit already depends on (workflows, MCP servers, skills)
# plus high-value creative/productivity tools CLI-Anything is designed for.
#
# Format: "command|display_name|category|notes"
TOOL_REGISTRY=(
  # Tools used by toolkit workflows
  "ffmpeg|FFmpeg|media|Used by ffmpeg.yml workflow — no CLI-Anything bridge"
  "ffprobe|FFprobe|media|FFmpeg companion — media analysis"
  # Creative tools CLI-Anything explicitly supports
  "gimp|GIMP|creative|Image editor — documented CLI-Anything target"
  "blender|Blender|creative|3D creation — documented CLI-Anything target"
  "inkscape|Inkscape|creative|Vector graphics — documented CLI-Anything target"
  "audacity|Audacity|creative|Audio editor — documented CLI-Anything target"
  "obs|OBS Studio|creative|Streaming/recording — documented CLI-Anything target"
  "vlc|VLC|media|Media player — documented CLI-Anything target"
  "shotcut|Shotcut|creative|Video editor — documented CLI-Anything target"
  "musescore|MuseScore|creative|Music notation — documented CLI-Anything target"
  # Productivity tools
  "libreoffice|LibreOffice|productivity|Office suite — documented CLI-Anything target"
  "soffice|LibreOffice (alt)|productivity|LibreOffice alternate binary"
  # Developer tools that workflows depend on but aren't bridged
  "docker|Docker|devops|Container runtime — agent-controllable surface"
  "curl|cURL|network|HTTP client — used across toolkit workflows"
  "git|Git|devops|Version control — deep CLI surface"
  "gh|GitHub CLI|devops|GitHub operations — used by workflows"
  "node|Node.js|runtime|JavaScript runtime — used by MCP servers"
  "python3|Python 3|runtime|Required by CLI-Anything itself"
  "npx|npx|runtime|Node package runner — used by MCP setup"
  # Media tools beyond FFmpeg
  "imagemagick|ImageMagick|media|Image processing — convert, identify, mogrify"
  "convert|ImageMagick convert|media|ImageMagick conversion tool"
  "sox|SoX|media|Sound processing — the Swiss Army knife of audio"
)

# CLI-Hub known entries (tools that already have community CLIs).
# This list is static — in practice, cli-hub would be queried dynamically.
# These represent tools with known CLI-Anything coverage.
CLI_HUB_COVERED=(
  "gimp"
  "blender"
  "libreoffice"
  "soffice"
  "inkscape"
  "audacity"
  "obs"
  "vlc"
  "shotcut"
  "musescore"
)

is_covered() {
  local cmd="$1"
  for covered in "${CLI_HUB_COVERED[@]}"; do
    if [ "$cmd" = "$covered" ]; then
      return 0
    fi
  done
  return 1
}

echo "=== CLI-Anything Bridge Inventory ===" >&2
echo "" >&2

# Build JSON output
JSON_ITEMS=()

for entry in "${TOOL_REGISTRY[@]}"; do
  IFS='|' read -r cmd name category notes <<< "$entry"

  if command -v "$cmd" &>/dev/null; then
    INSTALLED=true
    VERSION=$("$cmd" --version 2>/dev/null | head -1 || echo "unknown")
    PATH_FOUND=$(command -v "$cmd")
  else
    INSTALLED=false
    VERSION=""
    PATH_FOUND=""
  fi

  if is_covered "$cmd"; then
    COVERAGE="covered"
  else
    COVERAGE="unbridged"
  fi

  if [ "$INSTALLED" = true ]; then
    if [ "$COVERAGE" = "covered" ]; then
      STATUS="bridged"
      echo "  [BRIDGED]    $name ($cmd)" >&2
      BRIDGED=$((BRIDGED + 1))
    else
      STATUS="unbridged"
      echo "  [UNBRIDGED]  $name ($cmd) — candidate for CLI-Anything" >&2
      UNBRIDGED=$((UNBRIDGED + 1))
    fi
  else
    STATUS="not_installed"
    echo "  [MISSING]    $name ($cmd)" >&2
    MISSING=$((MISSING + 1))
  fi

  # Build JSON object for this tool
  ITEM=$(cat <<ITEM_EOF
    {
      "command": "$cmd",
      "name": "$name",
      "category": "$category",
      "status": "$STATUS",
      "installed": $INSTALLED,
      "cli_hub_coverage": "$COVERAGE",
      "version": "$(echo "$VERSION" | sed 's/"/\\"/g')",
      "path": "$PATH_FOUND",
      "notes": "$notes"
    }
ITEM_EOF
  )
  JSON_ITEMS+=("$ITEM")
done

echo "" >&2
echo "=== Summary: $BRIDGED bridged, $UNBRIDGED unbridged, $MISSING not installed ===" >&2

# Determine priority targets: installed but unbridged
PRIORITY_TARGETS=()
for entry in "${TOOL_REGISTRY[@]}"; do
  IFS='|' read -r cmd name category notes <<< "$entry"
  if command -v "$cmd" &>/dev/null && ! is_covered "$cmd"; then
    PRIORITY_TARGETS+=("\"$cmd\"")
  fi
done

# Output JSON report
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Join JSON items with commas
ITEMS_JSON=""
for i in "${!JSON_ITEMS[@]}"; do
  if [ "$i" -gt 0 ]; then
    ITEMS_JSON+=","
  fi
  ITEMS_JSON+="${JSON_ITEMS[$i]}"
done

# Join priority targets with commas
TARGETS_JSON=""
for i in "${!PRIORITY_TARGETS[@]}"; do
  if [ "$i" -gt 0 ]; then
    TARGETS_JSON+=","
  fi
  TARGETS_JSON+="${PRIORITY_TARGETS[$i]}"
done

cat <<REPORT_EOF
{
  "timestamp": "$TIMESTAMP",
  "summary": {
    "bridged": $BRIDGED,
    "unbridged": $UNBRIDGED,
    "not_installed": $MISSING,
    "total_scanned": ${#TOOL_REGISTRY[@]}
  },
  "priority_targets": [$TARGETS_JSON],
  "tools": [$ITEMS_JSON]
}
REPORT_EOF
