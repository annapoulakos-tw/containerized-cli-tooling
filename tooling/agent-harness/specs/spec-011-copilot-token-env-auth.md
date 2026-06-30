# Spec spec:011: Copilot Token Environment Authentication

## Summary

Allow users to provide a Copilot authentication token through a host environment variable when starting the Copilot container, so a newly created container can authenticate without requiring an interactive `/login` step every time.

## Outcome

When a user starts a Copilot coding session with the supported Copilot token environment variable set on the host, the wrapper injects that value into the container for Copilot's standard token authentication flow. Users who do not set the token environment variable continue to use the existing login flow and persistent Copilot home volume behavior.

## Context

GitHub's official Copilot CLI authentication documentation identifies `COPILOT_GITHUB_TOKEN` as the highest-precedence authentication environment variable, followed by `GH_TOKEN` and `GITHUB_TOKEN`. The wrapper should use `COPILOT_GITHUB_TOKEN` as the explicit Copilot-specific variable to avoid accidentally reusing tokens intended for other GitHub tools.

Official source documentation: https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli

## Acceptance Criteria

* Given `COPILOT_GITHUB_TOKEN` is set on the host, the Copilot wrapper injects it into the Copilot container.
* Given `COPILOT_GITHUB_TOKEN` is set on the host, a fresh Copilot container can authenticate with Copilot's standard token authentication flow without requiring the user to run `/login`.
* Given `COPILOT_GITHUB_TOKEN` is not set on the host, the Copilot container preserves the current authentication behavior.
* The token value is not printed by the wrapper, startup scripts, tests, or documentation examples.
* Documentation identifies the supported environment variable name and shows the expected host-side setup flow.
* Documentation for GitHub Copilot CLI authentication includes a bibliography entry linking to the official GitHub source documentation.
* Existing Codex, Gemini, and Rovo wrapper behavior is unchanged.
* Verification covers both the token-present and token-absent Copilot wrapper behavior.

## Assumptions

* confirmed: The public host environment variable should be named `COPILOT_GITHUB_TOKEN`, matching the official Copilot CLI authentication docs.
* confirmed: Copilot authentication should use standard token authentication via an injected environment variable.
* confirmed: Documentation should include a bibliography link to the official GitHub Copilot CLI authentication docs.
* confirmed: The requested behavior is specific to the Copilot container.
* confirmed: Users still need an alternative login path when no token is provided.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Keep authentication changes scoped to the Copilot wrapper and Copilot documentation.
* Do not persist the token into project files, harness artifacts, or generated build output.
* Avoid logging or echoing secret values.

## Non Goals

* Do not implement this spec as part of spec creation.
* Do not change Copilot account provisioning or token generation.
* Do not replace the existing Copilot persistent home volume behavior.
* Do not add token-based authentication for Codex, Gemini, or Rovo.
* Do not redesign the shared Docker wrapper structure.

## Open Questions

* None

## Research Required

* None

## Risks

* Copilot CLI authentication behavior may change across CLI versions.
* Writing token-derived state into the persistent home volume could unintentionally retain credentials beyond the lifetime of a single container.
* Tests must avoid exposing real token values in logs or fixtures.

## Dependencies

* Existing Copilot Docker image and wrapper behavior.
* Existing persistent `copilot-home` Docker volume behavior.

## Status

Complete
