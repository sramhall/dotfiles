---
name: step-implementer
description: Automatically executes plans after ExitPlanMode using implementer/reviewer sub-agent pairs. Each step gets a fresh implementer (Opus) that works and commits, then a fresh reviewer (Opus) that validates. Steps marked complete only after review passes.
---

# Step Implementer

Execute a multi-step plan using paired sub-agents per step.

## When to Use

Activates automatically whenever a plan exists and the session transitions from plan mode to edit mode (ExitPlanMode). This is the default execution strategy for plans -- no manual invocation needed.

## Front Matter Injection

**Before dispatching any sub-agent**, read these files and paste their full content into the `{FRONT_MATTER}` placeholder in the prompt:
1. `~/.claude/CLAUDE.md` (user preferences, permission rules)
2. `./CLAUDE.md` or `./AGENTS.md` (project conventions -- use whichever exists)

This is mandatory. Sub-agents have no context unless you provide it.

## Per-Step Workflow

### 1. Identify Next Step
- Read the plan file. Find the next step where `Implementation complete` is unchecked.
- Verify all blocker steps (listed in parentheses) have `[x] Review passed`.
- Extract the step's full task description from the plan body.

### 2. Dispatch Implementer
- Use Agent tool with `model: "opus"`.
- Fill in `templates/implementer-prompt.md`:
  - `{FRONT_MATTER}` -- content of the files from Front Matter Injection above
  - `{STEP_SPEC}` -- full task description from the plan
  - `{PLAN_FILE_PATH}` -- absolute path to the plan file
  - `{REVIEW_FEEDBACK}` -- empty on first pass; reviewer's issues on re-dispatch
- Wait for the implementer to report back.

### 3. Dispatch Reviewer
- Use Agent tool with `model: "opus"`.
- Fill in `templates/reviewer-prompt.md`:
  - `{FRONT_MATTER}` -- same content as implementer
  - `{STEP_SPEC}` -- same task description
  - `{IMPLEMENTER_REPORT}` -- the implementer's report (commit SHA, files, concerns)
- Wait for the reviewer's verdict.

### 4. Handle Verdict
- **PASS**: Mark `- [ ] Review passed` -> `- [x]` in plan. Move to next step.
- **FAIL**: Dispatch a new implementer with the reviewer's issues in `{REVIEW_FEEDBACK}`. Then re-dispatch reviewer. Max 3 cycles, then escalate to user.

### 5. Tear Down and Repeat
- Each step uses fresh Agent calls (no SendMessage continuation).
- Move to the next unchecked step.

## Rules

- One step at a time. Never start N+1 before N passes review.
- Respect dependency order from the Progress Tracker.
- After 3 failed review cycles, stop and ask the user.
- The orchestrator (you) marks the parent checkbox only after both sub-items are checked.
