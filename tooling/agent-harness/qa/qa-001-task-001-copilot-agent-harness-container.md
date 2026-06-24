# QA Review qa:001: task:001 Copilot Agent Harness Container Support

## Scope

task:001 for spec:001

## Result

Fail

## Acceptance Criteria Verification

* `agentic-harness/build.sh copilot` produced `agentic-harness/build/copilot/AGENTS.md` and support files.
* `tests/ai-cli-harness-smoke.sh` verified the Bash wrapper refreshes the Copilot harness build and mounts it read-only at `/home/copilot/.copilot/agent-harness`.
* `tests/ai-cli-harness-smoke.sh` statically verified the Zsh autoload wrapper contains matching harness refresh and read-only mount behavior.
* `tests/ai-cli-harness-smoke.sh` verified the wrapper does not mount the harness over `/workspace/AGENTS.md`.
* README documentation includes the stable Copilot mount path and verification commands.

## Commands Run

```sh
bash /workspace/tests/ai-cli-harness-smoke.sh
bash /workspace/agentic-harness/build.sh copilot
bash -n /workspace/shell-functions/ai-cli.sh
bash -n /workspace/tests/ai-cli-harness-smoke.sh
```

## Blocking Findings

Independent QA and audit rejected completion because the current worktree includes unrelated behavior changes outside spec:001:

* Rovo wrapper/auth/cache behavior differs from the original repository state.
* `make build-all` uses `--no-cache`, which is outside the Copilot harness scope.

These changes were already present before this implementation work began, and they were not reverted because they appear to be user-owned worktree changes.

## Notes

`zsh` is not installed in this environment, so Zsh wrapper verification is static. Full Docker runtime verification was not run; the README includes the manual Docker verification command required by the spec.

## Status

Blocked
