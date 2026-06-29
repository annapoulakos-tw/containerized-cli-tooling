# QA qa:012: Spec 005 Copilot Bootstrap and Tool Profile

## Scope

spec:005

## Result

PASS

## Evidence Reviewed

* task:005 implementation notes and status.
* qa:011 task QA result.
* Copilot bootstrap generated from canonical source.
* Canonical Copilot tool profile content.
* Build output for Copilot and non-Copilot tools.

## Verification

* `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh` passed.
* `bash /workspace/agentic-harness/tests/build-packets.sh` passed.
* The Copilot bootstrap contains `/home/copilot/.copilot/agent-harness`.
* The Copilot bootstrap contains `/workspace/tooling/agent-harness`.
* The Copilot bootstrap tells Copilot not to search `/workspace` for harness files.
* The Copilot bootstrap tells Copilot to use `packets/` for workflow-specific instructions.

## Findings

* None

## Required Fixes

* None

## Status

Complete
