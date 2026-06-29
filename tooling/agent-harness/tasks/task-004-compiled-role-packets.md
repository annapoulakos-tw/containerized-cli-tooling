# Task task:004: Generate Compiled Role Packets

## Parent Spec

spec:004

## Outcome

Each supported harness tool build includes generated workflow-specific role packets under `build/<tool>/packets/` while preserving existing `AGENTS.md` and support-file output.

## Acceptance Criteria

* `build.sh` creates `build/<tool>/packets/` for every supported tool.
* The packet directory contains exactly `spec-create.md`, `spec-review.md`, `spec-update.md`, `implement-orchestrate.md`, `task-code.md`, `qa-review.md`, and `audit-review.md`.
* Each packet includes command, agent, artifact rules, context budget, relevant schema/template summary, and assigned skills.
* Existing `AGENTS.md`, copied support directories, and copied skill files remain generated.
* Verification builds every supported tool and validates the packet contract.

## Implementation Constraints

* Apply skill: tdd
* Apply skill: shell-style
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

None

## Context

Use canonical harness definitions under `/workspace/agentic-harness/canonical/` as the durable source. Build output under `/workspace/agentic-harness/build/` is generated.

## Files Likely Affected

* `/workspace/agentic-harness/build.sh`
* `/workspace/agentic-harness/canonical/packets/*.md`
* `/workspace/agentic-harness/tests/*`

## Implementation Notes

* Added canonical packet files for the seven required workflow packets.
* Updated `build.sh` to copy canonical packets into each supported tool build.
* Updated build strategy documentation to describe packet outputs.
* Added `tests/build-packets.sh` to verify packet presence, required packet sections, preserved support output, and deterministic regeneration.
* Verification run: `bash /workspace/agentic-harness/tests/build-packets.sh`.

## Status

Complete
