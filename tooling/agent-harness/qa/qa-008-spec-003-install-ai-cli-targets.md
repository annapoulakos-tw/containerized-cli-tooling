# QA Review qa:008: spec:003 Install ai-cli Targets

## Scope

Full-spec QA for spec:003

## Result

Pass

## Verification

* Sourceable function installation succeeds without `TOOL` and installs `ai-cli.sh`.
* Zsh autoload installation succeeds without `TOOL` and installs `ai-cli`.
* Install output references `ai-cli`, not per-tool shell commands.
* Documentation shows `ai-cli codex .` and `ai-cli <tool> <project>` examples.
* Build targets remain tool-specific through the existing `check-tool` path.
* Per-tool install validation was removed from install target dependencies.
* Smoke verification installs into temporary directories.
* Existing `ai-cli` wrapper behavior remains covered by the existing smoke test.

## Commands Run

```sh
bash /workspace/tests/ai-cli-harness-smoke.sh
bash /workspace/tests/agent-harness-artifact-root-smoke.sh
bash -n /workspace/shell-functions/ai-cli.sh
bash -n /workspace/tests/ai-cli-harness-smoke.sh
bash -n /workspace/tests/agent-harness-artifact-root-smoke.sh
make -C /workspace install-source SOURCE_FUNCTION_DIR=/workspace/.tmp/install-source-check
make -C /workspace install-zsh ZSH_FUNCTION_DIR=/workspace/.tmp/install-zsh-check
make -C /workspace build
```

The final `make -C /workspace build` command exited with status 2 because `TOOL` is still required for image builds.

## Status

Complete
