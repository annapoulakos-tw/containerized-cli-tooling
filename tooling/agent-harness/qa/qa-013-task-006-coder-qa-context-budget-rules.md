# QA qa:013: Task 006 Coder and QA Context Budget Rules

## Scope

task:006 for spec:006

## Result

PASS

## Evidence Reviewed

* `task-coder` canonical instructions include focused Context Budget Rules.
* `qa-reviewer` canonical instructions include focused Context Budget Rules.
* `task-code` and `qa-review` packets remain compatible with focused context loading.
* Generated `build/codex` agent and packet files include the focused context rules.

## Verification

* `bash /workspace/agentic-harness/tests/context-budget-rules.sh` passed.
* `bash /workspace/agentic-harness/tests/build-packets.sh` passed.
* `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh` passed.

## Findings

* None

## Required Fixes

* None

## Status

Complete
