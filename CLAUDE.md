# PDD-superpowers Repository Guidelines

## After Pushing

After every `git push` to origin, run the sync script to update all deployed clones:

```bash
bash scripts/sync-clones.sh
```

This does two things:
1. Pulls the latest changes into `~/.claude/superpowers`, `~/.codex/superpowers`, and `~/.config/opencode/superpowers` (whichever exist as git clones).
2. Re-adds the Claude Code plugin via `claude plugin add` to refresh its cache (Claude Code copies plugins into `~/.claude/plugins/cache/` at install time, so a `git pull` alone is not enough).

See `UPDATE.md` for full details on deployment locations and platform-specific behavior.

## Upstream Sync

This repo is a fork of [obra/superpowers](https://github.com/obra/superpowers). To pull upstream changes:

```bash
git fetch upstream
git merge upstream/main
git push origin main
bash scripts/sync-clones.sh
```

## Tool Compatibility Matrix

This repo is shared across Claude Code, Codex, and OpenCode. Not all tools
support the same capabilities. Consult this matrix when making changes.

| Capability              | Claude Code       | Codex              | OpenCode                |
|-------------------------|-------------------|--------------------|-------------------------|
| Subagents (Task tool)   | Yes               | No                 | Yes (via @mention)      |
| TodoWrite               | Yes               | Via `update_plan`  | Via `update_plan`       |
| Skill invocation        | `Skill` tool      | Auto-discovery     | Native `skill` tool     |
| Hooks (SessionStart)    | Yes               | No                 | Yes (system.transform)  |
| Plugin caching          | Yes (must re-add) | No (live symlink)  | No (live symlink)       |
| Git worktrees           | Yes               | Yes                | Yes                     |
| Parallel agent dispatch | Yes               | No                 | Yes (via @mention)      |

### Workarounds for Feature Parity

- **Codex lacks subagents:** Use `executing-plans` skill for sequential
  batch execution with checkpoints instead of `subagent-driven-development`.
- **Codex lacks parallel dispatch:** Same as above — sequential execution
  is the fallback.
- **Codex lacks hooks:** Skills must be discoverable via filesystem alone.
  No bootstrap injection available.
- **TodoWrite differences:** Codex and OpenCode use `update_plan` natively.
  Skills referencing TodoWrite work on all platforms via tool mapping.
- **Skill invocation differences:** Claude Code uses `Skill` tool, Codex
  auto-discovers from `~/.agents/skills/`, OpenCode uses native `skill`
  tool. All three discover skills from SKILL.md frontmatter — no adaptation
  needed for skill content.

## Multi-Tool Impact Reporting

When making any change, consult the compatibility matrix above and report
which platforms are unaffected or need adaptation.

### When to report

- If a change touches a capability that differs across platforms, add a
  brief callout noting which platform(s) are unaffected and why.
- If a platform needs adaptation to achieve the same outcome, suggest how.
- If all platforms are equally affected, say nothing about compatibility.

### Example callouts

- "Note: This change uses subagents. Codex is not affected (no subagent
  support). For parity, Codex users can use the `executing-plans` skill
  for sequential execution."
- "Note: This modifies the SessionStart hook. Codex is not affected (no
  hook system). OpenCode uses `system.transform` hook — verify the change
  works there too."
