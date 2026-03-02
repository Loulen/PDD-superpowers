---
name: actionable-acceptance-criteria
description: Use when writing acceptance criteria for features, plan tasks, or issues — elevates each criterion with concrete verification steps that prove implementation works by interacting with the real system
---

# Actionable Acceptance Criteria

## Core Principle

**"Is my implementation working?"** can only be answered by **interacting with the real thing**.

Verification requires execution, not inspection. The goal is to prove the implementation works by observing its actual behavior, not by confirming code exists.

### The Fundamental Question

Ask yourself: **"What can I actually run, call, or query to prove this works?"**

---

## Driving Questions for Verification

When defining acceptance criteria or validating an implementation, ask:

1. **What command can I run** to see this in action?
2. **What endpoint can I call** to test the behavior?
3. **What query can I execute** to see the result?
4. **What observable effect** should this produce?
5. **What tool gives me direct access** to the running system?
6. **How would a human verify** this works?
7. **What evidence proves** the feature is functioning?

---

## Verification Hierarchy

Prioritize verification approaches in this order:

1. **Execute the thing** - Run the actual code, pipeline, or service
2. **Observe the output** - Check logs, responses, return values
3. **Query the state** - Examine database, filesystem, API state
4. **Test the interaction** - Use the feature as a user would (Playwright MCP, browser, UI)

---

## Available Tools to Consider

Think about what tools can interact with your implementation:

| Tool Category | Examples | Use For |
|---------------|----------|---------|
| Terminal (Bash) | CLI commands, scripts, curl | Running code, calling APIs, checking processes |
| Browser MCP | Playwright, Chrome DevTools | UI interactions, network inspection, visual verification |
| Database access | psql, mysql, mongo shell | Verifying data state, checking records |
| Cloud CLIs | aws, gcloud, az, kubectl | Checking deployed resources, container state |
| Container tools | docker exec, docker logs | Inspecting running services |
| Test runners | pytest, jest, gradle test | Executing test suites |
| HTTP tools | curl, httpie, wget | Direct API calls |
| One-off scripts | Python/bash scripts | Custom verification for complex scenarios |

---

## Anti-Patterns

What NOT to do when writing acceptance criteria:

| Anti-Pattern | Why It Fails | Better Approach |
|--------------|--------------|-----------------|
| "Code exists in file X" | Existence doesn't prove functionality | Run the code and observe behavior |
| "Tests pass" (without running them) | Assumption without verification | Execute `pytest` / `npm test` and check output |
| "Syntax is correct" | Compiling doesn't mean working | Execute and verify results |
| "Deployment succeeded" (based on script exit) | Script success doesn't prove functionality | Call the deployed service |
| "Configuration is set" | Config existence doesn't mean it's applied | Query the running system's actual state |
| "Logs show no errors" | Absence of errors doesn't prove correctness | Verify positive evidence of correct behavior |

---

## Applying the Principle

When you encounter a task requiring verification:

1. **Stop and think:** What is the actual behavior I need to verify?
2. **Identify the interaction point:** What tool or command gives me access?
3. **Define observable evidence:** What specific output/state proves success?
4. **Write the verification step:** Include the exact command/action and expected result
5. **Report concrete findings:** Share what you observed, not what you assumed

The goal is **proof through interaction**, not confidence through inspection.
