# Spec spec:007: Anti-Overengineering Guidance

## Summary

Encode anti-overengineering guidance in the harness so `task-coder` avoids unnecessary abstraction and `qa-reviewer` flags implementations that are technically correct but larger or more abstract than the spec requires. The guidance may be implemented as a new skill or by updating existing `minimal-code` and language style skills.

## Outcome

Task implementation guidance steers coders toward simple, idiomatic, local code for simple local operations, and QA guidance treats unnecessary structure as a review concern even when behavior is correct.

## Acceptance Criteria

* Harness guidance tells `task-coder` not to create helper functions for one-line, one-use transformations.
* Harness guidance tells `task-coder` to prefer inline idiomatic code for simple local operations.
* Harness guidance tells `task-coder` not to introduce classes unless required by the spec or existing repository conventions.
* Harness guidance tells `task-coder` not to introduce factories unless required by the spec or existing repository conventions.
* Harness guidance tells `task-coder` not to introduce registries unless required by the spec or existing repository conventions.
* Harness guidance tells `task-coder` not to introduce frameworks unless required by the spec or existing repository conventions.
* Harness guidance tells `task-coder` not to introduce extension points unless required by the spec or existing repository conventions.
* QA guidance tells `qa-reviewer` to flag technically correct implementations that are unnecessarily large, abstract, or structured beyond the approved spec.
* The guidance is available to `task-coder` by default through assigned skills or agent instructions.
* The guidance is available to `qa-reviewer` by default through assigned skills or agent instructions.
* If implemented as a new skill, the new skill is assigned only where it is relevant.
* If implemented by updating existing skills, the updates remain compatible with existing skill purposes.
* Verification covers the generated build output or copied skill files used by supported tools.

## Assumptions

* confirmed: `task-coder` has sometimes produced overly abstract code.
* confirmed: One-use helper functions for trivial expressions should be discouraged.
* confirmed: Unnecessary structure should be treated as a QA concern.
* confirmed: The implementation may use a new skill or update existing `minimal-code` and language style skills.

## Constraints

* Apply skill: tdd.
* Prefer minimal code.
* Preserve existing behavior unless explicitly required.
* Follow repository conventions.
* Do not ban abstractions that are required by the approved spec.
* Do not ban abstractions that match established repository conventions.
* Keep the guidance concise enough to fit focused role packets.

## Non Goals

* Do not rewrite the full task-coder workflow.
* Do not rewrite the full QA workflow.
* Do not prohibit all helper functions, classes, or abstractions.
* Do not change artifact lifecycle rules.
* Do not implement this spec as part of spec creation.

## Open Questions

* None

## Research Required

* Identify whether the cleanest implementation path is a new anti-overengineering skill or updates to existing `minimal-code` and language style skills.

## Risks

* Overly strict wording could discourage useful extraction for repeated logic, complex conditions, tests, or repo conventions.
* QA guidance that is too vague may not consistently catch unnecessary abstraction.

## Dependencies

* Existing `task-coder` agent definition.
* Existing `qa-reviewer` agent definition.
* Existing `minimal-code` skill and language style skills.
* Existing build process that copies or packages skill guidance.

## Status

Complete
