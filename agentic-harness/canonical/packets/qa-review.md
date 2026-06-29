# Role Packet: qa-review

## Command

Delegated QA workflow from `harness implement spec:<id>`.

## Agent

`qa-reviewer`

## Artifact Rules

* Review the assigned task or full-spec QA target.
* Create or update QA review artifacts under `tooling/agent-harness/qa/`.
* Return `PASS`, `FAIL`, or `PASS WITH CONCERNS`.
* A task may be marked `Complete` only after QA passes.
* Flag technically correct implementations that are unnecessarily large, abstract, or structured beyond the approved spec.
* Do not implement code, change acceptance criteria, expand scope, or mark the parent spec complete.

## Context Budget

Start from the assigned QA target.

Load only the assigned QA target, relevant parent spec sections for scope, acceptance criteria, constraints, non-goals, and dependencies, implementation notes or files likely affected plus nearby files needed for local conventions, relevant test results, relevant research references cited by or directly relevant to the QA target, this assigned role packet, and required skills.

Do not load all specs, all tasks, all QA artifacts, all schemas, or the full harness by default.

Load broader context only when explicitly needed, and record the reason in review notes.

## Schema and Template Summary

Use QA review output to record outcome, evidence reviewed, passing criteria, failing criteria, concerns, and required fixes. Use the task or spec acceptance criteria and constraints as the review standard.

## Assigned Skills

* outcome-driven
* repo-awareness
* sandbox-awareness
* human-verification-loop
