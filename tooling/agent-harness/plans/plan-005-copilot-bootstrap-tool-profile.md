# Implementation Plan plan:005: Copilot Bootstrap and Tool Profile

## Spec

spec:005

## Summary

Add canonical Copilot-specific bootstrap and tool profile sources, then update the build so only the Copilot build receives the bootstrap while existing generic build outputs remain intact.

## Research Needed

* None

## Research References

* Existing `build.sh` supported tool handling.
* Existing canonical packet output from spec:004.

## Task Breakdown

* task:005 - Add Copilot bootstrap and tool profile build output

## Task Dependencies

* spec:004 packet output support

## Parallelization Opportunities

* None

## Risks

* Copilot-specific guidance could leak into non-Copilot builds if the build logic is not tool-scoped.

## Out of Scope

* Anything not included in spec:005

## Status

Complete
