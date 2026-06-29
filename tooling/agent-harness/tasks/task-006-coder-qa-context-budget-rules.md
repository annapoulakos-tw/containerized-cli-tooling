# Task task:006: Add Coder and QA Context Budget Rules

## Parent Spec

spec:006

## Outcome

`task-coder` and `qa-reviewer` workflow instructions define focused context budget rules that start from the assigned task or QA target, load only relevant supporting context, and avoid broad harness artifact loading by default.

## Acceptance Criteria

* `task-coder` instructions start context loading from the assigned task.
* `qa-reviewer` instructions start context loading from the assigned QA target.
* Both workflows list the allowed focused context.
* Both workflows forbid loading all specs, all tasks, all QA artifacts, all schemas, or the full harness by default.
* Both workflows allow broader context only when explicitly needed and require the reason to be recorded.
* Generated role packets remain compatible with the focused context budget rules.
* Verification covers canonical and generated coder/QA workflow instructions.

## Implementation Constraints

* Apply skill: tdd
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

* spec:004 packet output support

## Context

The relevant canonical files are `/workspace/agentic-harness/canonical/agents/task-coder/AGENTS.md`, `/workspace/agentic-harness/canonical/agents/qa-reviewer/AGENTS.md`, `/workspace/agentic-harness/canonical/packets/task-code.md`, and `/workspace/agentic-harness/canonical/packets/qa-review.md`.

## Files Likely Affected

* `/workspace/agentic-harness/canonical/agents/task-coder/AGENTS.md`
* `/workspace/agentic-harness/canonical/agents/qa-reviewer/AGENTS.md`
* `/workspace/agentic-harness/canonical/packets/task-code.md`
* `/workspace/agentic-harness/canonical/packets/qa-review.md`
* `/workspace/agentic-harness/tests/*`

## Implementation Notes

* Added explicit Context Budget Rules sections to `task-coder` and `qa-reviewer`.
* Updated `task-code` and `qa-review` role packets to require focused context and reason recording for broader context.
* Added `tests/context-budget-rules.sh` to verify canonical and generated coder/QA workflow instructions.
* Verification runs:
  * `bash /workspace/agentic-harness/tests/context-budget-rules.sh`
  * `bash /workspace/agentic-harness/tests/build-packets.sh`
  * `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh`

## Status

Complete
