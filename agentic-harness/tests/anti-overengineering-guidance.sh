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
    grep -qi 'inline idiomatic code' "${file}"
    grep -qi 'simple local operations' "${file}"
    grep -qi 'classes, factories, registries, frameworks, or extension points' "${file}"
    grep -qi 'required by the spec or existing repository conventions' "${file}"
done

qa_files=(
    "${root}/canonical/agents/qa-reviewer/AGENTS.md"
    "${root}/canonical/packets/qa-review.md"
    "${root}/build/codex/agents/qa-reviewer/AGENTS.md"
    "${root}/build/codex/packets/qa-review.md"
)

for file in "${qa_files[@]}"; do
    [[ -f "${file}" ]]
    grep -qi 'technically correct' "${file}"
    grep -qi 'unnecessarily large' "${file}"
    grep -qi 'abstract' "${file}"
    grep -qi 'structured beyond the approved spec' "${file}"
done
