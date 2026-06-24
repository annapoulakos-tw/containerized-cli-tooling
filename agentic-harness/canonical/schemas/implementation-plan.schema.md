# Implementation Plan Schema

## Purpose

This document defines the required structure of an implementation plan.

An implementation plan explains how an approved spec will be broken into research and tasks.

It is a planning artifact only. It does not define scope, change acceptance criteria, or authorize implementation beyond the spec.

---

# Required Fields

## Identifier

A unique identifier.

Example:

```text
plan:001
```

---

## Title

A short descriptive name.

---

## Spec

The parent spec this plan implements.

Example:

```text
spec:001
```

---

## Summary

A concise description of the implementation approach.

The summary should explain how the work will be divided, not how every line of code will be written.

---

## Research Needed

Research questions that must be answered before or during implementation.

If no research is needed, state:

```text
None
```

---

## Research References

Research artifacts used by this plan.

If none exist, state:

```text
None
```

---

## Task Breakdown

The tasks that will implement the spec.

Each task must reference a task identifier and short title.

Example:

```text
task:001 — Add file discovery
task:002 — Add hash generation
```

---

## Task Dependencies

Dependencies between tasks.

If no dependencies exist, state:

```text
None
```

---

## Status

Valid values:

```text
Draft
Approved
In Progress
Complete
Blocked
Cancelled
```

---

# Optional Fields

## Parallelization Opportunities

Tasks that may safely run in parallel.

---

## Risks

Known implementation risks.

If no risks are known, state:

```text
None
```

---

## Out of Scope

Items explicitly excluded from the plan.

This should normally reference the parent spec's non-goals.

---

# Plan Quality Requirements

An implementation plan is considered usable when:

* It references one approved parent spec.
* It does not expand the spec scope.
* Research needs are identified or explicitly marked as none.
* Tasks are small, outcome-oriented, and independently verifiable.
* Task dependencies are clear.
* Parallel work is only identified when tasks are independent.

---

# Invalid Implementation Plans

## Scope Expansion

```text
Also add a web UI while implementing the CLI feature.
```

Reason:

The plan expands beyond the parent spec.

---

## Vague Task Breakdown

```text
task:001 — Build everything
```

Reason:

The task is too large and not independently verifiable.

---

## Hidden Architecture Decision

```text
Use a plugin framework for all future extensibility.
```

Reason:

Architecture decisions must be justified by the spec or research.

---

# Authority

The implementation plan derives authority from the spec.

The plan may organize work.

The plan may not redefine the outcome, acceptance criteria, constraints, or non-goals of the spec.
