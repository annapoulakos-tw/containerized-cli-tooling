# Spec spec:001: Copilot Agent Harness Container Support

## Summary

Support building the agent harness for Copilot and mounting that built harness into the Copilot container so Copilot can use the same harness workflow definitions as other supported tools.

## Outcome

When a user builds and runs the Copilot container through the existing tooling, the Copilot-specific agent harness build is available read-only at `/home/copilot/.copilot/agent-harness` without replacing project-owned files in `/workspace`.

## Acceptance Criteria

* Given the agent harness source exists at `${AI_HARNESS_ROOT:-$HOME/code/agentic-harness}`, the repository can produce a Copilot-specific harness build artifact at `build/copilot`.
* Given the Copilot wrapper starts a container, it refreshes or uses the Copilot harness build before container startup when the harness build tooling is available.
* Given the Copilot harness build exists on the host, the Copilot container mounts `build/copilot` read-only at `/home/copilot/.copilot/agent-harness`.
* The Copilot mount location `/home/copilot/.copilot/agent-harness` is documented and stable enough for users to reference in startup instructions.
* The Codex container harness path remains `/home/codex/.codex/agent-harness`.
* The Copilot harness mount does not overwrite `/workspace/AGENTS.md` or other project-owned instruction files.
* Existing Codex, Gemini, and Rovo container behavior is preserved unless a shared wrapper change is required for compatibility.
* A verification path documents how to confirm from a running Copilot container that the harness files are present and readable.

## Assumptions

* confirmed: The host harness root is `${AI_HARNESS_ROOT:-$HOME/code/agentic-harness}`.
* confirmed: The Copilot container harness path is `/home/copilot/.copilot/agent-harness`.
* confirmed: The Codex container harness path remains `/home/codex/.codex/agent-harness`.
* confirmed: This spec only requires building and mounting the files at stable paths; it does not require automatic Copilot discovery.

## Constraints

* Apply skill: tdd
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Do not replace or mutate project-level instruction files when mounting the harness.
* Keep generated or tool-specific harness output derived from canonical harness definitions.
* Mount the tool-specific build directory `build/copilot` read-only for Copilot.
* If automated tests do not exist, verify changes with shell-level smoke checks.
* Do not introduce a test framework solely for this change.
* Provide manual verification commands when container limitations prevent full verification.

## Non Goals

* Do not implement the harness workflow itself.
* Do not redesign the agent harness schema, lifecycle, agents, or commands.
* Do not add a new orchestration service or daemon.
* Do not change Copilot authentication behavior.
* Do not require or validate automatic Copilot discovery of the mounted harness.
* Do not begin implementation as part of this spec creation.

## Open Questions

* None

## Research Required

* None

## Risks

* A read-only container may require careful handling of generated harness output before `docker run`.
* accepted external context: Existing Rovo and Makefile worktree changes are outside spec:001 and should not be evaluated as part of the Copilot harness delta.

## Dependencies

* Existing Copilot Docker image and wrapper support.
* Existing agent harness canonical definitions and build output.

## Status

Complete
