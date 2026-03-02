#!/usr/bin/env bash
set -euo pipefail

# Locations where superpowers is cloned for each coding agent
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

# Claude Code copies plugins into a cache, so a git pull alone is not enough.
# Re-add the plugin to refresh the cached copy.
if [ -d "$HOME/.claude/superpowers/.claude-plugin" ]; then
  echo "Re-adding Claude Code plugin (refreshing cache) ..."
  claude plugin add "$HOME/.claude/superpowers" 2>/dev/null \
    && echo "Claude Code plugin cache updated." \
    || echo "Warning: 'claude' CLI not found or plugin add failed. Re-add manually with: claude plugin add ~/.claude/superpowers"
fi

echo "Done. Restart OpenCode if it was running."
