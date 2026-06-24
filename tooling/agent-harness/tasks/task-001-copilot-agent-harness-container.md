# Task task:001: Build, Mount, and Document Copilot Harness Support

## Parent Spec

spec:001

## Outcome

The Copilot wrapper prepares the generated Copilot harness when tooling is available, mounts that generated harness read-only at `/home/copilot/.copilot/agent-harness`, and documentation tells users how to verify the mount without changing project-owned instruction files.

## Acceptance Criteria

* `agentic-harness/build.sh copilot` produces `agentic-harness/build/copilot/AGENTS.md` and support directories from canonical definitions.
* The sourceable Bash wrapper refreshes or uses `${AI_HARNESS_ROOT:-$HOME/code/agentic-harness}/build/copilot` and mounts it read-only at `/home/copilot/.copilot/agent-harness` when present.
* The Zsh autoload wrapper has matching Copilot harness refresh and read-only mount behavior.
* The wrappers do not mount the harness over `/workspace/AGENTS.md`.
* The README documents the Copilot harness mount path and a command to verify files are readable from a running Copilot container.
* Existing Codex, Gemini, and Rovo wrapper behavior is preserved except for shared harness handling.

## Implementation Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior.
* Stay within task scope.
* Do not introduce a test framework solely for this change.

## Dependencies

None

## Context

The Bash wrapper already contains partial harness support. The Zsh autoload wrapper and README need to be checked and updated to match the approved spec. Existing Rovo and Makefile worktree changes are accepted external context and are not part of this task's Copilot harness delta.

## Files Likely Affected

* shell-functions/ai-cli.sh
* zsh-autoload-funcs/ai-cli
* README.md
* tests/ai-cli-harness-smoke.sh

## Status

Complete
