# QA Review qa:007: task:003 Install Shared ai-cli Entrypoint

## Scope

task:003 for spec:003

## Result

Pass

## Local Verification

* `make install-source` installs `shell-functions/ai-cli.sh` into a temporary source function directory without `TOOL`.
* `make install-zsh` installs `zsh-autoload-funcs/ai-cli` into a temporary Zsh function directory without `TOOL`.
* Install output instructs users to source `ai-cli.sh` or autoload `ai-cli`.
* README examples use `ai-cli codex .` and the `ai-cli <tool> <project>` command form.
* `make build` still fails without `TOOL`, preserving tool-specific image build behavior.
* Existing wrapper smoke verification still passes.

## Commands Run

```sh
bash /workspace/tests/ai-cli-harness-smoke.sh
bash -n /workspace/shell-functions/ai-cli.sh
bash -n /workspace/tests/ai-cli-harness-smoke.sh
make -C /workspace install-source SOURCE_FUNCTION_DIR=/workspace/.tmp/install-source-check
make -C /workspace install-zsh ZSH_FUNCTION_DIR=/workspace/.tmp/install-zsh-check
make -C /workspace build
```

The final `make -C /workspace build` command exited with status 2 because `TOOL` is still required for image builds.

## Notes

Temporary install directories from direct Make target checks were removed after verification.

## Status

Complete
