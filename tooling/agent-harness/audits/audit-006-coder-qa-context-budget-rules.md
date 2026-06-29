# Audit audit:006: Coder and QA Context Budget Rules

## Scope

spec:006

## Result

PASS

## Findings

* No blocking findings.
* `task-coder` now starts focused context from the assigned task.
* `qa-reviewer` now starts focused context from the assigned QA target.
* Both workflows list relevant parent spec sections, relevant research references, files likely affected, assigned role packet, and required skills.
* Both workflows prohibit loading all specs, all tasks, all QA artifacts, all schemas, or the full harness by default.
* Both workflows allow broader context only when explicitly needed and require the reason to be recorded.
* Existing `spec-implementer` behavior was not redesigned.
* Artifact lifecycle, completion, QA, audit, generated `AGENTS.md`, and runtime artifact locations were preserved.

## Evidence

* qa:013 passed task QA.
* qa:014 passed full-spec QA.
* `bash /workspace/agentic-harness/tests/context-budget-rules.sh` passed.
* `bash /workspace/agentic-harness/tests/build-packets.sh` passed.
* `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh` passed.

## Status

Complete
