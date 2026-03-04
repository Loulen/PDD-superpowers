# Actionable Acceptance Criteria Enforcement

## Problem

Three gaps in the current pdd-superpowers workflow cause acceptance criteria to be ignored in practice:

1. **Plans lack embedded acceptance criteria.** `writing-plans` mentions `actionable-acceptance-criteria` as a REQUIRED SUB-SKILL in a separate section, but the task structure template has no acceptance criteria block. Writers skip it.

2. **The implementer doesn't execute verification actions.** The implementer prompt says "Verify implementation works" — one vague line. Implementers skip verification commands, E2E tests, and other actions listed in the plan. Nobody notices.

3. **The spec reviewer doesn't enforce execution evidence.** The spec reviewer prompt asks "Were the verification steps actually executed?" but it's a sub-bullet, not a hard gate. Reviewers say PASS without checking.

Additionally, `docs/plans/` is being renamed to `ai_docs/` across all skills.

## Design

### Change 1: Acceptance criteria in the task structure template

Add an `**Acceptance Criteria:**` block inside the `writing-plans` task structure template (the ````markdown` block). Each criterion must be a concrete verification *action* — not a code-inspection statement. Actions include running commands, calling endpoints, observing UI behavior, querying databases, or any interaction from the `actionable-acceptance-criteria` verification hierarchy.

The existing "Acceptance Criteria" section stays but now points at the template as the enforcement point.

### Change 2: Implementer executes every acceptance criterion action

Replace the implementer prompt's vague step 3 with an explicit gate:

- The implementer must execute every acceptance criterion action from the task.
- Actions are not just commands — they are anything that interacts with the real system: run a command, call an endpoint, observe UI behavior, query state, check logs.
- For each action, the implementer pastes evidence: command output, response body, observation description.
- If an action can't be performed (deps not installed, no browser, no database), the implementer must **flag it as blocked** — not skip silently.
- Reference `verification-before-completion` as a REQUIRED SUB-SKILL.

Update the Report Format to include acceptance criteria results.

### Change 3: Folder rename `docs/plans/` → `ai_docs/`

All references to `docs/plans/` across skills become `ai_docs/`. Flat directory, filename convention (`*-design.md` vs `*-plan.md`) distinguishes document types.

**Files affected:**
- `brainstorming/SKILL.md` — design doc save path
- `writing-plans/SKILL.md` — plan save path and execution handoff message
- `requesting-code-review/SKILL.md` — example reference
- `subagent-driven-development/SKILL.md` — example reference

## Files to modify

| File | Changes |
|------|---------|
| `skills/writing-plans/SKILL.md` | Add acceptance criteria block to task template; update save path |
| `skills/subagent-driven-development/implementer-prompt.md` | Replace step 3 with verification gate; update report format |
| `skills/brainstorming/SKILL.md` | Update save path |
| `skills/requesting-code-review/SKILL.md` | Update example path |
| `skills/subagent-driven-development/SKILL.md` | Update example path |
