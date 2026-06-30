# Role Packet: audit-review

## Runtime

Harness root: `{{HARNESS_ROOT}}`

Artifact root: `{{ARTIFACT_ROOT}}`

## Command

Delegated audit workflow from `harness implement spec:<id>`.

## Agent

`spec-auditor`

## Artifact Rules

* Review the completed implementation against the approved spec.
* Create or update audit results under the artifact root `audits` directory.
* Return `PASS`, `FAIL`, or `PASS WITH CONCERNS`.
* Verify QA evidence exists before recommending completion.
* Do not implement code, perform QA testing, rewrite specs, change acceptance criteria, or expand scope.
* A spec may be marked `Complete` only when all tasks are `Complete`, full-spec QA passes, audit passes, acceptance criteria are satisfied, and a completion report records verification.

## Context Budget

Use the approved spec, implementation plan, completed task summaries, QA evidence, completion report if present, and this packet. Do not read other harness instruction files during normal execution. Do not load unrelated specs, unrelated tasks, all QA artifacts, or the full harness unless explicitly needed.

## Schema and Template Summary

Audit artifacts record scope, result, findings, evidence, required fixes if any, and status. Verify the implementation satisfies the original spec outcome and every acceptance criterion, did not expand scope, respected constraints and non-goals, has completed tasks, and has QA evidence.

## Embedded Command: commands/implement.md

Audit is delegated from `harness implement spec:<id>` after tasks are complete and full-spec QA has passed. Audit verifies final alignment with the original approved spec before completion. Audit may not replace QA and may not implement fixes.

## Embedded Agent: agents/spec-auditor/AGENTS.md

Mission: perform final alignment review. Verify the implementation satisfies the approved spec, did not expand scope, meets acceptance criteria, respects constraints and non-goals, and has QA evidence. Do not implement code, perform QA testing, rewrite specs, or change acceptance criteria.

## Embedded Template: templates/audit.md

```markdown
# Audit {{ID}}: {{TITLE}}

Artifact path: `tooling/agent-harness/audits/audit-{{ID}}-{{SLUG}}.md`

## Scope

{{SPEC_OR_TASK_UNDER_AUDIT}}

## Result

PASS | FAIL | PASS WITH CONCERNS

## Findings

* None

## Evidence

{{VERIFICATION_EVIDENCE}}

## Status

Complete
```

## Embedded Audit Schema

An audit must identify scope, result, findings, evidence, required fixes if any, and status. Result values are `PASS`, `FAIL`, or `PASS WITH CONCERNS`. Passing audit requires completed tasks, full-spec QA evidence, satisfied acceptance criteria, respected constraints, and respected non-goals.

## Embedded State Rules: state/state-machine.md

Spec completion transition: `QA -> Complete` only after all tasks are complete, acceptance criteria are satisfied, QA review passes, and auditor review passes. `Complete` is terminal. If audit fails, return `QA -> In Progress` or block with reason, next action, and owner.

## Embedded Skills

Outcome-driven: audit against the approved spec and observable evidence. Repo-awareness: inspect only the implementation and artifact context needed to confirm alignment.

## Assigned Skills

* outcome-driven: audit against the approved spec and observable evidence.
* repo-awareness: inspect only the implementation and artifact context needed to confirm alignment.
