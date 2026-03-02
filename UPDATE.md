# Updating Deployed Superpowers Clones

This fork (Loulen/PDD-superpowers) may be cloned in several locations depending on which coding agents are configured. After making changes and pushing to origin, run the sync script to update all deployed copies.

## Known Deployment Locations

| Platform    | Clone Path                              | How Skills Are Loaded                                    |
|-------------|-----------------------------------------|----------------------------------------------------------|
| Claude Code | `~/.claude/superpowers`                 | Copied into plugin cache; must re-add after pulling      |
| Codex       | `~/.codex/superpowers`                  | Live via symlink at `~/.agents/skills/superpowers`       |
| OpenCode    | `~/.config/opencode/superpowers`        | Live via symlink at `~/.config/opencode/skills/superpowers`; restart needed |

### Claude Code cache detail

Claude Code copies plugin files into `~/.claude/plugins/cache/` at install time. A `git pull` in the clone directory updates the source, but the cached copy remains stale until the plugin is re-added. The sync script handles this automatically by running `claude plugin add` after pulling.

## Update Script

Run from anywhere after pushing changes:

```bash
bash scripts/sync-clones.sh
```

Or copy the script below into your terminal:

```bash
#!/usr/bin/env bash
set -euo pipefail

LOCATIONS=(
  "$HOME/.claude/superpowers"
  "$HOME/.codex/superpowers"
  "$HOME/.config/opencode/superpowers"
)

for dir in "${LOCATIONS[@]}"; do
  if [ -d "$dir/.git" ]; then
    echo "Updating $dir ..."
    git -C "$dir" pull --ff-only origin main
  else
    echo "Skipping $dir (not a git clone)"
  fi
done

# Claude Code caches plugins — re-add to refresh the cache
if [ -d "$HOME/.claude/superpowers/.claude-plugin" ]; then
  echo "Re-adding Claude Code plugin (refreshing cache) ..."
  claude plugin add "$HOME/.claude/superpowers" 2>/dev/null \
    && echo "Claude Code plugin cache updated." \
    || echo "Warning: 'claude' CLI not found or plugin add failed. Re-add manually with: claude plugin add ~/.claude/superpowers"
fi

echo "Done. Restart OpenCode if it was running."
```

## Adding a New Deployment Location

If you clone superpowers to a new location for another agent, add the path to the `LOCATIONS` array in `scripts/sync-clones.sh` and update the table above.
