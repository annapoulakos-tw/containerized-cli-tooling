# Task task:008: Generate Self-Contained Role Packets

## Parent Spec

spec:008

## Outcome

Generated role packets for every supported tool include tool-specific roots and enough inline workflow instructions for normal delegated-agent execution without chained reads of other harness instruction files.

## Acceptance Criteria

* `build.sh` renders packet files per supported tool instead of copying canonical packets verbatim when tool-specific roots are required.
* Each generated packet includes the tool-specific harness root.
* Each generated packet includes the runtime artifact root for specs, plans, tasks, research, QA, audits, and completion reports.
* Packet context instructions do not require normal-execution reads of command, agent, schema, template, skill, or state files.
* Packets inline the relevant artifact format, lifecycle, completion, blocking, and skill guidance needed for their workflow.
* Packet verification covers `codex`, `copilot`, `gemini`, and `rovo`.
* Existing generated `AGENTS.md`, copied support directories, and copied skill files remain generated.

## Implementation Constraints

* Apply skill: tdd
* Apply skill: shell-style
* Prefer minimal code
* Preserve existing behavior
* Stay within task scope

## Dependencies

* research:003

## Context

Parent spec: spec:008. Prior packet generation was added by spec:004 and currently copies `agentic-harness/canonical/packets/*.md` into each build.

## Files Likely Affected

* `/workspace/agentic-harness/build.sh`
* `/workspace/agentic-harness/canonical/packets/*.md`
* `/workspace/agentic-harness/tests/build-packets.sh`
* `/workspace/agentic-harness/tests/context-budget-rules.sh`

## Implementation Notes

* Updated `build.sh` to render canonical packets per tool and replace `{{HARNESS_ROOT}}` and `{{ARTIFACT_ROOT}}` placeholders.
* Added tool harness root rendering for `codex`, `copilot`, `gemini`, and `rovo`; Rovo uses `/home/rovo/.rovodev/agent-harness`.
* Rewrote canonical packet context budgets so normal execution uses the assigned packet and relevant artifacts/workspace files rather than chained reads of other harness instruction files.
* Inlined relevant artifact fields, lifecycle rules, completion/blocking rules, and assigned skill guidance into packet content.
* Strengthened `build-packets.sh` to verify roots and reject packet references to harness instruction path families.
* Updated `context-budget-rules.sh` so full agent files and self-contained packet files have separate expectations.
* Verification:
  * `bash /workspace/agentic-harness/tests/build-packets.sh`
  * `bash /workspace/agentic-harness/tests/context-budget-rules.sh`
  * `bash /workspace/agentic-harness/tests/anti-overengineering-guidance.sh`
  * `bash /workspace/agentic-harness/tests/build-copilot-bootstrap.sh`
  * `bash /workspace/tests/agent-harness-artifact-root-smoke.sh`
  * `bash /workspace/tests/ai-cli-harness-smoke.sh`

## Status

Complete
