# Spec spec:004: Compiled Role Packets

## Summary

Extend the canonical agent harness build so each supported tool build includes generated workflow-specific role packets under `build/<tool>/packets/`. These packets give agents smaller instruction files for common harness workflows while preserving the existing generated `AGENTS.md` output and copied support files.

## Outcome

When the harness build runs for a supported tool, the resulting build directory contains the existing `AGENTS.md` output plus packet files for the initial workflows. Each packet contains only the information needed for that workflow: command, agent, artifact rules, context budget, relevant schema/template summary, and assigned skills.

## Acceptance Criteria

* Given the build runs for a supported tool, `build/<tool>/AGENTS.md` is still generated as it is today.
* Given the build runs for a supported tool, `build/<tool>/packets/` is created.
* The generated packets include exactly the initial workflow packet names: `spec-create`, `spec-review`, `spec-update`, `implement-orchestrate`, `task-code`, `qa-review`, and `audit-review`.
* Each generated packet identifies the relevant harness command for its workflow.
* Each generated packet identifies the responsible agent for its workflow.
* Each generated packet includes the artifact lifecycle and completion rules relevant to its workflow.
* Each generated packet includes a context budget appropriate to the workflow.
* Each generated packet includes a concise summary of only the schemas and templates relevant to its workflow.
* Each generated packet includes the assigned skills needed for its workflow, based on canonical skill assignment rules.
* Packet content is generated from canonical harness definitions rather than maintained as hand-edited build output.
* Packet content does not include unrelated full harness sections, unrelated schemas, unrelated templates, or unrelated agents.
* The build remains deterministic: running the same build from the same canonical inputs produces the same packet files.
* Verification confirms packet generation for every currently supported tool build target.
* Existing copied support directories and skill files continue to be produced where they are produced today.

## Assumptions

* confirmed: The existing generated `AGENTS.md` build output must remain in place for now.
* confirmed: Role packets are additive build artifacts under `build/<tool>/packets/`.
* confirmed: The initial packet set is `spec-create`, `spec-review`, `spec-update`, `implement-orchestrate`, `task-code`, `qa-review`, and `audit-review`.
* confirmed: Packets should be smaller workflow-specific instruction files, not full concatenated harness documents.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Do not remove or replace the existing `AGENTS.md` build output.
* Do not make generated packet files the source of truth.
* Keep canonical harness definitions as the source of truth for generated packet content.
* Keep packet scope limited to command, agent, artifact rules, context budget, relevant schema/template summary, and assigned skills.

## Non Goals

* Do not remove existing generated `AGENTS.md` files.
* Do not redesign the harness state machine or artifact lifecycle.
* Do not change runtime artifact locations.
* Do not add new workflow commands beyond the initial packet set.
* Do not change agent behavior except through the generated packet packaging.
* Do not implement this spec as part of spec creation.

## Open Questions

* None

## Research Required

* Identify the canonical command, agent, schema, template, state, and skill-assignment sources needed to generate each initial packet.

## Risks

* Packet summaries may drift from canonical schemas or templates if they are not generated or validated from canonical inputs.
* Overly broad packets would fail to provide the intended context savings for workflow-specific agents.

## Dependencies

* Existing canonical harness definitions under `canonical/`.
* Existing build workflow that writes `build/<tool>/AGENTS.md` and support files.
* Existing supported tool list.

## Status

Complete
