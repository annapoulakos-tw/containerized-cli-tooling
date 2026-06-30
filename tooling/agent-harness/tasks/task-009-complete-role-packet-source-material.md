# Task task:009: Complete Role Packet Source Material

## Parent Spec

spec:008

## Outcome

Role packets include the embedded command, agent, template, schema, state-rule, and skill material needed to replace `AGENTS.md` for delegated workflow execution.

## Acceptance Criteria

* Generated `spec-create.md` includes runtime roots, role, workflow, hard stops, approval gate, and output location.
* Generated `spec-create.md` includes embedded material from `commands/spec.md`, `agents/spec-creator/AGENTS.md`, `templates/spec.md`, `schemas/spec.schema.md`, relevant `state/state-machine.md` rules, and `skills/outcome-driven/SKILL.md`.
* All generated packets include embedded command, agent, state-rule, and skill material.
* Workflow packets include the relevant embedded template and schema details for their artifact type.
* Packet verification fails if generated packets instruct normal delegated agents to load/read harness instruction files instead of using embedded packet material.
* Verification covers `codex`, `copilot`, `gemini`, and `rovo`.

## Implementation Constraints

* Apply skill: tdd
* Apply skill: shell-style
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

* task:008

## Context

User review found that the first spec:008 implementation made packets self-contained only as summaries. The required correction is to include enough embedded source material for packets to be used in place of `AGENTS.md` when delegating to sub-agents.

## Files Likely Affected

* `/workspace/agentic-harness/canonical/packets/*.md`
* `/workspace/agentic-harness/tests/build-packets.sh`

## Implementation Notes

* Expanded `spec-create.md` with runtime roots, role, output location, workflow, hard stops, approval gate, embedded command, embedded agent, full embedded spec template, embedded spec schema details, relevant state rules, and outcome-driven skill material.
* Added embedded command, agent, template/schema, state-rule, and skill sections to the remaining packets.
* Standardized packet root section as `Runtime`.
* Strengthened `build-packets.sh` to require embedded source-material sections and workflow-specific templates/schemas.
* Verification:
  * `bash /workspace/agentic-harness/tests/build-packets.sh`
  * `bash /workspace/agentic-harness/tests/context-budget-rules.sh`
  * `bash /workspace/agentic-harness/tests/anti-overengineering-guidance.sh`
  * `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh`
  * `bash /workspace/tests/agent-harness-artifact-root-smoke.sh`
  * `bash /workspace/tests/ai-cli-harness-smoke.sh`

## Status

Complete
