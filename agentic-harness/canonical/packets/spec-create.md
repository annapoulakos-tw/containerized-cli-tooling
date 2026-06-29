# Role Packet: spec-create

## Command

`harness spec <description>` creates a new spec artifact.

## Agent

`spec-creator`

## Artifact Rules

* Creates `spec:<id>` under `tooling/agent-harness/specs/`.
* New specs start in `Draft`.
* A spec may move to `Approved` only after explicit user approval.
* Stop after creating or updating the spec; do not create plans, tasks, code, QA, audit, or completion reports.

## Context Budget

Load the user request, this packet, `commands/spec.md`, `agents/spec-creator/AGENTS.md`, `schemas/spec.schema.md`, `templates/spec.md`, and required skills. Do not load all specs, tasks, QA artifacts, schemas, templates, agents, or the full harness unless explicitly needed.

## Schema and Template Summary

Use the spec template and schema. Required content: identifier, title, summary, outcome, acceptance criteria, assumptions, constraints, non-goals, and status. Optional sections may include context, open questions, research required, risks, and dependencies.

## Assigned Skills

* outcome-driven
