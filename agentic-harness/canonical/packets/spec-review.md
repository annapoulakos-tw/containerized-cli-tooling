# Role Packet: spec-review

## Runtime

Harness root: `{{HARNESS_ROOT}}`

Artifact root: `{{ARTIFACT_ROOT}}`

## Command

`harness spec review spec:<id>` reviews an existing spec artifact.

## Agent

`spec-creator`

## Artifact Rules

* Read the target spec only from the artifact root `specs` directory.
* Reports open questions, missing acceptance criteria, schema issues, and approval readiness.
* Does not implement, create plans, create tasks, run QA, run audit, or create completion reports.
* Leaves status unchanged unless the user requested a valid state transition.
* Valid approval transition is `Draft` to `Approved`. Do not approve a spec with unresolved material assumptions or blocking open questions.

## Context Budget

Use the target spec and this packet. Do not read other harness instruction files during normal execution. Do not read unrelated specs, tasks, QA artifacts, or the full harness unless explicitly needed to resolve a referenced dependency.

## Schema and Template Summary

A valid spec has identifier and title in the heading, plus `Summary`, `Outcome`, `Acceptance Criteria`, `Assumptions`, `Constraints`, `Non Goals`, and `Status`. Valid statuses are `Draft`, `Approved`, `In Progress`, `QA`, `Complete`, `Blocked`, and `Cancelled`. Acceptance criteria must be observable, testable, and unambiguous. Every assumption must be marked `confirmed`, `rejected`, or `unresolved`. Approval readiness requires required fields, at least one acceptance criterion, explicit non-goals, no blocking open questions, and no unresolved material assumptions.

## Embedded Command: commands/spec.md

Review form: `harness spec review spec:<id>`. Display the current spec and identify open questions, missing acceptance criteria, schema violations, and approval readiness. Resolve the referenced spec only from the artifact root `specs` directory. Stop after review; do not create implementation plans, tasks, code, QA, audits, completion reports, or invoke implementation.

## Embedded Agent: agents/spec-creator/AGENTS.md

Mission: create and revise lightweight, definitive specs with the user. For review, verify the spec is outcome-oriented, bounded, testable, free of unnecessary implementation detail, explicit about non-goals, and approval-ready only when no material unresolved assumptions remain.

## Embedded Template: templates/spec.md

Expected sections: `Summary`, `Outcome`, `Acceptance Criteria`, `Constraints`, `Non Goals`, `Open Questions`, `Research Required`, `Risks`, `Dependencies`, and `Status`. Runtime specs are written under `tooling/agent-harness/specs/spec-<id>-<slug>.md`.

## Embedded Schema: schemas/spec.schema.md

A valid spec must contain identifier, title, summary, outcome, acceptance criteria, assumptions, constraints, non-goals, and status. Optional fields are context, open questions, research required, risks, and dependencies. Acceptance criteria must be observable, testable, and unambiguous. Assumptions must be marked `confirmed`, `rejected`, or `unresolved`.

## Embedded State Rules: state/state-machine.md

Relevant review transitions: leave status unchanged unless the user requested a valid transition. `Draft -> Approved` is valid only when approval criteria pass. `Draft -> Cancelled` is valid when explicitly requested. Complete and Cancelled are terminal.

## Embedded Skill: skills/outcome-driven/SKILL.md

Use acceptance criteria as the primary success measure. Prefer behavior over architecture. Prefer evidence over confidence. Avoid work not required by the outcome. Stop when the review result is delivered.

## Assigned Skills

* outcome-driven: review against observable outcomes and approval readiness, prefer evidence over confidence, and avoid recommending work outside the spec command boundary.
