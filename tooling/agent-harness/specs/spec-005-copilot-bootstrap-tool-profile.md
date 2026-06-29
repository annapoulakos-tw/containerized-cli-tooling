# Spec spec:005: Copilot Bootstrap and Tool Profile

## Summary

Add Copilot-specific harness packaging that gives Copilot a stable bootstrap anchor and documents Copilot-specific prompt constraints. The generated Copilot build output should include a bootstrap file that hard-codes the harness root and artifact root, directs Copilot away from searching `/workspace` for harness files, and points workflow execution at generated role packets.

## Outcome

When the Copilot harness build is generated, Copilot has an explicit bootstrap file that tells it exactly where the harness lives, where runtime artifacts belong, and how to load workflow-specific packet instructions. The canonical harness also includes a Copilot tool profile describing the Copilot prompt and context requirements that drive this packaging.

## Acceptance Criteria

* Given the Copilot build runs, the generated `build/copilot/` output includes a Copilot-specific bootstrap file.
* The Copilot bootstrap file hard-codes the harness root as `/home/copilot/.copilot/agent-harness`.
* The Copilot bootstrap file hard-codes the artifact root as `/workspace/tooling/agent-harness`.
* The Copilot bootstrap file explicitly tells Copilot not to search `/workspace` for harness files.
* The Copilot bootstrap file explicitly tells Copilot to use `packets/` for workflow-specific instructions.
* The Copilot bootstrap file is generated or copied from canonical harness source, not maintained only as ad hoc build output.
* A canonical Copilot tool profile exists in the harness source.
* The Copilot tool profile documents that Copilot needs smaller prompts.
* The Copilot tool profile documents that Copilot needs repeated harness-root anchors.
* The Copilot tool profile documents explicit artifact-root rules.
* The Copilot tool profile documents one role packet per workflow.
* The Copilot build continues to produce the existing generated `AGENTS.md` output.
* Existing non-Copilot tool builds continue to work unless they intentionally ignore the Copilot-only bootstrap and profile.
* Verification confirms the Copilot build output contains the bootstrap file with the required root values and workflow packet instruction.

## Assumptions

* confirmed: Copilot frequently loses harness context unless the harness root is explicit.
* confirmed: The Copilot harness root must be `/home/copilot/.copilot/agent-harness`.
* confirmed: The runtime artifact root must be `/workspace/tooling/agent-harness`.
* confirmed: Copilot should use `packets/` for workflow-specific instructions.
* confirmed: Copilot should not search `/workspace` for harness files.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Keep the change additive to existing build output.
* Do not remove or replace generated `AGENTS.md`.
* Keep Copilot-specific guidance isolated from generic harness behavior unless explicitly needed by the build system.
* Keep canonical harness definitions as the source of truth for generated Copilot bootstrap and profile content.

## Non Goals

* Do not redesign role packet generation.
* Do not change the artifact root for existing harness workflows.
* Do not add bootstrap files for non-Copilot tools.
* Do not change Copilot authentication, container setup, or shell wrapper behavior.
* Do not implement this spec as part of spec creation.

## Open Questions

* None

## Research Required

* Identify the current canonical build layout and the best location for tool-specific profiles and bootstrap source files.

## Risks

* If the bootstrap is not generated from canonical source, Copilot guidance may drift from the documented tool profile.
* If Copilot-specific guidance leaks into generic build outputs, other tools may receive irrelevant or misleading instructions.

## Dependencies

* Existing Copilot build target.
* Existing generated `build/copilot/AGENTS.md` output.
* Existing generated packet directory behavior from spec:004, or compatible packet output support.

## Status

Complete
