# Role Packet: spec-update

## Command

`harness spec spec:<id> revise <changes>` updates an existing spec artifact.

## Agent

`spec-creator`

## Artifact Rules

* Updates the target spec under `tooling/agent-harness/specs/`.
* Preserve the spec as the source of truth and do not expand scope without user approval.
* Keep unresolved material questions visible in `Open Questions` and keep the spec in `Draft` when those questions block approval.
* Stop after updating the spec; do not create plans, tasks, code, QA, audit, or completion reports.

## Context Budget

Load the target spec, the requested revision, this packet, `commands/spec.md`, `schemas/spec.schema.md`, `templates/spec.md`, and required skills. Do not load unrelated specs, tasks, QA artifacts, agents, or the full harness unless explicitly needed.

## Schema and Template Summary

Maintain the spec schema. Required content remains identifier, title, summary, outcome, acceptance criteria, assumptions, constraints, non-goals, and status. Re-check approval readiness after revision.

## Assigned Skills

* outcome-driven
