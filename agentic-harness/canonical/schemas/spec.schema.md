# Spec Schema

## Purpose

This document defines the required structure of a spec.

A spec is the authoritative description of a desired outcome.

All implementation, research, coding, QA, and auditing activities must derive from the spec.

The spec is the source of truth for scope.

---

# Required Fields

A valid spec must contain all required fields.

## Identifier

A unique identifier.

Example:

```text
spec:001
```

---

## Title

A short descriptive name.

Example:

```text
Manifest Generator
```

---

## Summary

A concise description of the desired outcome.

The summary should explain what is being built and why.

Maximum length: 250 words.

---

## Outcome

A description of what must be true when the work is complete.

The outcome should focus on observable behavior rather than implementation details.

Good:

```text
Users can generate a manifest containing file hashes.
```

Bad:

```text
Implement a HashManifestBuilder class.
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
- Given a valid directory, a manifest is generated.
- The manifest contains SHA256 hashes.
- Output ordering is deterministic.
```

A spec must contain at least one acceptance criterion.

---

## Assumptions

List assumptions made during spec creation.

Each assumption must be either:

- confirmed
- rejected
- unresolved

---

## Constraints

Rules that govern implementation.

Examples:

```text
- Apply skill: tdd.
- Prefer existing libraries.
- No new dependencies.
- Maintain backwards compatibility.
```

Constraints may be technical, operational, or organizational.

---

## Non Goals

Explicitly defines what is not included.

Example:

```text
- No GUI.
- No cloud upload.
- No database integration.
```

Every spec should contain at least one non-goal.

---

## Status

Valid values:

```text
Draft
Approved
In Progress
QA
Complete
Blocked
Cancelled
```

Status transitions are governed by the state machine.

---

# Optional Fields

Optional fields may be omitted when not applicable.

---

## Context

Additional background information.

May include:

* Business context
* User workflows
* Existing behavior
* Historical notes

---

## Open Questions

Unresolved questions.

Example:

```text
- Should symbolic links be included?
- Should hidden files be ignored?
```

Open questions should be resolved before implementation begins.

---

## Research Required

Research topics that must be investigated.

Example:

```text
- Compare available hashing libraries.
- Investigate platform-specific path handling.
```

Each item may generate a research artifact.

---

## Risks

Known concerns that may affect implementation.

Examples:

```text
- Existing API consumers may depend on current behavior.
- Performance may degrade with large directories.
```

---

## Dependencies

External requirements that must exist before implementation begins.

Examples:

```text
- Spec:000
- Research:003
```

---

# Spec Quality Requirements

A spec is considered implementable when:

* Outcome is defined.
* Acceptance criteria are present.
* Constraints are defined.
* Non-goals are defined.
* No blocking open questions remain.

---

# Invalid Specifications

The following are invalid:

## Implementation-Driven Specs

```text
Create a FooManager class.
```

Reason:

Focuses on implementation rather than outcome.

---

## Ambiguous Specs

```text
Improve performance.
```

Reason:

Cannot be objectively verified.

---

## Open-Ended Specs

```text
Make the system better.
```

Reason:

No measurable completion criteria.

---

# Authority

The spec defines scope.

No agent may expand scope without explicit approval.

When implementation, research, QA results, or assumptions conflict with the spec, the spec takes precedence.
