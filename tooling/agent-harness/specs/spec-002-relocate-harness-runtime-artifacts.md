# Spec spec:002: Relocate Harness Runtime Artifacts

## Summary

Change the harness so runtime artifacts are written under `tooling/agent-harness/` instead of directly under the repository root. This keeps harness-generated specs, plans, tasks, research, QA, audits, and completion reports grouped under a dedicated tooling-owned directory without reorganizing existing project files.

## Outcome

When users run harness workflows, newly created or updated runtime artifacts are consistently written under `tooling/agent-harness/`, while existing repository-root files and existing root-level harness artifact directories are left untouched unless a user explicitly requests migration or cleanup.

## Acceptance Criteria

* Given a new spec is created, the spec artifact is written under `tooling/agent-harness/specs/`.
* Given an approved spec is implemented, implementation plans are written under `tooling/agent-harness/plans/`.
* Given implementation tasks are created or updated, task artifacts are written under `tooling/agent-harness/tasks/`.
* Given research is requested or completed, research artifacts are written under `tooling/agent-harness/research/`.
* Given QA reviews are created or updated, QA artifacts are written under `tooling/agent-harness/qa/`.
* Given audit reviews are created or updated, audit artifacts are written under `tooling/agent-harness/audits/`.
* Given completion reports are created, completion artifacts are written under `tooling/agent-harness/completion/`.
* The `/spec`, `/implement`, `/qa`, and `/audit` workflows use the same artifact root consistently.
* Existing project files in the repository root are not overwritten, moved, deleted, or reorganized by this change.
* If root-level harness artifact directories such as `specs/`, `plans/`, `tasks/`, `research/`, `qa/`, `audits/`, or `completion/` already exist, the harness does not move or delete them automatically.
* Documentation explains the new artifact root and gives a manual migration or cleanup path for existing root-level harness artifact directories.
* Verification demonstrates that new artifacts are created under `tooling/agent-harness/` and not under root-level harness artifact directories.
* Given a referenced spec does not exist under `tooling/agent-harness/specs/`, the workflow stops with a clear not-found error and does not fall back to root-level `specs/`.

## Assumptions

* confirmed: The desired runtime artifact root is `tooling/agent-harness/`.
* confirmed: Existing root-level harness artifact directories must not be moved or deleted automatically.
* confirmed: The affected workflows are `/spec`, `/implement`, `/qa`, and `/audit`.
* confirmed: Existing root-level harness artifacts do not need automatic legacy fallback reads for this first real test.
* confirmed: The user will manually move legacy tooling output into the new folders after this work is complete.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Do not overwrite, move, delete, or reorganize existing project root files.
* Do not automatically migrate existing root-level harness artifacts.
* Keep runtime artifact paths relative to the repository workspace.
* Document manual migration or cleanup instead of performing it automatically.

## Non Goals

* Do not redesign the harness state machine, schemas, artifact contents, or lifecycle rules.
* Do not migrate existing root-level harness artifacts automatically.
* Do not delete existing root-level harness artifact directories.
* Do not change generated tool-specific harness build output paths.
* Do not change unrelated container, wrapper, or authentication behavior.

## Open Questions

* None

## Research Required

* Identify every current harness workflow path that reads or writes runtime artifacts.

## Risks

* Existing in-progress harness work will require the user's planned manual migration after this work is complete.
* Documentation must be explicit so users do not assume existing root-level artifacts were migrated automatically.

## Dependencies

* Existing harness command definitions and workflow implementation.
* Existing repository documentation for harness usage.

## Status

Complete
