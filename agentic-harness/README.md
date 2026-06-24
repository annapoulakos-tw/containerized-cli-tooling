# AI Agent Harness Strategy

## Purpose

This harness provides a lightweight, tool-agnostic structure for using AI CLI coding tools in a controlled, repeatable way.

The harness separates durable workflow definitions from any specific AI tool. Codex, Copilot, or another CLI may execute the work, but the harness owns the roles, skills, commands, artifacts, and completion rules.

## Core Idea

The system is organized around specs.

A user describes an intended outcome. The harness turns that outcome into a lightweight but definitive spec. The spec is then implemented through small tasks, reviewed by QA, and closed only when the original acceptance criteria are satisfied.

The spec is the contract. Agents may plan, research, code, and review, but they should not expand or reinterpret the spec without explicit approval.

## Agents

### spec-creator

Works with the user to turn an idea into a clear, bounded spec.

Its job is to define the desired outcome, scope, non-goals, acceptance criteria, constraints, and open questions.

### spec-implementer

Owns execution of an approved spec.

It reads the spec, identifies unknowns, requests research when needed, breaks the work into small tasks, delegates tasks to coders, requests QA review, tracks progress, and marks the spec done only when the acceptance criteria are satisfied.

### spec-researcher

Answers open questions on an ad-hoc basis.

It investigates documentation, APIs, libraries, prior art, implementation risks, and technical tradeoffs. It produces research notes and recommendations, but does not modify code.

### task-coder

Implements one bounded task at a time.

It follows TDD, writes the smallest clear code needed to satisfy the task, avoids speculative abstractions, preserves existing behavior, and stops when the task outcome is achieved.

### qa-reviewer

Verifies completed work.

It checks task results and full-spec completion against acceptance criteria, tests, regressions, scope control, and implementation quality. It may return pass, fail, or pass with concerns.

### spec-auditor

Checks alignment between user intent, the spec, implementation, and QA result.

Its purpose is to prevent drift where the implementation satisfies a reinterpreted version of the original request rather than the actual spec.

## Skills

### tdd

Guides agents to prefer test-first implementation, small testable slices, and verification through executable tests.

### minimal-code

Guides agents to prefer the smallest clear change that satisfies the desired behavior.

### outcome-driven

Keeps agents focused on externally visible outcomes and acceptance criteria instead of unnecessary internal complexity.

### repo-awareness

Guides agents to understand existing project structure, conventions, test commands, and patterns before making changes.

### git-safety

Guides agents to avoid destructive changes, preserve user work, inspect diffs, and keep changes reviewable.

### dependency-minimization

Guides agents to avoid new dependencies unless they are clearly justified by the spec.

### debugging

Guides agents through systematic failure investigation, reproduction, hypothesis testing, and minimal fixes.

### refactoring

Guides agents to improve structure only when it directly supports the spec, reduces real complexity, or removes duplication introduced by the work.

## Commands

### /spec

Creates or revises a spec with the user.

### /implement

Runs the spec-implementor against an approved spec.

### /research

Runs focused research for an open question.

### /code

Runs a task-coder against a specific task.

### /qa

Runs QA review against a task or complete spec.

### /audit

Checks alignment between the original request, spec, implementation, and final result.

## Design Principles

The harness should remain lightweight.

Markdown files are preferred over databases. Shell scripts are preferred over services. Tool-specific configuration is generated from canonical harness definitions rather than authored by hand.

Agents are roles. Skills are reusable behaviors. Commands are entry points. Specs and tasks are artifacts. Acceptance criteria are the source of truth.

The system should optimize for small changes, strong verification, low ceremony, and clear stopping conditions.

## Runtime Artifacts

Harness runtime artifacts live under `tooling/agent-harness/`:

```text
tooling/agent-harness/specs/
tooling/agent-harness/plans/
tooling/agent-harness/tasks/
tooling/agent-harness/research/
tooling/agent-harness/qa/
tooling/agent-harness/audits/
tooling/agent-harness/completion/
```

New `/spec`, `/implement`, `/qa`, and `/audit` workflow artifacts should be written under this root. If a referenced spec is not present under `tooling/agent-harness/specs/`, the workflow should stop with a clear not-found error and should not fall back to a root-level `specs/` directory.

Existing root-level artifact directories such as `specs/`, `plans/`, `tasks/`, `research/`, `qa/`, `audits/`, and `completion/` are not moved or deleted automatically. To migrate manually, copy the files you still need into the matching directory under `tooling/agent-harness/`, confirm the harness can read and update them there, then remove the old root-level directories yourself when they are no longer needed.

## Philosophy

The harness optimizes for:

- Small changes
- Explicit artifacts
- Repeatable workflows
- Verification over confidence
- Outcomes over implementation details

The harness does not optimize for:

- Autonomous behavior
- Creative interpretation
- Large refactors
- Framework generation
- Speculation beyond the current task


### Notes

```
Read /home/codex/.codex/agent-harness/AGENTS.md.
Use /home/codex/.codex/agent-harness as the harness root.
Acknowledge loaded and wait.
```
