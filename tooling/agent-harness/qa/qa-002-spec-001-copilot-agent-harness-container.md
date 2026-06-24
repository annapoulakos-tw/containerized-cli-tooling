# QA Review qa:002: spec:001 Copilot Agent Harness Container Support

## Scope

Full-spec QA and audit for spec:001

## Result

Fail

## Passing Evidence

* `agentic-harness/build.sh copilot` produces `agentic-harness/build/copilot/AGENTS.md` and support directories.
* The Bash wrapper refreshes the harness build and mounts it read-only at `/home/copilot/.copilot/agent-harness`.
* The Zsh autoload wrapper contains matching harness refresh and read-only mount behavior.
* The harness is mounted under the tool home path, not `/workspace/AGENTS.md`.
* README documents the stable Copilot mount path and verification commands.
* `bash /workspace/tests/ai-cli-harness-smoke.sh` passed.
* `bash /workspace/agentic-harness/build.sh copilot` passed.
* `bash -n /workspace/shell-functions/ai-cli.sh` passed.
* `bash -n /workspace/tests/ai-cli-harness-smoke.sh` passed.

## Blocking Findings

Independent QA and audit failed the preservation criterion because unrelated Rovo and Makefile behavior changes are present in the worktree:

* Rovo wrapper/auth/cache behavior changed outside the Copilot harness scope.
* `make build-all` changed to use `--no-cache`, outside the Copilot harness scope.

Those changes may be valid user work, but spec:001 cannot be marked complete while independent review treats them as scope violations.

## Resolution

The user explicitly accepted the unrelated Rovo/Makefile changes as external context and instructed QA to evaluate only the Copilot harness delta.

## Status

Superseded
