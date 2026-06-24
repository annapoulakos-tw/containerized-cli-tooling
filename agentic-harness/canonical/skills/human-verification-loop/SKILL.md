# Skill: Human Verification Loop

## Definition

Verification may require execution outside the sandbox.

## Rules

- Run tests locally when possible.
- If tests cannot be run, provide verification instructions.
- Never claim tests passed when they were not executed.
- Distinguish:
  - Verified
  - Not Verified
  - User Verified
- Ask for test results when external verification is required.

## No Existing Test Suite

If the repository has no automated tests:

- Do not invent a heavy test framework.
- Use the smallest meaningful smoke checks.
- Prefer shell syntax checks for shell scripts.
- Provide manual verification commands.
- Clearly mark verification as smoke-tested, manually verified, or not verified.
