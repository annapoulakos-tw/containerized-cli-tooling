# Task task:012: Add Copilot Token Environment Passthrough

## Parent Spec

spec:011

## Outcome

The Copilot wrappers pass `COPILOT_GITHUB_TOKEN` from the host into the Copilot container, and the README documents the supported token setup flow with an official GitHub source link.

## Acceptance Criteria

* The Bash sourceable wrapper passes `--env COPILOT_GITHUB_TOKEN` only for Copilot.
* The Zsh autoload wrapper passes `--env COPILOT_GITHUB_TOKEN` only for Copilot.
* Existing Gemini and Rovo environment passthrough behavior remains unchanged.
* Tests verify Copilot token-present and token-absent wrapper behavior without exposing token values.
* README documentation identifies `COPILOT_GITHUB_TOKEN` and shows the host-side setup flow.
* README documentation includes a bibliography entry linking to the official GitHub Copilot CLI authentication docs.

## Implementation Constraints

* Apply skill: tdd
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope
* Do not persist token values into files or generated harness output.
* Avoid logging or echoing secret values.

## Dependencies

None

## Context

Spec:011 selected `COPILOT_GITHUB_TOKEN` because official GitHub Copilot CLI docs list it as the highest-precedence authentication environment variable, ahead of `GH_TOKEN` and `GITHUB_TOKEN`.

## Files Likely Affected

* shell-functions/ai-cli.sh
* zsh-autoload-funcs/ai-cli
* tests/ai-cli-harness-smoke.sh
* README.md

## Status

Complete
