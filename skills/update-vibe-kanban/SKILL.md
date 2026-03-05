---
name: update-vibe-kanban
description: Use when updating Vibe Kanban to the latest version — syncs fork from upstream, rebuilds the server binary, restarts the systemd service, and verifies it comes back healthy
---

# Update Vibe Kanban

## Overview

Sync the VK fork from upstream, rebuild, restart the service, and verify it's healthy. Give regular status updates throughout.

## Infrastructure

| Component | Details |
|-----------|---------|
| Repo | `/home/llenoir/Documents/perso/vibe-kanban` |
| Remotes | `origin` = upstream (BloopAI/vibe-kanban), `fork` = ours (Loulen/vibe-kanban) |
| Service | `vibe-kanban.service` (systemd user unit) |
| Sync timer | `vk-sync.timer` / `vk-sync.service` (weekly auto-sync) |
| Port | 3069 |
| Binary | `target/release/server` |
| Start script | `~/.local/bin/vibe-kanban-local.sh` (builds if binary missing, then exec) |
| Sync logs | `~/.local/share/vk-sync/logs/vk-sync.log` |

## Process

### Step 1: Sync fork from upstream

```bash
cd /home/llenoir/Documents/perso/vibe-kanban
git fetch origin
git merge origin/main
```

**If merge conflicts:** Resolve them, commit the merge. Check `git status` for conflicted files.

**Report:** "Syncing fork — fetched N new commits from upstream" or "Fork already up to date"

```bash
git push fork main
```

**Report:** "Pushed to fork/main"

### Step 2: Stop the service and delete the binary

```bash
systemctl --user stop vibe-kanban.service
rm -f /home/llenoir/Documents/perso/vibe-kanban/target/release/server
```

**Report:** "Service stopped, binary deleted — rebuild will start on next launch"

### Step 3: Start the service (triggers rebuild)

```bash
systemctl --user start vibe-kanban.service
```

The start script (`vibe-kanban-local.sh`) detects the missing binary and runs:
1. `pnpm --dir packages/local-web run build` (TypeScript + Vite)
2. `cargo build --release --bin server` (Rust)
3. `exec target/release/server`

**Report:** "Service started — rebuilding from source (this takes several minutes)"

### Step 4: Monitor the build

Poll `journalctl` every 30-60 seconds to check progress and catch errors early:

```bash
journalctl --user -u vibe-kanban.service --no-pager -n 15
```

**Watch for:**

| Log pattern | Meaning |
|-------------|---------|
| `error TS` | TypeScript build failure — fix the code, commit, restart from Step 3 |
| `error[E` | Rust compilation error — fix the code, commit, restart from Step 3 |
| `VersionMismatch` | Migration checksum mismatch — delete `dev_assets/` dir, restart from Step 3 |
| `Finished \`release\` profile` | Cargo build complete |
| `Build complete.` | Start script moving to exec |
| `Main server on :3069` | Server is up |

**Report at each poll:** What stage the build is at (tsc, vite, cargo compiling crate X, etc.)

**If build errors occur:**
1. Stop the service: `systemctl --user stop vibe-kanban.service`
2. Fix the issue in `/home/llenoir/Documents/perso/vibe-kanban`
3. Commit the fix
4. Push to fork: `git push fork main`
5. Go back to Step 2

### Step 5: Verify health

Once logs show the server started, poll until healthy:

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:3069/
```

**Expected:** `200`

Retry up to 10 times with 5-second intervals if the server hasn't started responding yet.

**Report on success:** "VK is live and healthy on port 3069"

**Report on failure:** "VK failed to start — check logs with `journalctl --user -u vibe-kanban.service -n 50`"

### Step 6: Notify

```bash
notify-send --urgency=normal 'VK Update' 'Vibe Kanban updated and running on port 3069'
```

## Common Issues

| Issue | Fix |
|-------|-----|
| TS import error after upstream merge | Module was renamed upstream. Update the import path, commit, rebuild. |
| `VersionMismatch` on migration | `rm -rf /home/llenoir/Documents/perso/vibe-kanban/dev_assets/` and restart |
| Service crash-looping | `systemctl --user stop vibe-kanban.service` first, then investigate logs |
| Port 3069 already in use | `lsof -ti :3069 \| xargs -r kill -9` then restart |
| `pnpm` / `node` not found | Service needs NVM sourced — check `vibe-kanban-local.sh` has correct NVM_DIR |
