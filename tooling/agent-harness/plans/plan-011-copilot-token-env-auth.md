# Implementation Plan plan:011: Copilot Token Environment Authentication

## Spec

spec:011

## Summary

Implement the approved Copilot token environment authentication behavior as one focused wrapper and documentation task. The task will add test coverage for `COPILOT_GITHUB_TOKEN` passthrough, update the Bash and Zsh wrappers to inject that environment variable only for Copilot, and document the host setup flow with an official GitHub source bibliography entry.

## Research Needed

* None

## Research References

* None

## Task Breakdown

* task:012 — Add Copilot token environment passthrough

## Task Dependencies

* None

## Parallelization Opportunities

* None

## Risks

* Token values must not be printed by tests or documentation.
* Copilot-specific environment passthrough must not affect Codex, Gemini, or Rovo behavior.

## Out of Scope

* Anything not included in spec:011

## Status

Complete
