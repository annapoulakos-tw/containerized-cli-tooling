# Task task:003: Install Shared ai-cli Entrypoint

## Parent Spec

spec:003

## Outcome

The Makefile install targets install the shared `ai-cli` sourceable and Zsh autoload entrypoints without requiring `TOOL`, and documentation shows users how to invoke tools through `ai-cli`.

## Acceptance Criteria

* `make install-source` installs `shell-functions/ai-cli.sh` into the configured source function directory without requiring `TOOL`.
* `make install-zsh` installs `zsh-autoload-funcs/ai-cli` into the configured Zsh function directory without requiring `TOOL`.
* Install output instructs users to source or autoload `ai-cli`.
* README setup examples use `ai-cli codex .` and `ai-cli <tool> <project>` style invocations instead of per-tool installed commands.
* `make build TOOL=<tool>` remains tool-specific.
* Smoke verification covers install targets with temporary destination directories.

## Implementation Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior.
* Stay within task scope.
* Do not reintroduce per-tool installed shell functions.
* Do not require Docker to verify install-target behavior.

## Dependencies

None

## Context

The repository currently contains `shell-functions/ai-cli.sh` and `zsh-autoload-funcs/ai-cli`, while the Makefile install targets still check for `shell-functions/$(TOOL).sh` and `zsh-autoload-funcs/$(TOOL)`.

## Files Likely Affected

* Makefile
* README.md
* tests/ai-cli-harness-smoke.sh

## Status

Complete
