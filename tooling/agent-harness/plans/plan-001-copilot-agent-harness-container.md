# Implementation Plan plan:001: Copilot Agent Harness Container Support

## Spec

spec:001

## Summary

Implement and verify Copilot harness support through the existing harness build script, shell wrappers, and documentation. The work is small enough for one task because it touches one user-facing path: preparing the generated tool-specific harness and mounting it into the Copilot container without changing project-owned instruction files.

## Research Needed

* None

## Research References

* None

## Task Breakdown

* task:001 - Build, mount, and document Copilot harness support

## Task Dependencies

* None

## Parallelization Opportunities

* None

## Risks

* Existing Rovo and Makefile worktree changes are accepted external context and are outside this spec's Copilot harness delta.
* Full Docker runtime verification may not be available in this environment.

## Out of Scope

* Anything not included in spec:001.
* The non-goals listed in spec:001.

## Status

Complete
