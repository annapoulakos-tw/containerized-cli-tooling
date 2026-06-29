# Implementation Plan plan:003: Install ai-cli Targets

## Spec

spec:003

## Summary

Update the Makefile install targets, setup documentation, and smoke verification so installation is centered on the shared `ai-cli` shell entrypoint while existing image build behavior remains tool-specific.

## Research Needed

* None

## Research References

* None

## Task Breakdown

* task:003 - Install shared ai-cli entrypoint

## Task Dependencies

* None

## Parallelization Opportunities

* None

## Risks

* Documentation examples currently describe per-tool installed commands and must be updated consistently with the Makefile behavior.

## Out of Scope

* Anything not included in spec:003.
* Changes to the `ai-cli` command interface, wrapper behavior, Docker image names, authentication, container runtime, or harness mount behavior.

## Status

Complete
