# QA Review qa:006: spec:002 Relocate Harness Runtime Artifacts

## Scope

Full-spec QA for spec:002

## Result

Pass

## Verification

* `/spec` command guidance writes and resolves specs under `tooling/agent-harness/specs/`.
* `/implement` command guidance writes plans, research, tasks, QA, audits, and completion artifacts under `tooling/agent-harness/`.
* Missing referenced specs stop with a clear not-found error and do not fall back to root-level `specs/`.
* QA and audit artifact roots are aligned through canonical agents and templates.
* Documentation explains the new artifact root and manual migration or cleanup path.
* Generated Codex, Copilot, Gemini, and Rovo harness outputs contain the updated artifact root guidance.
* Existing root-level artifact directories were not moved or deleted.

## Commands Run

```sh
bash -n /workspace/tests/agent-harness-artifact-root-smoke.sh
bash /workspace/tests/agent-harness-artifact-root-smoke.sh
for tool in codex copilot gemini rovo; do bash /workspace/agentic-harness/build.sh "$tool"; done
rg -n '^plans/\*|^research/\*|^tasks/\*|^qa/\*|^completion/\*' /workspace/agentic-harness/canonical /workspace/agentic-harness/build
```

The final `rg` command exited with status 1 because no standalone root-level output lines were found.

## Status

Complete
