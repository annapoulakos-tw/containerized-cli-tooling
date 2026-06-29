# Spec spec:003: Install ai-cli Targets

## Summary

Update the Makefile install workflow so users install the shared `ai-cli` shell entrypoint instead of tool-specific shell functions that no longer exist. This resolves the consistently failing `install-zsh` and `install-source` targets for users following the documented setup path.

## Outcome

Users can run the Makefile install targets successfully and then invoke tools through the shared command form, such as `ai-cli codex .`, without needing per-tool installed commands.

## Acceptance Criteria

* Given a user runs the sourceable function install target, the shared `shell-functions/ai-cli.sh` file is installed successfully without requiring `TOOL`.
* Given a user runs the Zsh autoload install target, the shared `zsh-autoload-funcs/ai-cli` file is installed successfully without requiring `TOOL`.
* The install output tells users to load or autoload `ai-cli`, not `codex`, `copilot`, `gemini`, or `rovo`.
* The documented normal invocation uses `ai-cli <tool> <project>`, including the `ai-cli codex .` example.
* Existing image build targets continue to require `TOOL` where a specific image is being built.
* The Makefile no longer validates per-tool shell function files for the install targets.
* Verification covers the Makefile install targets and confirms they can install into temporary directories.
* Existing `ai-cli` wrapper behavior is preserved for supported tools.

## Assumptions

* confirmed: Tools are no longer installed as individual shell commands.
* confirmed: The normal user invocation is `ai-cli codex .`.
* confirmed: The failing targets are `install-zsh` and `install-source`.
* confirmed: Build targets may still be tool-specific and continue to use `TOOL`.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Do not reintroduce per-tool installed shell functions.
* Do not require Docker to verify install-target behavior.
* Keep install destinations overrideable with the existing `ZSH_FUNCTION_DIR` and `SOURCE_FUNCTION_DIR` variables.

## Non Goals

* Do not change the `ai-cli` command interface.
* Do not rename supported tools or Docker images.
* Do not redesign the wrapper scripts.
* Do not change authentication, container runtime, or harness mount behavior.
* Do not implement this spec as part of spec creation.

## Open Questions

* None

## Research Required

* None

## Risks

* README setup examples may still reference the old per-tool install flow and need to be kept consistent with the corrected Makefile targets.

## Dependencies

* Existing `shell-functions/ai-cli.sh` sourceable wrapper.
* Existing `zsh-autoload-funcs/ai-cli` autoload wrapper.
* Existing Makefile install directory variables.

## Status

Complete
