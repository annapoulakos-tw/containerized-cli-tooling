# Spec spec:009: Bootstrap Entrypoint Generation

## Summary

Extend the harness build output so the new canonical bootstrap entrypoint files are generated for the `codex` and `copilot` tool builds. The canonical bootstrap files contain `{TOOL}` placeholders, and built outputs must contain the correct tool-specific values so container injection can place them at the expected harness runtime paths.

## Outcome

When a `codex` or `copilot` harness build is generated, `build/{TOOL}/AGENTS.md` and `build/{TOOL}/BOOTSTRAP.md` are produced from `canonical/bootstrap/AGENTS.md` and `canonical/bootstrap/BOOTSTRAP.md` with tool placeholders resolved. The generated files can be injected into the container under that tool's harness directory and direct the agent to the correct bootstrap, harness root, artifact root, and workflow packets.

## Acceptance Criteria

* For the `codex` build target, `build/codex/AGENTS.md` is generated from `canonical/bootstrap/AGENTS.md`.
* For the `codex` build target, `build/codex/BOOTSTRAP.md` is generated from `canonical/bootstrap/BOOTSTRAP.md`.
* For the `copilot` build target, `build/copilot/AGENTS.md` is generated from `canonical/bootstrap/AGENTS.md`.
* For the `copilot` build target, `build/copilot/BOOTSTRAP.md` is generated from `canonical/bootstrap/BOOTSTRAP.md`.
* Generated bootstrap files do not contain unresolved `{TOOL}` placeholders.
* Generated `AGENTS.md` points to the generated `BOOTSTRAP.md` path for the same tool.
* Generated `BOOTSTRAP.md` states the correct harness root for the same tool.
* Generated `BOOTSTRAP.md` preserves the artifact root `/workspace/tooling/agent-harness`.
* Generated `BOOTSTRAP.md` lists the available workflow packets from the tool-specific harness root.
* Existing packet generation, skill copying, and support directory copying continue to work for `codex` and `copilot`.
* Existing build verification covers the generated bootstrap entrypoint files for `codex` and `copilot`.

## Assumptions

* confirmed: The canonical source files are `agentic-harness/canonical/bootstrap/AGENTS.md` and `agentic-harness/canonical/bootstrap/BOOTSTRAP.md`.
* confirmed: Built bootstrap entrypoint files should be emitted at `agentic-harness/build/{TOOL}/AGENTS.md` and `agentic-harness/build/{TOOL}/BOOTSTRAP.md` for `codex` and `copilot`.
* confirmed: Runtime artifact files remain under `/workspace/tooling/agent-harness`.
* confirmed: `gemini` and `rovo` bootstrap entrypoint generation is deferred.

## Constraints

* Apply skill: tdd.
* Apply skill: shell-style.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Keep canonical harness definitions as the source of truth for generated files.
* Do not hard-code generated bootstrap content separately from the canonical bootstrap files.

## Non Goals

* Do not implement this spec as part of spec creation.
* Do not redesign workflow packet content.
* Do not change artifact root locations.
* Do not add new supported tool build targets.
* Do not change `gemini` or `rovo` generated bootstrap behavior in this spec.
* Do not change container injection mechanics outside the generated build artifacts.

## Open Questions

* None

## Research Required

* None

## Risks

* A mismatch between generated bootstrap paths and container injection paths could prevent agents from loading the harness bootstrap.
* Replacing the generated aggregate `AGENTS.md` with the bootstrap entrypoint may affect workflows that still expect all harness instructions in `AGENTS.md`.

## Dependencies

* Existing `agentic-harness/build.sh` build flow.
* Existing canonical bootstrap files under `agentic-harness/canonical/bootstrap/`.
* Existing `codex` and `copilot` build targets.

## Status

Complete
