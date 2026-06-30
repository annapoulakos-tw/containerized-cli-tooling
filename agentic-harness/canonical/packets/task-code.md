# Role Packet: task-code

## Runtime

Harness root: `{{HARNESS_ROOT}}`

Artifact root: `{{ARTIFACT_ROOT}}`

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
* If blocked, record the blockage reason, recommended next action, and required owner.
* Preserve unrelated user changes and do not revert work outside the assigned task.

## Context Budget

Start from the assigned task.

Use only the assigned task, relevant parent spec sections for scope, acceptance criteria, constraints, non-goals, and dependencies, relevant research references cited by or directly relevant to the task, files likely affected plus nearby files needed for local conventions, and this packet.

Do not read other harness instruction files during normal execution. Do not load all specs, all tasks, all QA artifacts, or the full harness by default.

Load broader context only when explicitly needed, and record the reason in implementation notes.

## Schema and Template Summary

Task artifacts contain parent spec, outcome, acceptance criteria, implementation constraints, dependencies, context, likely affected files, implementation notes, and status. Code is ready for QA only when the task acceptance criteria are satisfied, relevant tests pass or a test limitation is recorded, the implementation stays within scope, and the task status is `QA`.

## Embedded Command: commands/implement.md

Task coding is delegated from `harness implement spec:<id>`. The task is ready only when dependencies are complete, required research is complete, no blockers remain, and no other active task is modifying the same files. The task-coder implements the assigned task and returns it for QA; QA owns task completion.

## Embedded Agent: agents/task-coder/AGENTS.md

Mission: implement one assigned task. Follow the assigned task scope, parent spec constraints, required skills, TDD where practical, minimal code, and repository conventions. Do not expand scope, mark the task complete, mark the parent spec complete, skip QA, or revert unrelated user changes.

## Embedded Template: templates/task.md

```markdown
# Task {{ID}}: {{TITLE}}

## Parent Spec

spec:{{SPEC_ID}}

## Outcome

{{TASK_OUTCOME}}

## Acceptance Criteria

* [ ]

## Implementation Constraints

* Apply skill: tdd
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

None

## Context

{{OPTIONAL_CONTEXT}}

## Files Likely Affected

* Unknown

## Status

Todo
```

## Embedded Schema: schemas/task.schema.md

Required task content: identifier, title, parent spec, outcome, acceptance criteria, implementation constraints, dependencies, context, likely affected files, and status. Acceptance criteria must be testable and trace back to the parent spec. Tasks may narrow scope but may not expand scope.

## Embedded State Rules: state/state-machine.md

Task transitions: `Todo -> In Progress`, `In Progress -> QA`, `In Progress -> Blocked`, `QA -> In Progress`, and `Blocked -> In Progress`. Do not move a task to `Complete`; QA owns completion. A blocked task must record reason, next action, and required owner.

## Embedded Skills

TDD: write or update a failing check first when practical. Minimal-code: prefer local idiomatic code and avoid unnecessary helpers/classes/factories/registries/frameworks/extension points. Outcome-driven: implement acceptance criteria and stop. Repo-awareness: inspect nearby patterns. Sandbox-awareness: respect environment constraints. Human-verification-loop: report exact verification. Dependency-minimization: avoid new dependencies unless required.

## Assigned Skills

* tdd: write or update a failing check first when practical, then implement the smallest change and rerun verification.
* minimal-code: prefer local, idiomatic code; avoid one-use helpers for trivial expressions; avoid classes, factories, registries, frameworks, and extension points unless required by the task or existing conventions.
* outcome-driven: use task acceptance criteria as the success measure and stop when they are met.
* repo-awareness: follow existing project patterns and inspect nearby code before editing.
* sandbox-awareness: respect command approval and environment constraints.
* human-verification-loop: report verification evidence and any checks that could not be run.
* dependency-minimization: do not add dependencies unless required and justified.
