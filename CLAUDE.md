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
