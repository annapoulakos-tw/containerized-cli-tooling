# QA Review qa:005: task:002 Relocate Harness Runtime Artifacts

## Scope

task:002 for spec:002

## Result

Pass

## Local Verification

* Canonical `/spec` guidance writes and resolves specs under `tooling/agent-harness/specs/`.
* Canonical `/implement` guidance writes plans, research, tasks, QA, audits, and completion artifacts under `tooling/agent-harness/`.
* Missing referenced specs stop with a clear not-found error and no root-level fallback.
* Harness README documents the new root and manual migration path.
* Generated Codex, Copilot, Gemini, and Rovo command files contain the new artifact root guidance.
* Existing root-level artifact directories were not moved or deleted.

## Commands Run

```sh
bash -n /workspace/tests/agent-harness-artifact-root-smoke.sh
bash /workspace/tests/agent-harness-artifact-root-smoke.sh
for tool in codex copilot gemini rovo; do bash /workspace/agentic-harness/build.sh "$tool"; done
rg -n '^plans/\*|^research/\*|^tasks/\*|^qa/\*|^completion/\*' /workspace/agentic-harness/canonical /workspace/agentic-harness/build
```

The final `rg` command exited with status 1 because no standalone root-level output lines were found.

## Notes

This repository does not currently include standalone `/qa` or `/audit` command files. QA and audit artifact paths are specified through `/implement`, the qa-reviewer agent, the spec-auditor agent, and the audit template.

## Independent QA

The independent QA reviewer reported PASS with no blocking findings.

## Status

Complete
