# Audit audit:005: Copilot Bootstrap and Tool Profile

## Scope

spec:005

## Result

PASS

## Findings

* No blocking findings.
* The implementation satisfies the approved spec outcome: the Copilot build has a stable bootstrap anchor and the canonical harness documents Copilot-specific prompt constraints.
* The bootstrap hard-codes the required harness root and artifact root.
* The bootstrap explicitly tells Copilot not to search `/workspace` for harness files and to use `packets/` for workflow-specific instructions.
* The canonical Copilot tool profile documents smaller prompts, repeated harness-root anchors, explicit artifact-root rules, and one role packet per workflow.
* Existing `AGENTS.md` output is preserved.
* Non-goals were respected: no role packet redesign, runtime artifact root change, non-Copilot bootstrap addition, authentication change, container setup change, or shell wrapper behavior change occurred.

## Evidence

* qa:011 passed task QA.
* qa:012 passed full-spec QA.
* `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh` passed.
* `bash /workspace/agentic-harness/tests/build-packets.sh` passed.
* Audit reviewed `build.sh`, `canonical/bootstrap/copilot.md`, `canonical/tool-profiles/copilot.md`, `canonical/build-strategy.md`, and generated Copilot build output.

## Status

Complete
