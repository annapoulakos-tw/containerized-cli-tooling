# Skill: TDD

## Definition

All implementation work follows Red-Green-Refactor.

## Red

Create or modify a test that fails for the desired behavior.

Verify the failure is caused by the missing behavior.

## Green

Implement the smallest change required to make the test pass.

Avoid premature abstraction.

Avoid unrelated improvements.

## Refactor

Improve clarity and maintainability while preserving behavior.

Run tests after each refactoring step.

## Rules

- Do not write production code without a failing test.
- Do not combine Red and Green into a single step.
- Prefer one behavior change per cycle.
- Stop when acceptance criteria are satisfied.

## Sandbox Verification

If tests cannot be executed in the current environment:

- Prepare the tests.
- Describe how to run them.
- Do not claim they passed.
- Await verification results.
