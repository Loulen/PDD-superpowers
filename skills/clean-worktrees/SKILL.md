---
name: clean-worktrees
description: Use when the user wants to clean up stale or merged git worktrees, or when worktree clutter is mentioned
---

# Clean Worktrees

Remove git worktrees **across all repos** that are stale (no commits in 2+ weeks) or fully merged into the main integration branch.

## Procedure

### 1. Discover all repos with worktrees

Scan for repos that have registered worktrees. This is a global operation — not scoped to the current repo.

**Important:** Use depth 7+ to catch multi-repo projects (e.g. a parent dir with separate git repos per subdirectory).

```bash
find "$HOME" -maxdepth 7 -path '*/.git/worktrees' -type d ! -empty 2>/dev/null
```

Each result is `<repo>/.git/worktrees`. Strip `/.git/worktrees` to get the repo root.

### 2. For each repo: identify main branch and list worktrees

```bash
repo="/path/to/repo"

# Detect main integration branch
main_branch=$(git -C "$repo" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
if [ -z "$main_branch" ]; then
  for b in main master dev; do
    git -C "$repo" rev-parse --verify "origin/$b" &>/dev/null && main_branch=$b && break
  done
fi

git -C "$repo" fetch origin "$main_branch" --quiet

# List all registered worktrees
git -C "$repo" worktree list --porcelain
```

### 3. Evaluate each worktree

For every worktree **except the main one** and **except the current one**, check two criteria:

**Criterion A — Fully merged:**
```bash
branch_head=$(git -C "$repo" rev-parse <branch-name>)
git -C "$repo" merge-base --is-ancestor "$branch_head" "origin/$main_branch"
# Exit code 0 = merged, 1 = not merged
```

**Criterion B — Stale (≥ 2 weeks):**
```bash
last_commit=$(git -C "$repo" log -1 --format='%ct' <branch-name>)
two_weeks_ago=$(date -d '2 weeks ago' +%s)
# If last_commit < two_weeks_ago → stale
```

A worktree qualifies for removal if **either** criterion is met.

### 4. Present the evaluation and ask for confirmation

Before removing anything, show a full table **grouped by repo**:

```
## parent/repo-name (/home/user/projects/repo-name)

| # | Path | Branch | Last Commit | Action | Reason |
|---|------|--------|-------------|--------|--------|
| 1 | /var/tmp/... | feature/foo | 2025-02-28 | REMOVE | Fully merged into main |
| 2 | /var/tmp/... | feature/bar | 2025-03-01 | REMOVE | Stale (15 days) |
| 3 | /var/tmp/... | feature/baz | 2025-03-14 | KEEP | Active, has unmerged commits |

## parent/other-repo (/home/user/projects/other-repo)

| # | Path | Branch | Last Commit | Action | Reason |
|---|...
```

**Ask:** "I'll remove worktrees marked REMOVE. Proceed?"

**Wait for confirmation before deleting anything.**

### 5. Remove confirmed worktrees

```bash
git -C "$repo" worktree remove <path>
git -C "$repo" branch -d <branch-name> 2>/dev/null
```

After all removals per repo:
```bash
git -C "$repo" worktree prune
```

### 6. Final report

Show the same table updated with results (REMOVED / KEPT / SKIPPED / FAILED).

## Safety Rules

- **Never remove the main worktree** (the one on main/master/dev).
- **Never remove the current worktree** you are operating from.
- **Always confirm** before removing. No silent deletions.
- If `git worktree remove` fails (locked, dirty), report the error and move on.
- Use `git branch -d` (safe delete), never `-D` (force delete).

## Quick Reference

| Condition | Action | Reason |
|-----------|--------|--------|
| Is main worktree | SKIP | Never touch main |
| Is current worktree | SKIP | Can't remove self |
| Branch HEAD is ancestor of main | REMOVE | Work already in main |
| Last commit ≥ 14 days ago | REMOVE | Stale branch |
| Active + unmerged commits | KEEP | Work in progress |
| Locked worktree | KEEP | Report lock, skip |
