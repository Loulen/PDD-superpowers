# Skills & Primitives Update — Design

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> Fallback: Use superpowers:executing-plans (for platforms without subagent support)

## Goal

Update existing skills and add two new skills to improve the development workflow:
1. Stop auto-committing during human-in-the-loop iterations
2. Update vibe-kanban task status when finishing a branch
3. Add a mermaid-diagrams skill and wire it into key workflow points
4. Default to subagent-driven development with platform fallback
5. Import and wire actionable-acceptance-criteria skill

## Architecture

Existing skill files are modified in-place. Two new skills are added as flat directories under `skills/`.

## Tech Stack

Markdown skill files only. No code changes.

---

## Change 1: Conditional commit behavior

### Problem

During human-in-the-loop iterations (small changes, quick fixes), the agent auto-commits after every change, creating dozens of tiny commits. During autonomous subagent-driven work, committing after spec+code review pass is fine.

### Solution

**Files modified:**
- `skills/verification-before-completion/SKILL.md` — add a commit gate rule: "Do NOT commit unless (a) working autonomously via subagent-driven-development where reviews serve as validation, or (b) the user has explicitly validated the behavior. During interactive human-in-the-loop work, stage changes but wait for user validation before committing."

**Files NOT modified:**
- `skills/subagent-driven-development/` — autonomous workflow stays as-is, commits after spec+code review are fine
- `skills/writing-plans/SKILL.md` — plan templates keep "commit" in TDD steps since plans are executed autonomously

### Acceptance criteria

- [ ] During subagent-driven-development, implementers still commit after passing reviews
- [ ] During interactive work, the agent stages but does not commit until user says to
- [ ] The rule is in `verification-before-completion` so it applies universally

---

## Change 2: Vibe-kanban task status on branch finish

### Problem

When finishing a development branch, the linked vibe-kanban task is never updated. The task is lost/forgotten.

### Solution

**Files modified:**
- `skills/finishing-a-development-branch/SKILL.md` — add Step 5 AFTER option execution:

> **Step 5 — Update task tracker:**
> If vibe-kanban MCP is available (check via `get_context`), ask the user: "Is this task done?" If yes, update the linked issue status to "Done" via `update_issue`. If not done, ask if status should be updated to something else.

This goes after option execution (merge/PR/keep/discard) so the task tracking happens regardless of which option was chosen.

### Acceptance criteria

- [ ] Step 5 only triggers if vibe-kanban MCP tools are available
- [ ] User is asked — status is not auto-set
- [ ] Works for all 4 options (merge, PR, keep, discard)

---

## Change 3: New `mermaid-diagrams` skill + wiring

### Problem

No visual aids in the workflow. Users lack a high-level view of what happened during implementation, debugging, or planning.

### Solution

**New file:** `skills/mermaid-diagrams/SKILL.md`

A lightweight skill defining diagram preferences:
- Prefer **sequence diagrams** when showing interactions/flows between components/systems
- Fall back to **classic flowcharts** when sequence doesn't fit
- Keep diagrams **minimal** — high-level overview, not implementation details
- Goal: give the user a bird's-eye view of technical work
- Never overly complex — if it needs more than ~10 nodes, simplify

**Wiring — add "invoke mermaid-diagrams" directives to:**

| Skill | When | Diagram type |
|-------|------|-------------|
| `subagent-driven-development` | After each subagent completes a task | Sequence: what was implemented and how components interact |
| `finishing-a-development-branch` | When ending the task (before options) | Sequence or flowchart: summary of all work done |
| `systematic-debugging` | When investigating errors | Sequence: expected behavior vs actual behavior |
| `writing-plans` | When plan is written and saved | Flowchart: overview of the plan's task flow |

### Acceptance criteria

- [ ] New `mermaid-diagrams` skill exists with sequence-first preference
- [ ] 4 existing skills reference the mermaid-diagrams skill at the correct points
- [ ] Diagrams are minimal and high-level

---

## Change 4: Default to subagent-driven development

### Problem

`writing-plans` asks the user to choose between subagent-driven and parallel-session execution. This slows down the workflow. Subagent-driven should be the default.

### Solution

**Files modified:**
- `skills/writing-plans/SKILL.md` — after plan approval, default to invoking `subagent-driven-development`. Remove the choice prompt. Add platform fallback: if the platform doesn't support subagents (e.g. Codex — per compatibility matrix in CLAUDE.md), fall back to `executing-plans`.

### Acceptance criteria

- [ ] After plan approval, subagent-driven-development is invoked by default
- [ ] No choice prompt shown to user
- [ ] Codex (no subagent support) falls back to executing-plans
- [ ] User can still explicitly request executing-plans if desired

---

## Change 5: Import actionable-acceptance-criteria skill

### Problem

The `actionable-acceptance-criteria` skill exists in `~/.claude_from_old/skills/` but was never committed to the repo. Acceptance criteria in plans and issues lack concrete verification steps.

### Solution

**New file:** `skills/actionable-acceptance-criteria/SKILL.md`
- Copied from `~/.claude_from_old/skills/actionable-acceptance-criteria/SKILL.md`
- Adapted to superpowers conventions: frontmatter trimmed to `name` + `description` only, description starts with "Use when..."

**Wiring:**
- `skills/writing-plans/SKILL.md` — when writing acceptance criteria for plan tasks, invoke this skill to make each criterion verifiable
- `skills/subagent-driven-development/spec-reviewer-prompt.md` — the spec reviewer must verify that acceptance criteria are actionable (verification was actually performed, not just inspected)

### Acceptance criteria

- [ ] Skill imported and adapted to superpowers conventions
- [ ] `writing-plans` references it when writing acceptance criteria
- [ ] Spec reviewer checks that acceptance criteria have real verification steps
- [ ] Verification hierarchy (execute > observe > query > test interaction) is followed

---

## Multi-Tool Impact Report

| Change | Claude Code | Codex | OpenCode |
|--------|------------|-------|----------|
| 1. Conditional commits | Affected | Affected | Affected |
| 2. Vibe-kanban task status | Affected (MCP available) | Affected (MCP available) | Affected (MCP available) |
| 3. Mermaid diagrams skill | Affected | Affected | Affected |
| 4. Default subagent-driven | Affected (default) | Uses fallback (executing-plans) | Affected (default) |
| 5. Acceptance criteria | Affected | Affected | Affected |

Note for Change 4: Codex lacks subagent support per compatibility matrix. The fallback to `executing-plans` handles this automatically.
