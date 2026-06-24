# Implementation Plan plan:002: Relocate Harness Runtime Artifacts

## Spec

spec:002

## Summary

Update the canonical harness command guidance and templates so all runtime artifacts are created under `tooling/agent-harness/`, then rebuild tool-specific harness outputs and document the new artifact root plus manual migration path. Verify the generated harness no longer advertises root-level runtime artifact writes.

## Research Needed

* Identify every current harness workflow path that reads or writes runtime artifacts.

## Research References

* research:002

## Task Breakdown

* task:002 - Update harness artifact root guidance and verification

## Task Dependencies

* None

## Parallelization Opportunities

* None

## Risks

* The harness is instruction-driven, so verification must inspect generated command guidance rather than call a standalone harness executable.
* Existing root-level artifacts remain in place and are intentionally not migrated by this implementation.

## Out of Scope

* Anything not included in spec:002.
* Automatic migration or deletion of existing root-level artifact directories.

## Status

Complete
