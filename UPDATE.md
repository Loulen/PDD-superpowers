# Updating Deployed Superpowers Clones

This fork (Loulen/PDD-superpowers) may be cloned in several locations depending on which coding agents are configured. After making changes and pushing to origin, run the sync script to update all deployed copies.

## Known Deployment Locations

| Platform    | Deploy Path                             | How Skills Are Loaded                                    |
|-------------|-----------------------------------------|----------------------------------------------------------|
| Claude Code | Marketplace → plugin cache              | Installed via marketplace; `plugin update` refreshes cache |
| Codex       | `~/.codex/superpowers`                  | Live via symlink at `~/.agents/skills/superpowers`       |
| OpenCode    | `~/.config/opencode/superpowers`        | Live via symlink at `~/.config/opencode/skills/superpowers`; restart needed |

### Claude Code marketplace detail

Claude Code uses a **marketplace** system. The repo is registered as a local marketplace (source: a git clone like `~/.codex/superpowers` or `~/Documents/perso/pdd-superpowers`). Plugin files are copied into `~/.claude/plugins/cache/` at install time. The sync script:
1. Pulls the latest changes into the git clone (Codex/OpenCode locations)
2. Updates the marketplace index via `claude plugin marketplace update`
3. Refreshes the cached plugin via `claude plugin update`

## Update Script

Run from anywhere after pushing changes:

```bash
bash scripts/sync-clones.sh
```

## Adding a New Deployment Location

If you clone superpowers to a new location for another agent, add the path to the `LOCATIONS` array in `scripts/sync-clones.sh` and update the table above.
