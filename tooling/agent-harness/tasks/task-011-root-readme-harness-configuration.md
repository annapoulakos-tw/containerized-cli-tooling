# Task task:011: Update Root README Agent Harness Prompt

## Parent Spec

spec:010

## Outcome

The root `README.md` Agent Harness section instructs users to load the generated harness entrypoint with the current single prompt.

## Acceptance Criteria

* The root `README.md` Agent Harness section contains instructions for configuring the harness.
* The existing three-line harness prompt is replaced with `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md`.
* `{TOOL}` guidance for `codex` and `copilot` remains present.
* The wrapper refresh and mount explanation remains present.
* Non-harness README content remains unchanged.

## Implementation Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Stay within task scope.

## Dependencies

None

## Context

The root README currently shows a three-line prompt that manually tells the agent the harness root and acknowledgement behavior. The generated `AGENTS.md` entrypoint now contains the needed bootstrap instructions.

## Files Likely Affected

* `/workspace/README.md`

## Implementation Notes

* Updated the root `README.md` Agent Harness section prompt from the old three-line snippet to the current single generated-entrypoint prompt.
* Preserved `{TOOL}` guidance for `codex` and `copilot`.
* Preserved the wrapper refresh and stable mount path explanation.
* Verification:
  * `sed -n '112,145p' README.md`
  * `git diff -- README.md tooling/agent-harness/plans/plan-010-root-readme-harness-configuration.md tooling/agent-harness/tasks/task-011-root-readme-harness-configuration.md`
  * `grep -n "Use /home/{TOOL}/.{TOOL}/agent-harness as the harness root\|Acknowledge loaded and wait\|Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md" README.md`

## Status

Complete
