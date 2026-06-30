# Implementation Plan plan:009: Bootstrap Entrypoint Generation

## Spec

spec:009

## Summary

Implement the approved bootstrap entrypoint generation by updating the harness build flow and focused shell verification for the `codex` and `copilot` targets only.

## Research Needed

* None

## Research References

* None

## Task Breakdown

* task:010 — Generate bootstrap entrypoints for codex and copilot

## Task Dependencies

* None

## Parallelization Opportunities

* None

## Risks

* Replacing generated aggregate `AGENTS.md` for `codex` or `copilot` may break any workflow still relying on that file containing all harness instructions.

## Out of Scope

* Anything not included in spec:009
* `gemini` and `rovo` bootstrap entrypoint generation
* Container injection mechanics

## Status

Complete
