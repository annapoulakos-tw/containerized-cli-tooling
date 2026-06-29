# Implementation Plan plan:006: Coder and QA Context Budget Rules

## Spec

spec:006

## Summary

Add explicit focused-context budget rules to the `task-coder` and `qa-reviewer` workflow instructions and role packets, then verify those rules are present in canonical and generated harness output.

## Research Needed

* None

## Research References

* Existing `task-coder` and `qa-reviewer` agent definitions.
* Existing `task-code` and `qa-review` role packets.

## Task Breakdown

* task:006 - Add coder and QA context budget rules

## Task Dependencies

* spec:004 packet output support

## Parallelization Opportunities

* None

## Risks

* Rules that are too broad may not prevent large context loads.
* Rules that are too strict may prevent necessary local context when explicitly justified.

## Out of Scope

* Anything not included in spec:006

## Status

Complete
