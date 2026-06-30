# Audit audit:spec:010: Root README Harness Configuration

## Scope

spec:010

## Result

PASS

## Findings

* No blocking findings.
* The implementation satisfies the approved documentation-only scope.
* The root README Agent Harness section now uses the current single generated-entrypoint prompt.
* The obsolete manual harness-root and acknowledgement prompt lines were removed.
* `{TOOL}` guidance for `codex` and `copilot` remains present.
* Wrapper refresh and stable mount path documentation remains present.
* Harness runtime behavior, generated bootstrap files, and wrapper mount paths were not changed.

## Evidence

* task:011 completed.
* qa:task:011 passed task QA.
* Root `README.md` diff is limited to the Agent Harness prompt wording and prompt block.
* Targeted grep verification returned only the expected `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md.` prompt line from the old three-line block.

## Status

Complete
