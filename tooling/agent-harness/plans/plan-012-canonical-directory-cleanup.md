# Implementation Plan

Spec: `spec-012-canonical-directory-cleanup`

Status: Complete

# Scope

Implement the approved canonical directory cleanup, bootstrap consolidation, build output changes, and role delegation guidance defined by spec 012.

# Tasks

1. `task-012-canonical-directory-cleanup`
   - Owner role: `task-coder`
   - Scope: update `agentic-harness/canonical/`, `agentic-harness/build.sh`, and harness tests so the approved spec is satisfied.
   - QA role: `qa-reviewer`
   - Status: QA Passed

# Delegation Matrix

| Workflow need | Required role | Handoff condition |
| --- | --- | --- |
| Production and test edits | `task-coder` | The implementation task is ready. |
| Independent task verification | `qa-reviewer` | The task-coder reports implementation complete with verification evidence. |
| Final lifecycle and evidence audit | `spec-auditor` | All task QA reports pass and completion evidence exists. |

# Verification Targets

- `agentic-harness/tests/build-packets.sh`
- `agentic-harness/tests/build-copilot-bootstrap.sh`
- `agentic-harness/tests/context-budget-rules.sh`
- `agentic-harness/tests/anti-overengineering-guidance.sh`

# Notes

- The spec is approved.
- The spec-implementer must not edit production files directly.
