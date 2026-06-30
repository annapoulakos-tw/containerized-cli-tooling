# Spec spec:008: Self-Contained Role Packets

## Summary

Refactor the workflow role packet design so packets contain the minimum executable instructions needed for normal delegated-agent execution. Delegated harness agents should not have to chain-read command, agent, schema, template, skill, or state files to understand their workflow contract. Tool-specific packet builds must also state the tool-specific harness root and artifact root available to that agent.

## Outcome

When a fit-for-purpose agent receives a role packet for an agent harness workflow, the packet is sufficient to run the workflow without reading other harness instruction files. The agent may still inspect workspace files it must modify or review, but normal workflow execution does not depend on loading additional harness commands, agents, schemas, templates, skills, or state-machine files.

## Acceptance Criteria

* Each workflow role packet in the generated tool build includes the minimum executable instructions needed for that workflow.
* Role packets do not instruct delegated agents to read command files during normal execution.
* Role packets do not instruct delegated agents to read agent definition files during normal execution.
* Role packets do not instruct delegated agents to read schema files during normal execution.
* Role packets do not instruct delegated agents to read template files during normal execution.
* Role packets do not instruct delegated agents to read skill files during normal execution.
* Role packets include the relevant artifact format requirements inline instead of only pointing to schemas or templates.
* Role packets include the relevant lifecycle, ownership, transition, completion, and blocking rules inline instead of requiring the state machine file.
* Role packets include the relevant skill guidance inline or as packet-local instruction text sufficient for execution.
* Tool-specific packet output includes the tool-specific harness root for that built tool.
* Tool-specific packet output includes the tool-specific artifact root used for specs, plans, tasks, research, QA, audits, and completion reports.
* Generated packet verification fails if a packet contains normal-execution instructions to read harness command, agent, schema, template, skill, or state files.
* Generated packet verification covers every currently supported tool build target.
* Existing generated `AGENTS.md` output and copied support files remain available unless a later approved spec explicitly removes them.

## Assumptions

* confirmed: `spec:004` created role packets under an incorrect assumption that delegated agents could normally chain-read other harness files.
* confirmed: The new expected behavior is self-contained role packets for normal delegated-agent execution.
* confirmed: Agents may still read workspace files that are being modified, reviewed, or otherwise directly needed for the assigned task.
* confirmed: Tool-specific packets need explicit harness root and artifact root values.
* confirmed: The exact artifact root path for each supported tool build must be extracted from existing build conventions during implementation.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Keep canonical harness definitions as the source of truth for generated packet content.
* Keep packets concise while making them executable without normal chained reads.
* Do not require delegated task agents to read harness files outside the assigned packet during normal execution.
* Do not prevent agents from reading workspace files that are directly relevant to the delegated work.

## Non Goals

* Do not remove existing generated `AGENTS.md` files.
* Do not remove copied support files or directories.
* Do not redesign the artifact lifecycle beyond inlining the relevant existing rules.
* Do not add new workflow packet names.
* Do not change runtime artifact locations unless required to correctly state existing tool-specific roots.
* Do not implement this spec as part of spec creation.

## Open Questions

* None

## Research Required

* Identify the current harness root and artifact root conventions for each supported tool build target.
* Extract each supported tool's artifact root, expected to follow a pattern like `/home/{TOOL}/.{TOOL}/agent-harness`.
* Identify all existing packet text that depends on chained reads of harness commands, agents, schemas, templates, skills, or state files.

## Risks

* Inlining too much content could make packets large enough to lose the context-budget benefit.
* Inlining too little content could leave delegated agents dependent on additional harness file reads.
* Tool-specific root values may drift if build or mount conventions change without verification.

## Dependencies

* Existing canonical packet definitions under `agentic-harness/canonical/packets/`.
* Existing canonical harness definitions used as source material for packet content.
* Existing supported tool build targets.
* Existing build verification for generated packet outputs.

## Status

Complete
