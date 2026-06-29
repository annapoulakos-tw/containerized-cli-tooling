# State Machine

## Purpose

This document defines the lifecycle of artifacts managed by the harness.

Agents may only transition artifacts according to the rules defined here.

The purpose of the state machine is to ensure work remains traceable, reviewable, and verifiable.

---

# Core Principles

1. The spec is the source of truth.
2. Agents may not expand scope without approval.
3. Work must be represented by artifacts.
4. Completion requires verification.
5. No worker agent may verify or approve its own direct output.

The spec-implementer may advance artifacts through QA, audit, and completion when acting as orchestrator, provided it creates separate QA/audit artifacts using the qa-reviewer/spec-auditor roles and records the evidence.

## Orchestrated Review Rule

The spec-implementer may initiate and coordinate QA, audit, and completion.

This does not violate "no agent approves its own work" when:

- QA is performed under the qa-reviewer role.
- Audit is performed under the spec-auditor role.
- QA and audit results are recorded as separate artifacts.
- The implementer does not skip or collapse those review steps.
- The completion report references the QA and audit artifacts.

The spec-implementer must not mark a task or spec Complete based only on its own implementation summary.

---

# Artifact Types

The harness manages the following artifacts:

* Spec
* Research
* Task
* QA Review
* Completion Report

---

# Spec Lifecycle

## States

```text
Draft
Approved
In Progress
QA
Complete
Blocked
Cancelled
```

## State Transitions

```text
Draft
 ├─> Approved
 ├─> Cancelled
 └─> Draft

Approved
 ├─> In Progress
 ├─> Blocked
 └─> Cancelled

In Progress
 ├─> QA
 ├─> Blocked
 └─> Cancelled

QA
 ├─> Complete
 ├─> In Progress
 └─> Blocked

Blocked
 ├─> In Progress
 └─> Cancelled

Complete
 └─> Terminal

Cancelled
 └─> Terminal
```

## Ownership

| State       | Responsible Agent |
| ----------- | ----------------- |
| Draft       | spec-creator      |
| Approved    | spec-creator      |
| In Progress | spec-implementer  |
| QA          | qa-reviewer       |
| Complete    | spec-auditor      |
| Blocked     | spec-implementer  |

---

# Task Lifecycle

## States

```text
Todo
In Progress
QA
Complete
Blocked
Cancelled
```

## State Transitions

```text
Todo
 ├─> In Progress
 └─> Cancelled

In Progress
 ├─> QA
 ├─> Blocked
 └─> Cancelled

QA
 ├─> Complete
 ├─> In Progress
 └─> Blocked

Blocked
 ├─> In Progress
 └─> Cancelled

Complete
 └─> Terminal

Cancelled
 └─> Terminal
```

## Ownership

| State       | Responsible Agent |
| ----------- | ----------------- |
| Todo        | spec-implementer  |
| In Progress | task-coder        |
| QA          | qa-reviewer       |
| Complete    | qa-reviewer       |
| Blocked     | spec-implementer  |

---

# Research Lifecycle

## States

```text
Requested
In Progress
Complete
Superseded
```

## Ownership

| State       | Responsible Agent |
| ----------- | ----------------- |
| Requested   | spec-implementer  |
| In Progress | spec-researcher   |
| Complete    | spec-researcher   |
| Superseded  | spec-implementer  |

---

# Completion Rules

A task may be marked Complete only when:

* Acceptance criteria are satisfied.
* Required tests pass.
* QA review passes.

A spec may be marked Complete only when:

* All tasks are Complete.
* Acceptance criteria are satisfied.
* QA review passes.
* Auditor review passes.

---

# Failure Rules

QA may reject any task.

Rejected tasks return to:

```text
QA -> In Progress
```

The original task remains the source of truth.

The task-coder is responsible for resolving the rejection.

---

# Blocking Rules

Any agent may declare work Blocked.

A blocked artifact must include:

* Reason for blockage
* Recommended next action
* Required owner

Blocked work may not be marked Complete.

---

# Parallel Work

Tasks may execute in parallel only when:

* They do not depend on each other.
* They do not modify the same files.
* They do not require the same unresolved research.

The spec-implementer is responsible for determining safe parallel execution.

---

# Final Authority

The spec defines scope.

The spec-implementer defines execution.

The qa-reviewer verifies correctness.

The spec-auditor verifies alignment between implementation and specification.
