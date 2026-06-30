# Completion Report completion:009: Bootstrap Entrypoint Generation

## Spec

spec:009

## Result

Complete

## Summary

The harness build now renders `AGENTS.md` and `BOOTSTRAP.md` from canonical bootstrap templates for the `codex` and `copilot` targets. The generated files substitute the correct tool name, point to each tool's harness bootstrap path, preserve artifact root guidance, and leave `gemini` and `rovo` bootstrap behavior unchanged.

## Completed Tasks

* task:010 - Generate bootstrap entrypoints for codex and copilot

## Verification

```sh
bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh
bash /workspace/agentic-harness/tests/build-packets.sh
bash /workspace/agentic-harness/tests/context-budget-rules.sh
bash /workspace/agentic-harness/tests/anti-overengineering-guidance.sh
bash /workspace/tests/agent-harness-artifact-root-smoke.sh
bash /workspace/tests/ai-cli-harness-smoke.sh
```

## QA And Audit

* qa:020 passed task QA.
* qa:021 passed full-spec QA.
* audit:009 passed final audit.

## Known Follow-Up Work

* Add `gemini` and `rovo` bootstrap entrypoint generation in a separate approved spec if needed.

## Status

Complete
