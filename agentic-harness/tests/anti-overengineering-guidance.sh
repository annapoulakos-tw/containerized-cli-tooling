#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${root}/build.sh" codex >/dev/null

minimal_files=(
    "${root}/canonical/skills/minimal-code/SKILL.md"
    "${root}/build/codex/skills/minimal-code/SKILL.md"
)

for file in "${minimal_files[@]}"; do
    [[ -f "${file}" ]]
    grep -qi 'one-line, one-use' "${file}"
    grep -qi 'smallest clear change' "${file}"
    grep -qi 'Avoid speculative abstractions' "${file}"
    grep -qi 'unless required by the spec or existing repository conventions' "${file}"
done

qa_files=(
    "${root}/canonical/agents/review-task.md"
    "${root}/build/codex/agents/review-task.md"
)

for file in "${qa_files[@]}"; do
    [[ -f "${file}" ]]
    grep -qi 'avoids unnecessary complexity' "${file}"
    grep -qi 'Review minimality' "${file}"
    grep -qi 'Reject unnecessary complexity' "${file}"
done
