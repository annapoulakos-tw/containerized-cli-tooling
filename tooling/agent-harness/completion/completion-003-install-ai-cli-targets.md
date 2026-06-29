# Completion Report completion:003: Install ai-cli Targets

## Spec

spec:003

## Result

Complete

## Summary

The Makefile install targets now install the shared `ai-cli` sourceable and Zsh autoload entrypoints without requiring `TOOL`. Documentation now shows setup and invocation through `ai-cli`, and smoke verification covers temporary install destinations.

## Completed Tasks

* task:003 - Install shared ai-cli entrypoint

## Verification

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

## QA And Audit

* qa:007 passed task QA.
* qa:008 passed full-spec QA.
* audit:003 passed final audit.

## Known Follow-Up Work

* None

## Status

Complete
