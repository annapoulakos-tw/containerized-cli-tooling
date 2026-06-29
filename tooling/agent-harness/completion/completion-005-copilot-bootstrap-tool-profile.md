# Completion Report completion:005: Copilot Bootstrap and Tool Profile

## Spec

spec:005

## Result

Complete

## Summary

The Copilot harness build now includes a Copilot-only bootstrap file copied from canonical source. The bootstrap anchors Copilot to `/home/copilot/.copilot/agent-harness`, directs runtime artifacts to `/workspace/tooling/agent-harness`, tells Copilot not to search `/workspace` for harness files, and directs workflow execution to `packets/`. The canonical harness now also includes a Copilot tool profile documenting Copilot's smaller prompt and context requirements.

## Completed Tasks

* task:005 - Add Copilot bootstrap and tool profile build output

## Verification

```sh
bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh
bash /workspace/agentic-harness/tests/build-packets.sh
```

## QA And Audit

* qa:011 passed task QA.
* qa:012 passed full-spec QA.
* audit:005 passed final audit.

## Known Follow-Up Work

* None

## Status

Complete
