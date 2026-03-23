# Workshop — Toolkit Awareness Skill

You are the operational companion to `CLAUDE.md`. The seed teaches the agent how to think inside the workshop. You make that thinking concrete.

When invoked, you do three things: **survey**, **diagnose**, **orient**.

---

## 1. Survey — Read the Workshop

Inventory every touchpoint. Count what exists. Report what you find.

```
MCP Servers:     .vscode/mcp.json         → list every key under "servers"
MCP Setup:       scripts/setup-mcp.sh     → list every `claude mcp add` call
Skills Setup:    scripts/setup-skills.sh  → list every skill install block
Skills Verify:   scripts/verify-setup.sh  → list every check() call
Workflows:       .github/workflows/*.yml  → list every file
CLAUDE.md:       CLAUDE.md                → extract tables for servers, skills, workflows
README.md:       README.md                → extract tables for servers, skills, workflows
```

For each category, produce a count and a list. Output as structured sections:

```
=== Workshop Survey ===

MCP Servers (mcp.json): 6
  stripe, supabase, playwright, gws, notebooklm, ffmpeg

MCP Servers (setup-mcp.sh): 6
  stripe, supabase, playwright, gws, notebooklm, ffmpeg

Skills (setup-skills.sh): 6
  cli-hub, gws-workflow, llmfit-advisor, notebooklm, playwright-cli, ffmpeg-media

Skills (verify-setup.sh): 6
  cli-hub, gws-workflow, llmfit-advisor, notebooklm, playwright-cli, ffmpeg-media

Workflows (.github/workflows/): 9
  playwright.yml, stripe-test.yml, supabase.yml, ffmpeg.yml, llmfit.yml,
  verify.yml, consistency.yml, dependency-monitor.yml, cli-anything-bridge.yml

CLAUDE.md servers: ...
CLAUDE.md skills: ...
CLAUDE.md workflows: ...
```

---

## 2. Diagnose — Check the Extension Protocol

The CLAUDE.md defines a strict protocol:

- Every MCP server must appear in **three** places: `mcp.json`, `setup-mcp.sh`, `CLAUDE.md`
- Every skill must appear in **three** places: `setup-skills.sh`, `verify-setup.sh`, `CLAUDE.md`
- Every workflow must appear in **two** places: `.github/workflows/`, `CLAUDE.md`
- Counts stated in CLAUDE.md must match actual file counts

Cross-reference the survey. Report drift:

```
=== Drift Detection ===

[OK]     MCP servers: mcp.json (6) = setup-mcp.sh (6) = CLAUDE.md (6)
[DRIFT]  Skills: setup-skills.sh (6) != CLAUDE.md (5) — missing: ffmpeg-media
[OK]     Workflows: .github/workflows/ (9) = CLAUDE.md (9)
[DRIFT]  CLAUDE.md states "five skills" but 6 exist in setup-skills.sh
```

If drift is found, list the exact files and lines that need updating. Don't fix them silently — name them. The human decides what gets corrected.

---

## 3. Orient — Answer the Seed Questions

The Seed Principle asks four questions. Answer them with data, not speculation.

**"What domain is missing?"**
List the current MCP server domains. Name adjacent domains the toolkit's workflows and skills already touch but can't reach through MCP. Be specific — name actual MCP servers that exist in the ecosystem.

**"What operational pattern is underserved?"**
List the current workflow triggers (push/PR, manual, schedule). Identify gaps: Are there events that happen but aren't automated? Maintenance that's manual but could be scheduled? Checks that run on schedule but should also run on push?

**"What capability would complete the set?"**
List the current skills. For each MCP server and workflow, ask: does a corresponding skill exist? Name the gaps where an internalized capability would reduce the need to reach outward.

**"What software hasn't been reached yet?"**
List what CLI-Anything currently supports. Look at the toolkit's own dependencies — FFmpeg, Stripe CLI, Supabase CLI, Playwright. Which of these have CLI-Anything coverage? Which don't?

Output these as structured observations, not recommendations. The human holds the thread.

```
=== Architecture Orientation ===

MCP domains covered: payments, database, browser, productivity, research, media
MCP domains adjacent: monitoring/observability, version control, container orchestration

Trigger coverage: push/PR (4), manual (2), scheduled (2), release (0), issue/comment (0)

Skill-to-server alignment:
  supabase MCP → no corresponding skill
  stripe MCP → no corresponding skill
  ffmpeg MCP → ffmpeg-media skill ✓

CLI-Anything coverage:
  ffmpeg → bridged (cli-anything-bridge.yml)
  stripe-cli → not bridged
  supabase-cli → not bridged
```

---

## Output Format

Always output all three sections in order: Survey, Diagnose, Orient.

Keep the tone factual. This skill reports what the workshop contains and where it's reaching — it doesn't decide what to build next. That's the architect's call.

If the survey and diagnosis are clean (no drift, no missing entries), say so plainly:

```
Workshop is whole. No drift detected. Extension protocol satisfied.
```

Then still answer the orientation questions — because the workshop is always reaching toward something, even when it's intact.

---

## When to Invoke This Skill

- Before extending the toolkit (know the current shape first)
- After extending the toolkit (verify the protocol was followed)
- When starting a new session (re-establish awareness)
- When something feels off (diagnose before you fix)

This skill is the workshop looking at itself. The CLAUDE.md is the seed. This is the mirror.
