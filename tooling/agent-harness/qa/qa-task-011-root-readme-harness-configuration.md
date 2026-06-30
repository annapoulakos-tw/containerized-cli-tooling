# QA qa:task:011: Root README Harness Configuration

## Scope

task:011

## Result

PASS

## Evidence Reviewed

* Root `README.md` Agent Harness section now uses the single generated-entrypoint prompt.
* The old `Use /home/{TOOL}/.{TOOL}/agent-harness as the harness root.` prompt line is absent.
* The old `Acknowledge loaded and wait.` prompt line is absent.
* `{TOOL}` guidance for `codex` and `copilot` remains present.
* Wrapper refresh and stable mount path documentation remains present.

## Acceptance Criteria Review

* The root `README.md` Agent Harness section contains instructions for configuring the harness: PASS.
* The existing three-line harness prompt is replaced with `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md`: PASS.
* `{TOOL}` guidance for `codex` and `copilot` remains present: PASS.
* The wrapper refresh and mount explanation remains present: PASS.
* Non-harness README content remains unchanged: PASS.

## Verification

* `sed -n '112,145p' README.md` confirmed the updated Agent Harness section.
* `git diff -- README.md tooling/agent-harness/plans/plan-010-root-readme-harness-configuration.md tooling/agent-harness/tasks/task-011-root-readme-harness-configuration.md` confirmed the README change is scoped to the Agent Harness prompt.
* `grep -n "Use /home/{TOOL}/.{TOOL}/agent-harness as the harness root\|Acknowledge loaded and wait\|Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md" README.md` returned only the expected `Read .../AGENTS.md` prompt line.

## Findings

* None

## Required Fixes

* None

## Status

Complete
