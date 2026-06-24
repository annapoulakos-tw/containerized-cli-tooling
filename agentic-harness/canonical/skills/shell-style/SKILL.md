# Skill: Shell Style

## Definition

Write safe, portable shell scripts consistent with the repository.

## Rules

- Prefer existing script conventions.
- Quote variables unless word splitting is intentional.
- Use `set -euo pipefail` when appropriate for the script.
- Prefer functions for repeated behavior.
- Avoid Bash-specific features unless Bash is required.
- Use ShellCheck-compatible patterns when practical.
