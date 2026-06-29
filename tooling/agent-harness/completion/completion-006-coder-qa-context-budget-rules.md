# Completion Report completion:006: Coder and QA Context Budget Rules

## Spec

spec:006

## Result

Complete

## Summary

The `task-coder` and `qa-reviewer` workflows now include focused context budget rules. Coder context starts from the assigned task, QA context starts from the assigned QA target, and both roles load only relevant parent spec sections, relevant research references, likely affected files, the assigned role packet, and required skills by default.

## Completed Tasks

* task:006 - Add coder and QA context budget rules

## Verification

```sh
bash /workspace/agentic-harness/tests/context-budget-rules.sh
bash /workspace/agentic-harness/tests/build-packets.sh
bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh
```

## QA And Audit

* qa:013 passed task QA.
* qa:014 passed full-spec QA.
* audit:006 passed final audit.

## Known Follow-Up Work

* None

## Status

Complete
