# Task task:010: Generate Bootstrap Entrypoints for Codex and Copilot

## Parent Spec

spec:009

## Outcome

The `codex` and `copilot` harness builds emit bootstrap `AGENTS.md` and `BOOTSTRAP.md` files from the canonical bootstrap templates with `{TOOL}` placeholders resolved.

## Acceptance Criteria

* `agentic-harness/build/codex/AGENTS.md` is generated from `agentic-harness/canonical/bootstrap/AGENTS.md`.
* `agentic-harness/build/codex/BOOTSTRAP.md` is generated from `agentic-harness/canonical/bootstrap/BOOTSTRAP.md`.
* `agentic-harness/build/copilot/AGENTS.md` is generated from `agentic-harness/canonical/bootstrap/AGENTS.md`.
* `agentic-harness/build/copilot/BOOTSTRAP.md` is generated from `agentic-harness/canonical/bootstrap/BOOTSTRAP.md`.
* Generated bootstrap files for `codex` and `copilot` contain no unresolved `{TOOL}` placeholders.
* Generated bootstrap files for `codex` and `copilot` preserve packet generation, skills, and support directories.
* Build verification covers the generated bootstrap entrypoint files for `codex` and `copilot`.

## Implementation Constraints

* Apply skill: tdd
* Apply skill: shell-style
* Prefer minimal code
* Preserve existing behavior unless explicitly required
* Stay within task scope
* Do not change `gemini` or `rovo` generated bootstrap behavior

## Dependencies

None

## Context

The canonical bootstrap files are new untracked files under `agentic-harness/canonical/bootstrap/`. Existing build behavior emits an aggregate `AGENTS.md` for all tools and only emits `BOOTSTRAP.md` for `copilot`.

## Files Likely Affected

* `/workspace/agentic-harness/build.sh`
* `/workspace/agentic-harness/tests/build-copilot-bootstrap.sh`

## Implementation Notes

* Added bootstrap template rendering for `codex` and `copilot`.
* Preserved `copilot` tool-profile copying.
* Left `gemini` and `rovo` bootstrap behavior unchanged.
* Verification:
  * `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh`
  * `bash /workspace/agentic-harness/tests/build-packets.sh`
  * `bash /workspace/agentic-harness/tests/context-budget-rules.sh`
  * `bash /workspace/agentic-harness/tests/anti-overengineering-guidance.sh`
  * `bash /workspace/tests/agent-harness-artifact-root-smoke.sh`
  * `bash /workspace/tests/ai-cli-harness-smoke.sh`

## Status

Complete
