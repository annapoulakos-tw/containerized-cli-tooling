# Completion Report completion:002: Relocate Harness Runtime Artifacts

## Spec

spec:002

## Result

Complete

## Summary

Harness runtime artifact guidance now uses `tooling/agent-harness/` consistently across canonical strategy, `/spec`, `/implement`, agents, templates, documentation, and generated tool-specific harness builds.

## Completed Tasks

* task:002 - Update Harness Artifact Root Guidance and Verification

## Verification

```sh
bash -n /workspace/tests/agent-harness-artifact-root-smoke.sh
bash /workspace/tests/agent-harness-artifact-root-smoke.sh
for tool in codex copilot gemini rovo; do bash /workspace/agentic-harness/build.sh "$tool"; done
rg -n '^plans/\*|^research/\*|^tasks/\*|^qa/\*|^completion/\*' /workspace/agentic-harness/canonical /workspace/agentic-harness/build
```

The final `rg` command exited with status 1 because no standalone root-level output lines were found.

## QA And Audit

* qa:005 passed task QA.
* qa:006 passed full-spec QA.
* audit:002 passed final audit.

## Known Follow-Up Work

* The user will manually move legacy root-level harness artifacts into `tooling/agent-harness/` after this work.
* Existing root-level artifact directories were intentionally left in place.

## Status

Complete
