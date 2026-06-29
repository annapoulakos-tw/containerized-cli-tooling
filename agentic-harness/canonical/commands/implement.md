# Command: /implement

# Invocation

Preferred portable form:

harness implement <arguments>

Legacy conceptual form:

/implement <arguments>

## Purpose

Execute an approved spec.

The `/implement` command is the primary orchestration entry point for turning a spec into completed, verified work.

Implementation is owned by the spec-implementer agent.

The `/implement` command includes QA, audit, and completion. Do not stop at QA unless blocked or explicitly instructed to pause.

---

# Inputs

The command accepts the following form:

```text
/implement spec:<id>
```

Example:

```text
/implement spec:001
```

The referenced spec must exist and be approved before implementation begins.

The referenced spec must be resolved only from:

```text
tooling/agent-harness/specs/
```

If the spec is not found there, stop with a clear not-found error. The workflow does not fall back to root-level `specs/`.

---

# Behavior

The command must execute the implementation workflow in order.

## 1. Load Spec

Load the referenced spec artifact.

Validate that:

* The spec exists.
* The spec conforms to the spec schema.
* The spec status is Approved.
* The spec has no blocking open questions.

If validation fails, stop and report the reason.

---

## 2. Create Implementation Plan

Create an implementation plan artifact using:

```text
templates/implementation-plan.md
```

The plan must conform to:

```text
schemas/implementation-plan.schema.md
```

The plan should identify:

* Research needed
* Research references
* Task breakdown
* Task dependencies
* Safe parallelization opportunities
* Risks

The plan may organize work.

The plan may not expand scope beyond the spec.

---

## 3. Resolve Research

If research is needed:

1. Create research request artifacts.
2. Delegate research to the spec-researcher agent.
3. Wait for research artifacts to reach Complete status.
4. Update the implementation plan with research references.
5. Revise task breakdown if research changes the implementation approach.

Research may inform implementation.

Research may not redefine scope.

---

## 4. Create Tasks

Create task artifacts using:

```text
templates/task.md
```

Each task must conform to:

```text
schemas/task.schema.md
```

Tasks must be:

* Small
* Outcome-oriented
* Independently verifiable
* Traceable to the parent spec
* Bound by the spec acceptance criteria

Tasks may narrow scope.

Tasks may not expand scope.

---

## 5. Execute Tasks

Delegate ready tasks to task-coder agents.

A task is ready when:

* Its dependencies are complete.
* Required research is complete.
* No blockers remain.
* No other active task is modifying the same files.

Task coders must:

* Follow assigned task scope.
* Apply required skills.
* Use Red-Green-Refactor TDD.
* Prefer minimal code.
* Preserve existing behavior.
* Return work for QA when complete.

---

## 6. Review Tasks

Delegate completed task work to the qa-reviewer agent.

QA must verify:

* Task acceptance criteria
* Relevant tests
* Regression risk
* Scope control
* Minimality of implementation

If QA fails, return the task to the task-coder with the QA findings.

A task may be marked Complete only after QA passes.

---

## 7. Final QA

When all tasks are complete, run full-spec QA.

Full-spec QA must verify:

* All spec acceptance criteria are satisfied.
* Required tests pass.
* No known regressions were introduced.
* No incomplete tasks remain.
* No blockers remain.

If full-spec QA fails, create or reopen tasks as needed.

---

## 8. Audit Completion

Delegate final alignment review to the spec-auditor.

The audit must verify:

* The implementation satisfies the original spec.
* The implementation did not expand scope.
* Acceptance criteria are satisfied.
* Non-goals were respected.
* QA evidence is present.

The spec may not be marked Complete until the audit passes.

---

## 9. Close Spec

When all tasks are complete, full-spec QA passes, and audit passes:

1. Create a completion report.
2. Mark the spec Complete.
3. Record final test results.
4. Record known follow-up work, if any.

---

# Outputs

The command may create or update:

```text
tooling/agent-harness/plans/*
tooling/agent-harness/research/*
tooling/agent-harness/tasks/*
tooling/agent-harness/qa/*
tooling/agent-harness/audits/*
tooling/agent-harness/completion/*
```

The command updates the referenced spec status according to the state machine.

---

# State Transitions

Valid spec transitions:

```text
Approved -> In Progress
In Progress -> QA
QA -> Complete
In Progress -> Blocked
QA -> Blocked
Blocked -> In Progress
```

Valid task transitions:

```text
Todo -> In Progress
In Progress -> QA
QA -> Complete
QA -> In Progress
In Progress -> Blocked
Blocked -> In Progress
```

All transitions must comply with:

```text
state/state-machine.md
```

---

# Parallel Execution Rules

Tasks may run in parallel only when:

* They have no dependency relationship.
* They do not modify the same files.
* They do not rely on unresolved research.
* They can be independently tested.
* The spec-implementer can merge or reconcile outputs safely.

If uncertain, execute tasks sequentially.

---

# Constraints

The command must:

* Treat the spec as the source of truth.
* Avoid scope expansion.
* Prefer small tasks.
* Prefer sequential execution over unsafe parallelism.
* Require QA before task completion.
* Require audit before spec completion.
* Preserve user work.
* Avoid destructive actions unless explicitly approved.

---

# Success Criteria

The command succeeds when:

* The spec is marked Complete.
* All tasks are marked Complete.
* Full-spec QA has passed.
* Final audit has passed.
* A completion report exists.

---

# Failure Conditions

The command must stop or block when:

* The spec does not exist.
* The spec is not approved.
* The spec violates the spec schema.
* Blocking open questions remain.
* Required research cannot be completed.
* QA repeatedly fails.
* The final audit fails.
* Safe implementation cannot proceed.

When blocked, the command must record:

* Reason for blockage
* Current artifact status
* Recommended next action
* Required owner
