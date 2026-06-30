# Spec spec:010: Root README Harness Configuration

## Summary

Update the repository root `README.md` so its Agent Harness section explains how to configure and load the harness using the current single-prompt entrypoint instead of the existing three-line prompt snippet.

## Outcome

Readers can follow the root README to configure an AI CLI session for the Agent Harness using the current generated harness entrypoint prompt. The README no longer instructs users to provide the old three-line prompt that manually states the harness root and acknowledgement behavior.

## Acceptance Criteria

* The root `README.md` Agent Harness section contains instructions for configuring the harness.
* The root `README.md` replaces the existing three-line harness prompt snippet with the current prompt: `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md`.
* The README keeps `{TOOL}` guidance for supported tool-specific harness paths, including `codex` and `copilot`.
* The README still explains that the wrappers refresh and mount the generated tool-specific harness build when available.
* The README does not duplicate or conflict with generated harness bootstrap instructions.
* Existing non-harness README content remains unchanged unless needed for continuity around the Agent Harness section.

## Assumptions

* confirmed: The primary README is the root `README.md`.
* confirmed: The existing three-line prompt is the snippet in the root README Agent Harness section.
* assumed: The requested "above prompt" is `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md`.
* assumed: This spec covers documentation only and does not require changes to generated harness files, wrapper behavior, or runtime paths.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Keep the change limited to the root `README.md` unless verification reveals directly related documentation inconsistencies.

## Non Goals

* Do not implement this spec as part of spec creation.
* Do not change harness runtime behavior.
* Do not change generated bootstrap files.
* Do not change wrapper mount paths.
* Do not document unsupported harness tools beyond existing supported-tool guidance.

## Open Questions

* None

## Research Required

* None

## Risks

* If the intended "above prompt" refers to different text than the single `Read .../AGENTS.md` prompt, the README could be updated with the wrong user-facing instruction.

## Dependencies

* Existing root `README.md` Agent Harness section.
* Existing generated harness entrypoint at `/home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md`.

## Status

Complete
