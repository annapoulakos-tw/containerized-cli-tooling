# Task Schema

## Purpose

This document defines the required structure of a task.

A task is the smallest independently executable unit of work within a spec.

Tasks are created by the spec-implementer and executed by a task-coder.

Tasks must be specific, bounded, and independently verifiable.

A task is not a project, milestone, or phase.

---

# Required Fields

A valid task must contain all required fields.

---

## Identifier

A unique identifier.

Example:

```text
task:001
```

---

## Parent Spec

The spec that owns this task.

Example:

```text
spec:001
```

Every task must belong to exactly one spec.

---

## Title

A short descriptive name.

Example:

```text
Add manifest file discovery
```

---

## Outcome

A concise description of the behavior this task delivers.

The outcome must be observable.

Good:

```text
The system discovers all regular files within the target directory.
```

Bad:

```text
Create a FileDiscovery class.
```

---

## Acceptance Criteria

A list of verifiable conditions.

Acceptance criteria must be:

* Observable
* Testable
* Unambiguous

Example:

```text
- Regular files are discovered.
- Directories are ignored.
- Results are deterministic.
```

Every task must contain at least one acceptance criterion.

---

## Implementation Constraints

Additional requirements inherited from the spec or introduced by planning.

Examples:

```text
- Apply skill: tdd.
- No new dependencies.
- Preserve existing behavior.
- Follow repository conventions.
```

---

## Dependencies

Tasks that must complete before this task may begin.

Example:

```text
- task:001
- task:002
```

If no dependencies exist, the field should explicitly state:

```text
None
```

---

## Status

Valid values:

```text
Todo
In Progress
QA
Complete
Blocked
Cancelled
```

Status transitions are governed by the state machine.

---

# Optional Fields

---

## Context

Additional implementation context.

Examples:

* Existing behavior
* Related files
* Architectural notes
* Research findings

Context should assist implementation without redefining scope.

---

## Files Likely Affected

A best-effort prediction of files that may require modification.

Example:

```text
src/discovery.py
tests/test_discovery.py
```

This field is informational only.

---

## Research References

Research artifacts relevant to the task.

Example:

```text
research:003
research:005
```

---

## Risks

Known implementation concerns.

Examples:

```text
- Existing callers may depend on current ordering.
- Large directories may impact performance.
```

---

# Task Quality Requirements

A task is considered executable when:

* Parent spec exists.
* Outcome is defined.
* Acceptance criteria exist.
* Dependencies are satisfied.
* No blocking questions remain.

---

# Task Sizing Rules

Tasks should be small.

A task should ideally:

* Modify one behavior.
* Deliver one outcome.
* Be completed in a single coding session.
* Be reviewable without requiring additional planning.

Large tasks should be decomposed.

Good:

```text
Add recursive file discovery.
```

Bad:

```text
Implement manifest generation system.
```

---

# Task Ownership

| Responsibility | Agent            |
| -------------- | ---------------- |
| Creation       | spec-implementer |
| Execution      | task-coder       |
| Verification   | qa-reviewer      |
| Audit          | spec-auditor     |

---

# Completion Requirements

A task may be marked Complete only when:

* Acceptance criteria are satisfied.
* Required tests pass.
* QA review passes.
* No unresolved blockers remain.

Completion does not imply the parent spec is complete.

---

# Invalid Tasks

The following are invalid:

## Vague Tasks

```text
Improve the codebase.
```

Reason:

No measurable outcome.

---

## Multi-Outcome Tasks

```text
Implement manifest generation, add upload support, and redesign the UI.
```

Reason:

Contains multiple independent outcomes.

---

## Architecture Tasks

```text
Create a ManifestService abstraction.
```

Reason:

Describes implementation rather than behavior.

---

## Research Tasks

```text
Investigate available hashing libraries.
```

Reason:

Research belongs in a research artifact.

---

# Authority

Tasks derive authority from their parent spec.

A task may narrow scope.

A task may not expand scope.

If a task conflicts with its parent spec, the spec takes precedence.
