# Role Packet: audit-review

## Command

Delegated audit workflow from `harness implement spec:<id>`.

## Agent

`spec-auditor`

## Artifact Rules

* Review the completed implementation against the approved spec.
* Create or update audit results under `tooling/agent-harness/audits/`.
* Return `PASS`, `FAIL`, or `PASS WITH CONCERNS`.
* Verify QA evidence exists before recommending completion.
* Do not implement code, perform QA testing, rewrite specs, change acceptance criteria, or expand scope.

## Context Budget

Load the approved spec, implementation plan, completed task summaries, QA evidence, completion report if present, this packet, and required skills. Do not load unrelated specs, unrelated tasks, all QA artifacts, or the full harness unless explicitly needed.

## Schema and Template Summary

Use the audit template to record scope, result, findings, evidence, and status. Verify outcome, every acceptance criterion, constraints, non-goals, QA evidence, and task completion support.

## Assigned Skills

* outcome-driven
* repo-awareness
