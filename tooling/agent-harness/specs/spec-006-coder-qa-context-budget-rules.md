# Spec spec:006: Coder and QA Context Budget Rules

## Summary

Add context budget rules for `task-coder` and `qa-reviewer` workflows so they load only the focused context needed for their assigned work. This keeps larger specs manageable by preventing coder and QA roles from loading broad harness history, unrelated artifacts, or full canonical definitions unless explicitly required.

## Outcome

When `task-coder` or `qa-reviewer` workflows run, their instructions constrain context loading to the assigned task or QA target, relevant parent spec sections, relevant research references, likely affected files, the assigned role packet, and required skills. They avoid loading all specs, tasks, QA artifacts, schemas, or the full harness by default.

## Acceptance Criteria

* `task-coder` workflow instructions define a context budget rule that starts from the assigned task.
* `qa-reviewer` workflow instructions define a context budget rule that starts from the assigned QA target.
* `task-coder` and `qa-reviewer` load only relevant parent spec sections needed to evaluate scope, acceptance criteria, constraints, non-goals, and dependencies.
* `task-coder` and `qa-reviewer` load only research references that are cited by, assigned to, or directly relevant to the assigned task or QA target.
* `task-coder` and `qa-reviewer` load only files likely affected by the assigned task or QA target, plus nearby files needed to understand local conventions.
* `task-coder` and `qa-reviewer` load the assigned role packet for their workflow.
* `task-coder` and `qa-reviewer` load only required skills assigned to their workflow or task context.
* `task-coder` and `qa-reviewer` do not load all specs by default.
* `task-coder` and `qa-reviewer` do not load all tasks by default.
* `task-coder` and `qa-reviewer` do not load all QA artifacts by default.
* `task-coder` and `qa-reviewer` do not load all schemas by default.
* `task-coder` and `qa-reviewer` do not load the full harness by default.
* The rules allow loading broader context only when explicitly needed, with the reason recorded in the workflow output or review notes.
* Existing `spec-implementer` behavior remains unchanged unless it directly assigns focused context to coder or QA workflows.
* Verification covers both coder and QA workflow instructions and confirms the forbidden broad-loading defaults are absent.

## Assumptions

* confirmed: The `spec-implementer` workflow currently works well and should not be the focus of this change.
* confirmed: `task-coder` and `qa-reviewer` can become overwhelmed on larger specs.
* confirmed: Focused context should include the assigned task or QA target, relevant parent spec sections, relevant research references, files likely affected, assigned role packet, and required skills.
* confirmed: Broad context should be opt-in only when explicitly needed.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Keep the rules focused on `task-coder` and `qa-reviewer`.
* Do not weaken artifact lifecycle, completion, QA, or audit requirements.
* Do not require loading the full harness to understand routine coder or QA workflow instructions.
* Keep generated packet behavior compatible with these context budget rules.

## Non Goals

* Do not redesign the `spec-implementer` workflow.
* Do not change spec, task, QA, or research schemas except where required to express context budget rules.
* Do not remove existing generated `AGENTS.md` output.
* Do not change runtime artifact locations.
* Do not implement this spec as part of spec creation.

## Open Questions

* None

## Research Required

* Identify where `task-coder` and `qa-reviewer` workflow instructions and role packets define context-loading behavior.

## Risks

* Rules that are too strict may hide context needed to catch cross-task regressions.
* Rules that are too vague may not prevent broad context loading on large specs.

## Dependencies

* Existing `task-coder` and `qa-reviewer` agent definitions.
* Existing role packet generation or planned packet generation from spec:004.
* Existing artifact root and workflow conventions.

## Status

Complete
