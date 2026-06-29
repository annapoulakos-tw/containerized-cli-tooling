# QA qa:009: Task 004 Compiled Role Packets

## Scope

task:004 for spec:004

## Result

PASS

## Evidence Reviewed

* `spec:004` and `task:004` require additive generated role packets without removing `AGENTS.md`.
* `build.sh` still generates `build/<tool>/AGENTS.md`, copies skills and support directories, and now copies canonical packets into `build/<tool>/packets/`.
* Canonical packet source files exist under `/workspace/agentic-harness/canonical/packets/`.
* Generated packet outputs exist for `codex`, `copilot`, `gemini`, and `rovo`.
* Each generated packet has the required sections: command, agent, artifact rules, context budget, schema/template summary, and assigned skills.
* Each tool build still has `AGENTS.md`, `commands`, `schemas`, `templates`, `state`, and `skills`.

## Verification

* `bash /workspace/agentic-harness/tests/build-packets.sh` passed.
* `diff -qr canonical/packets build/<tool>/packets` passed for all four supported tools.
* Each generated `build/<tool>/packets/` directory contains exactly seven markdown files.

## Findings

* None

## Required Fixes

* None

## Status

Complete
