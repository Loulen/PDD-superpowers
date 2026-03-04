# Actionable Acceptance Criteria Enforcement — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make acceptance criteria actionable and enforced throughout the plan→implement→review workflow, and rename the docs folder to `ai_docs/`.

**Architecture:** Edit five existing skill/prompt files. No new files. Three logical changes: (1) embed acceptance criteria in the task template, (2) make the implementer execute every criterion action with evidence, (3) rename `docs/plans/` → `ai_docs/` everywhere.

**Tech Stack:** Markdown skill files (no code, no tests — these are prompt templates).

---

### Task 1: Add acceptance criteria block to writing-plans task structure template

**Files:**
- Modify: `skills/writing-plans/SKILL.md:47-88` (the Task Structure section)

**Step 1: Edit the task structure template**

In `skills/writing-plans/SKILL.md`, inside the fenced ````markdown` block (lines 49-88), add an `**Acceptance Criteria:**` block after the last step (Step 5: Commit). The block goes inside the template so every generated task will include it.

Add this before the closing ``````:

```markdown

**Acceptance Criteria:**

**REQUIRED SUB-SKILL:** Use superpowers:actionable-acceptance-criteria

Each criterion is a verification *action* — something you execute, call, observe, or query to prove the task works. Not a code-inspection statement.

- [ ] [Action]: [What to do — run command, call endpoint, observe UI, query state]
      Expected: [What you should see]
- [ ] [Action]: [Another verification action]
      Expected: [Expected result]
```

**Step 2: Update the existing Acceptance Criteria section**

The standalone "Acceptance Criteria" section (lines 90-94) currently says the same thing in prose. Update it to point at the template as the enforcement point. Replace lines 90-94 with:

```markdown
## Acceptance Criteria

**REQUIRED SUB-SKILL:** Use superpowers:actionable-acceptance-criteria when writing acceptance criteria for each task.

Every task MUST include an `**Acceptance Criteria:**` block (see Task Structure above). Each criterion must be a concrete verification *action* — something the implementer can execute, call, observe, or query. Never write criteria that can only be verified by reading code.

Actions include: running commands, calling endpoints, observing UI behavior, querying databases, checking logs, or any interaction from the actionable-acceptance-criteria verification hierarchy.
```

**Step 3: Commit**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "feat: embed acceptance criteria block in task structure template"
```

**Acceptance Criteria:**
- [ ] Read `skills/writing-plans/SKILL.md` and verify the task structure template (inside the fenced markdown block) contains an `**Acceptance Criteria:**` block with checkbox items showing action + expected result format
      Expected: The block appears after Step 5 and before the closing ``````, with the REQUIRED SUB-SKILL reference and example criteria format
- [ ] Read the standalone "Acceptance Criteria" section and verify it references the template
      Expected: Section says "see Task Structure above" and describes what qualifies as an action

---

### Task 2: Make the implementer execute every acceptance criterion action

**Files:**
- Modify: `skills/subagent-driven-development/implementer-prompt.md:29-37` (Your Job section)
- Modify: `skills/subagent-driven-development/implementer-prompt.md:70-77` (Report Format section)

**Step 1: Replace step 3 in "Your Job" section**

In `implementer-prompt.md`, the current "Your Job" section (lines 29-37) lists:

```
1. Implement exactly what the task specifies
2. Write tests (following TDD if task says to)
3. Verify implementation works
4. Commit your work
5. Self-review (see below)
6. Report back
```

Replace steps 3-6 with:

```
    3. **Execute every acceptance criterion action**
       - Each criterion in the task is a verification *action* — a command to run, endpoint to call, UI behavior to observe, state to query
       - Execute each one. Paste the evidence: command output, response body, observation description
       - If an action cannot be performed (deps not installed, no browser available, service not running), **flag it as blocked** — do NOT skip silently
       - REQUIRED SUB-SKILL: superpowers:verification-before-completion — no completion claims without fresh evidence
    4. Commit your work
    5. Self-review (see below)
    6. Report back
```

**Step 2: Update the Report Format section**

In `implementer-prompt.md`, the current Report Format (lines 72-77) lists:

```
- What you implemented
- What you tested and test results
- Files changed
- Self-review findings (if any)
- Any issues or concerns
```

Replace with:

```
    - What you implemented
    - Acceptance criteria results: for each criterion, what action you took and what you observed (paste output/evidence)
    - Blocked criteria: any acceptance criteria you could not execute, and why
    - Files changed
    - Self-review findings (if any)
    - Any issues or concerns
```

**Step 3: Commit**

```bash
git add skills/subagent-driven-development/implementer-prompt.md
git commit -m "feat: implementer must execute acceptance criteria actions with evidence"
```

**Acceptance Criteria:**
- [ ] Read `implementer-prompt.md` "Your Job" section and verify step 3 says "Execute every acceptance criterion action" with the bullet points about evidence and blocked actions
      Expected: Step 3 explicitly requires executing each criterion, pasting evidence, and flagging blocked actions. References `verification-before-completion`.
- [ ] Read `implementer-prompt.md` "Report Format" and verify it includes "Acceptance criteria results" and "Blocked criteria" lines
      Expected: Report format has two new lines for criterion results and blocked criteria

---

### Task 3: Rename `docs/plans/` to `ai_docs/` across all skills

**Files:**
- Modify: `skills/writing-plans/SKILL.md:18` and `:111`
- Modify: `skills/brainstorming/SKILL.md:30` and `:81`
- Modify: `skills/requesting-code-review/SKILL.md:61`
- Modify: `skills/subagent-driven-development/SKILL.md:98`

**Step 1: Update writing-plans/SKILL.md**

Line 18: Change `docs/plans/YYYY-MM-DD-<feature-name>.md` → `ai_docs/YYYY-MM-DD-<feature-name>.md`

Line 111: Change `docs/plans/<filename>.md` → `ai_docs/<filename>.md`

**Step 2: Update brainstorming/SKILL.md**

Line 30: Change `docs/plans/YYYY-MM-DD-<topic>-design.md` → `ai_docs/YYYY-MM-DD-<topic>-design.md`

Line 81: Change `docs/plans/YYYY-MM-DD-<topic>-design.md` → `ai_docs/YYYY-MM-DD-<topic>-design.md`

**Step 3: Update requesting-code-review/SKILL.md**

Line 61: Change `docs/plans/deployment-plan.md` → `ai_docs/deployment-plan.md`

**Step 4: Update subagent-driven-development/SKILL.md**

Line 98: Change `docs/plans/feature-plan.md` → `ai_docs/feature-plan.md`

**Step 5: Verify no remaining references to `docs/plans/`**

Run: `grep -r "docs/plans/" skills/`
Expected: No matches.

**Step 6: Commit**

```bash
git add skills/writing-plans/SKILL.md skills/brainstorming/SKILL.md skills/requesting-code-review/SKILL.md skills/subagent-driven-development/SKILL.md
git commit -m "refactor: rename docs/plans/ to ai_docs/ across all skills"
```

**Acceptance Criteria:**
- [ ] Run `grep -r "docs/plans/" skills/` from the pdd-superpowers directory
      Expected: No output (no remaining references)
- [ ] Run `grep -r "ai_docs/" skills/` from the pdd-superpowers directory
      Expected: Matches in writing-plans, brainstorming, requesting-code-review, and subagent-driven-development
