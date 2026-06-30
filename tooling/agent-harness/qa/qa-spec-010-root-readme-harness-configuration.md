# QA qa:spec:010: Root README Harness Configuration

## Scope

spec:010

## Result

PASS

## Evidence Reviewed

* `tooling/agent-harness/specs/spec-010-root-readme-harness-configuration.md`
* Root `README.md` Agent Harness section containing the existing three-line prompt.
* Review packet `agentic-harness/canonical/packets/review spec.md`.

## Required Sections Review

* Summary: PASS.
* Outcome: PASS.
* Acceptance Criteria: PASS.
* Assumptions: PASS.
* Constraints: PASS.
* Non Goals: PASS.
* Status: PASS.

## Acceptance Criteria Review

* Criteria are observable against the root `README.md`: PASS.
* Criteria identify the existing three-line prompt and replacement prompt: PASS.
* Criteria preserve supported `{TOOL}` guidance for `codex` and `copilot`: PASS.
* Criteria preserve existing wrapper build and mount explanation: PASS.
* Criteria constrain scope to documentation and avoid generated bootstrap duplication: PASS.

## Ambiguity Review

* The spec classifies the only material inference, that "above prompt" means `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md`, as an assumption.
* No unresolved ambiguity materially changes acceptance criteria, produced artifacts, public interfaces, file formats, data structures, or user-visible behavior.

## Approval Readiness

The spec is approval-ready. It is concise, bounded to the root README documentation update, and has testable acceptance criteria.

## Findings

* None.

## Required Fixes

* None.

## Status

Complete
