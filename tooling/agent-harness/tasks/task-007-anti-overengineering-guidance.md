# Task task:007: Encode Anti-Overengineering Guidance

## Parent Spec

spec:007

## Outcome

The harness gives `task-coder` explicit anti-overengineering rules by default and gives `qa-reviewer` explicit authority to flag technically correct but unnecessarily large or abstract implementations.

## Acceptance Criteria

* `task-coder` guidance discourages one-line, one-use helper functions for trivial transformations.
* `task-coder` guidance prefers inline idiomatic code for simple local operations.
* `task-coder` guidance discourages classes, factories, registries, frameworks, and extension points unless required by the spec or existing repository conventions.
* `qa-reviewer` guidance flags technically correct implementations that are unnecessarily large, abstract, or structured beyond the approved spec.
* The guidance is available in generated build output or copied skill files.

## Implementation Constraints

* Apply skill: tdd
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

None

## Context

Use the existing `minimal-code` skill instead of adding a new skill unless a new skill is necessary.

## Files Likely Affected

* `/workspace/agentic-harness/canonical/skills/minimal-code/SKILL.md`
* `/workspace/agentic-harness/canonical/agents/qa-reviewer/AGENTS.md`
* `/workspace/agentic-harness/canonical/packets/qa-review.md`
* `/workspace/agentic-harness/tests/*`

## Implementation Notes

* Updated the existing `minimal-code` skill instead of adding a new skill.
* Added coder guidance to prefer inline idiomatic code for simple local operations.
* Added coder guidance against one-line, one-use helper functions for trivial transformations.
* Added coder guidance against classes, factories, registries, frameworks, and extension points unless required by the spec or existing repository conventions.
* Added QA guidance to flag technically correct implementations that are unnecessarily large, abstract, or structured beyond the approved spec.
* Added `tests/anti-overengineering-guidance.sh` to verify canonical and generated guidance.
* Verification runs:
  * `bash /workspace/agentic-harness/tests/anti-overengineering-guidance.sh`
  * `bash /workspace/agentic-harness/tests/build-packets.sh`
  * `bash /workspace/agentic-harness/tests/context-budget-rules.sh`
  * `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh`

## Status

Complete
