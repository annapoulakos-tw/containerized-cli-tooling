# Role Packet: spec-update

## Runtime

Harness root: `{{HARNESS_ROOT}}`

Artifact root: `{{ARTIFACT_ROOT}}`

## Command

`harness spec spec:<id> revise <changes>` updates an existing spec artifact.

## Agent

`spec-creator`

## Artifact Rules

* Update the target spec under the artifact root `specs` directory.
* Preserve the spec as the source of truth and do not expand scope without user approval.
* Keep unresolved material questions visible in `Open Questions` and keep the spec in `Draft` when those questions block approval.
* Stop after updating the spec; do not create plans, tasks, code, QA, audit, or completion reports.
* Valid status transitions for this workflow are `Draft` to `Approved`, `Draft` to `Cancelled`, `Approved` to `Draft`, and `Approved` to `In Progress` only when explicitly requested by the proper workflow.

## Context Budget

Use the target spec, the requested revision, and this packet. Do not read other harness instruction files during normal execution. Do not read unrelated specs, tasks, QA artifacts, or the full harness unless explicitly needed to resolve a referenced dependency.

## Schema and Template Summary

Maintain a markdown spec with identifier and title in the heading, plus `Summary`, `Outcome`, `Acceptance Criteria`, `Assumptions`, `Constraints`, `Non Goals`, and `Status`. Optional sections may include `Open Questions`, `Research Required`, `Risks`, and `Dependencies`. Acceptance criteria must remain observable, testable, and unambiguous. Every assumption must be marked `confirmed`, `rejected`, or `unresolved`. Re-check approval readiness after revision.

## Embedded Command: commands/spec.md

Revise form: `harness spec spec:<id> revise <changes>`. Update the existing spec while preserving history. Resolve the referenced spec only from the artifact root `specs` directory. Stop after revising; do not create plans, tasks, code, QA, audits, completion reports, or invoke implementation.

## Embedded Agent: agents/spec-creator/AGENTS.md

Mission: create and revise lightweight, definitive specs with the user. Clarify the desired outcome, define acceptance criteria, constraints, non-goals, open questions, and research needs. Keep the revision concise, outcome-focused, and free of speculative architecture.

## Embedded Template: templates/spec.md

Preserve the spec structure: title, `Summary`, `Outcome`, `Acceptance Criteria`, `Constraints`, `Non Goals`, `Open Questions`, `Research Required`, `Risks`, `Dependencies`, and `Status`. Runtime specs are written under `tooling/agent-harness/specs/spec-<id>-<slug>.md`.

## Embedded Schema: schemas/spec.schema.md

Required fields: identifier, title, summary, outcome, acceptance criteria, assumptions, constraints, non-goals, and status. Acceptance criteria must be observable, testable, and unambiguous. Each assumption must be `confirmed`, `rejected`, or `unresolved`. A spec with unresolved material ambiguity is not approval-ready.

## Embedded State Rules: state/state-machine.md

Relevant transitions: `Draft -> Draft`, `Draft -> Approved`, `Draft -> Cancelled`, `Approved -> Draft`, `Approved -> In Progress`, `Approved -> Blocked`, and `Approved -> Cancelled`. Do not perform implementation transitions from this packet unless explicitly instructed by the correct workflow.

## Embedded Skill: skills/outcome-driven/SKILL.md

Use acceptance criteria as the primary success measure. Prefer behavior over architecture. Prefer evidence over confidence. Avoid work not required by the outcome. Stop when the requested spec revision is complete.

## Assigned Skills

* outcome-driven: keep the revision tied to observable outcomes, avoid speculative architecture, surface assumptions, and stop when the spec update is complete.
