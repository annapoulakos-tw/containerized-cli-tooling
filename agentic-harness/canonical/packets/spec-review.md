# Role Packet: spec-review

## Command

`harness spec review spec:<id>` reviews an existing spec artifact.

## Agent

`spec-creator`

## Artifact Rules

* Reads the target spec from `tooling/agent-harness/specs/`.
* Reports open questions, missing acceptance criteria, schema issues, and approval readiness.
* Does not implement, create plans, create tasks, run QA, run audit, or create completion reports.
* Leaves status unchanged unless the user requested a valid state transition.

## Context Budget

Load the target spec, this packet, `commands/spec.md`, `schemas/spec.schema.md`, `state/state-machine.md`, and required skills. Do not load unrelated specs, tasks, QA artifacts, templates, agents, or the full harness unless explicitly needed.

## Schema and Template Summary

Validate the spec schema: required identifier/title, summary, outcome, acceptance criteria, assumptions, constraints, non-goals, and valid status. Check that acceptance criteria are observable, testable, and unambiguous.

## Assigned Skills

* outcome-driven
