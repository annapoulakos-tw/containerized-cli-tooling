# Role Packet: implement-orchestrate

## Command

`harness implement spec:<id>` executes an approved spec.

## Agent

`spec-implementer`

## Artifact Rules

* Load the spec only from `tooling/agent-harness/specs/`.
* The spec must be `Approved` before implementation starts.
* Create or update implementation plans, research requests, task artifacts, completion reports, and spec status according to the state machine.
* Do not expand scope, modify acceptance criteria, or approve your own coding, QA, or audit work.
* A spec reaches `Complete` only after all tasks complete, full-spec QA passes, and audit passes.

## Context Budget

Load the target spec, this packet, `commands/implement.md`, `agents/spec-implementer/AGENTS.md`, `state/state-machine.md`, relevant plan/task/research templates and schemas, and required skills. Do not load all specs, all tasks, all QA artifacts, or the full harness unless explicitly needed.

## Schema and Template Summary

Use the implementation plan template for research needs, task breakdown, dependencies, parallelization, risks, and out-of-scope items. Use the task template for parent spec, outcome, acceptance criteria, constraints, dependencies, context, likely affected files, and status.

## Assigned Skills

* outcome-driven
* repo-awareness
* sandbox-awareness
* dependency-minimization
