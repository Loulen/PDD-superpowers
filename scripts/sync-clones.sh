#!/usr/bin/env bash
set -euo pipefail

# Locations where superpowers is cloned for each coding agent
LOCATIONS=(
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

# Claude Code uses a marketplace + plugin cache system.
# The marketplace points to a local git clone (e.g. the codex or personal clone).
# After pulling, update the plugin to refresh the cached copy.
if command -v claude &>/dev/null; then
  echo "Updating Claude Code plugin cache ..."
  # First update the marketplace index (picks up new commits from the local clone)
  env -u CLAUDECODE claude plugin marketplace update superpowers-dev 2>/dev/null || true
  # Then update the installed plugin (copies new files into the cache)
  env -u CLAUDECODE claude plugin update "pdd-superpowers@superpowers-dev" 2>/dev/null \
    && echo "Claude Code plugin cache updated." \
    || echo "Warning: plugin update failed. Run manually: claude plugin update 'pdd-superpowers@superpowers-dev'"
else
  echo "Skipping Claude Code (claude CLI not found)"
fi

echo "Done. Restart OpenCode if it was running."
