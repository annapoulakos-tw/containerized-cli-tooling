# Implementation Plan plan:008: Self-Contained Role Packets

## Spec

spec:008

## Summary

Make generated workflow packets executable without normal chained reads of other harness instruction files. Keep canonical packet files as source material, add tool-specific root injection during build, and strengthen packet verification across supported tools.

## Research Needed

* Confirm harness root and runtime artifact root conventions for each supported tool.
* Identify packet text that requires delegated agents to read command, agent, schema, template, skill, or state files during normal execution.

## Research References

* research:003

## Task Breakdown

* task:008 - Generate self-contained role packets

## Task Dependencies

* task:008 depends on research:003

## Parallelization Opportunities

* None. The packet content, build injection, and verification tests touch the same subsystem and should be changed together.

## Risks

* Packets may become too large if full source files are copied instead of minimal executable rules.
* Tests may overfit wording instead of enforcing the normal-execution contract.

## Out of Scope

* Anything not included in spec:008.
* Removing generated `AGENTS.md` or copied support directories.
* Adding new workflow packet names.

## Status

Complete
