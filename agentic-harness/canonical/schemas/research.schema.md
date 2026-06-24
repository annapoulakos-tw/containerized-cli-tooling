# Research Schema

## Purpose

This document defines the required structure of a research artifact.

A research artifact answers a focused question needed by a spec or task.

Research artifacts support planning and implementation. They are not general documentation, design documents, or implementation plans.

---

# Required Fields

## Identifier

A unique identifier.

Example:

```text
research:001
```

---

## Title

A short descriptive name.

Example:

```text
Filename Parsing Strategy
```

---

## Request

The question or uncertainty being researched.

The request must be specific enough to answer directly.

---

## Findings

The relevant facts, observations, or evidence discovered during research.

Findings should be concise and limited to information needed for the spec or task.

---

## Recommendation

The recommended action based on the findings.

A recommendation must be actionable.

---

## Confidence

Valid values:

```text
High
Medium
Low
```

Confidence indicates how reliable the recommendation is.

---

## Status

Valid values:

```text
Requested
In Progress
Complete
Superseded
```

Status transitions are governed by the state machine.

---

# Optional Fields

## Context

Background information that explains why the research was requested.

---

## Alternatives Considered

Other options reviewed during research.

This section should be concise.

---

## Risks

Known concerns, tradeoffs, or uncertainty related to the recommendation.

If there are no known risks, state:

```text
None
```

---

# Research Quality Requirements

A research artifact is considered complete when:

* The request is answered.
* Findings are summarized.
* A recommendation is provided.
* Confidence is declared.
* Known risks or tradeoffs are documented.

---

# Invalid Research Artifacts

## Vague Research

```text
Look into this.
```

Reason:

The request is not specific enough to answer.

---

## Implementation Work

```text
Add filename parsing support.
```

Reason:

Research artifacts answer questions. They do not modify code.

---

## Open-Ended Design

```text
Design the whole manifest system.
```

Reason:

Design and planning belong in specs, tasks, or implementation plans.

---

# Authority

Research informs implementation.

Research does not define scope.

If research conflicts with the spec, the spec takes precedence unless the spec is explicitly revised.
