# Design: CLAUDE.md Multi-Tool Impact Reporting

**Date:** 2026-03-02
**Status:** Approved

## Problem

This repo is shared across Claude Code, Codex, and OpenCode. Each tool has different capabilities (e.g., Codex lacks subagents). When the AI agent makes changes, it should flag which platforms are unaffected or need adaptation, so contributors understand cross-platform impact without having to check manually.

## Decision

Add two sections to `pdd-superpowers/CLAUDE.md`:

1. **Tool Compatibility Matrix** — a reference table of capability differences plus workarounds for feature parity.
2. **Multi-Tool Impact Reporting** — an instruction telling the agent to consult the matrix and add brief per-change callouts when platforms diverge.

## Design

### Approach: Inline Compatibility Reference + Reporting Rule

Everything lives in CLAUDE.md (no separate file). The agent:
- Consults the matrix when making changes
- Flags platforms that are unaffected, with a brief explanation
- Suggests workarounds for feature parity when possible
- Stays silent when all platforms are equally affected

### Compatibility Matrix

| Capability              | Claude Code       | Codex                | OpenCode                |
|-------------------------|-------------------|----------------------|-------------------------|
| Subagents (Task tool)   | Yes               | No                   | Yes (via @mention)      |
| TodoWrite               | Yes               | Via `update_plan`    | Via `update_plan`       |
| Skill invocation        | `Skill` tool      | Auto-discovery       | Native `skill` tool     |
| Hooks (SessionStart)    | Yes               | No                   | Yes (system.transform)  |
| Plugin caching          | Yes (must re-add) | No (live symlink)    | No (live symlink)       |
| Git worktrees           | Yes               | Yes                  | Yes                     |
| Parallel agent dispatch | Yes               | No                   | Yes (via @mention)      |

### Workarounds

- Codex lacks subagents: use `executing-plans` for sequential batch execution.
- Codex lacks parallel dispatch: same fallback to sequential execution.
- Codex lacks hooks: skills must be discoverable via filesystem alone.
- TodoWrite mapped to `update_plan` on Codex and OpenCode (transparent).
- Skill invocation differs in mechanism but all platforms discover from SKILL.md frontmatter.

### Reporting Rule

The agent adds a callout when a change touches a capability that differs across platforms. Examples:

- "Note: This change uses subagents. Codex is not affected (no subagent support). For parity, Codex users can use `executing-plans` for sequential execution."
- "Note: This modifies the SessionStart hook. Codex is not affected (no hook system). OpenCode uses `system.transform` hook — verify the change works there too."

## Scope

Only `pdd-superpowers/CLAUDE.md` is modified. No other files change.
