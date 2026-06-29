# Role Packet: task-code

## Command

Delegated task coding workflow from `harness implement spec:<id>`.

## Agent

`task-coder`

## Artifact Rules

* The assigned task is the immediate source of truth; the parent spec is the higher authority.
* Implement only the assigned task outcome and acceptance criteria.
* Move task status from `In Progress` to `QA` when implementation and relevant tests are ready.
* Do not mark the task `Complete`; QA owns completion.
* Do not mark the parent spec complete.

## Context Budget

Start from the assigned task.

Load only the assigned task, relevant parent spec sections for scope, acceptance criteria, constraints, non-goals, and dependencies, relevant research references cited by or directly relevant to the task, files likely affected plus nearby files needed for local conventions, this assigned role packet, and required skills.

Do not load all specs, all tasks, all QA artifacts, all schemas, or the full harness by default.

Load broader context only when explicitly needed, and record the reason in implementation notes.

## Schema and Template Summary

Use the task artifact for parent spec, outcome, acceptance criteria, implementation constraints, dependencies, context, likely affected files, and status. Use relevant spec sections for acceptance criteria, constraints, non-goals, risks, and dependencies.

## Assigned Skills

* tdd
* minimal-code
* outcome-driven
* repo-awareness
* sandbox-awareness
* human-verification-loop
* dependency-minimization
