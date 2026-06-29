# Task task:005: Add Copilot Bootstrap and Tool Profile Build Output

## Parent Spec

spec:005

## Outcome

The Copilot harness build includes a Copilot-only bootstrap file sourced from canonical harness content, and the canonical harness contains a Copilot tool profile documenting Copilot's prompt and context requirements.

## Acceptance Criteria

* `build.sh copilot` creates a Copilot bootstrap file in `build/copilot/`.
* The bootstrap hard-codes `/home/copilot/.copilot/agent-harness`.
* The bootstrap hard-codes `/workspace/tooling/agent-harness`.
* The bootstrap tells Copilot not to search `/workspace` for harness files.
* The bootstrap tells Copilot to use `packets/` for workflow-specific instructions.
* The bootstrap is copied from canonical source.
* A canonical Copilot tool profile documents smaller prompts, repeated harness-root anchors, explicit artifact-root rules, and one role packet per workflow.
* Non-Copilot builds do not receive the Copilot bootstrap.
* Existing generated `AGENTS.md` output remains present.

## Implementation Constraints

* Apply skill: tdd
* Apply skill: shell-style
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

* spec:004 packet output support

## Context

Use canonical harness definitions under `/workspace/agentic-harness/canonical/` as the durable source. Build output under `/workspace/agentic-harness/build/` is generated.

## Files Likely Affected

* `/workspace/agentic-harness/build.sh`
* `/workspace/agentic-harness/canonical/bootstrap/copilot.md`
* `/workspace/agentic-harness/canonical/tool-profiles/copilot.md`
* `/workspace/agentic-harness/tests/*`

## Implementation Notes

* Added canonical Copilot bootstrap source at `/workspace/agentic-harness/canonical/bootstrap/copilot.md`.
* Added canonical Copilot tool profile at `/workspace/agentic-harness/canonical/tool-profiles/copilot.md`.
* Updated `build.sh` to copy the Copilot bootstrap and tool profile only for the `copilot` build.
* Updated build strategy documentation to describe Copilot bootstrap and tool profile outputs.
* Added `tests/build-copilot-bootstrap.sh` to verify bootstrap roots, packet instruction, canonical source copying, canonical profile content, preserved `AGENTS.md`, and no bootstrap for non-Copilot builds.
* Verification runs:
  * `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh`
  * `bash /workspace/agentic-harness/tests/build-packets.sh`

## Status

Complete
