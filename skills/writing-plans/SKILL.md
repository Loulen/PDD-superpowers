---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `ai_docs/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```

**Acceptance Criteria:**

**REQUIRED SUB-SKILL:** Use superpowers:actionable-acceptance-criteria

Each criterion is a verification *action* — something you execute, call, observe, or query to prove the task works. Not a code-inspection statement.

- [ ] [Action]: [What to do — run command, call endpoint, observe UI, query state]
      Expected: [What you should see]
- [ ] [Action]: [Another verification action]
      Expected: [Expected result]
````

## Acceptance Criteria

**REQUIRED SUB-SKILL:** Use superpowers:actionable-acceptance-criteria when writing acceptance criteria for each task.

Every task MUST include an `**Acceptance Criteria:**` block (see Task Structure above). Each criterion must be a concrete verification *action* — something the implementer can execute, call, observe, or query. Never write criteria that can only be verified by reading code.

Actions include: running commands, calling endpoints, observing UI behavior, querying databases, checking logs, or any interaction from the actionable-acceptance-criteria verification hierarchy.

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## After Saving the Plan

**Render a mermaid diagram** (invoke `superpowers:mermaid-diagrams`) showing a high-level overview of the plan's task flow. Tell the user where the plan is saved.

## Execution Handoff

After saving the plan, proceed directly with subagent-driven development:

**"Plan complete and saved to `ai_docs/<filename>.md`. Proceeding with subagent-driven execution."**

- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**Platform fallback:** If the platform does not support subagents (e.g. Codex — no Task tool available), fall back to `superpowers:executing-plans` for sequential batch execution. Guide the user to open a new session in the worktree.

**User override:** If the user explicitly requests a parallel session or executing-plans, honor that request.
