#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${root}/build.sh" codex >/dev/null

files=(
    "${root}/canonical/agents/task-coder/AGENTS.md"
    "${root}/canonical/agents/qa-reviewer/AGENTS.md"
    "${root}/canonical/packets/task-code.md"
    "${root}/canonical/packets/qa-review.md"
    "${root}/build/codex/agents/task-coder/AGENTS.md"
    "${root}/build/codex/agents/qa-reviewer/AGENTS.md"
    "${root}/build/codex/packets/task-code.md"
    "${root}/build/codex/packets/qa-review.md"
)

for file in "${files[@]}"; do
    [[ -f "${file}" ]]
    grep -qi 'relevant parent spec sections' "${file}"
    grep -qi 'relevant research references' "${file}"
    grep -qi 'files likely affected' "${file}"
    grep -qi 'required skills' "${file}"
    grep -qi 'Do not load all specs' "${file}"
    grep -qi 'all tasks' "${file}"
    grep -qi 'all QA artifacts' "${file}"
    grep -qi 'all schemas' "${file}"
    grep -qi 'the full harness' "${file}"
    grep -qi 'record the reason' "${file}"
done

grep -q 'Start from the assigned task' "${root}/canonical/agents/task-coder/AGENTS.md"
grep -q 'Start from the assigned task' "${root}/canonical/packets/task-code.md"
grep -q 'Start from the assigned task' "${root}/build/codex/agents/task-coder/AGENTS.md"
grep -q 'Start from the assigned task' "${root}/build/codex/packets/task-code.md"

grep -q 'Start from the assigned QA target' "${root}/canonical/agents/qa-reviewer/AGENTS.md"
grep -q 'Start from the assigned QA target' "${root}/canonical/packets/qa-review.md"
grep -q 'Start from the assigned QA target' "${root}/build/codex/agents/qa-reviewer/AGENTS.md"
grep -q 'Start from the assigned QA target' "${root}/build/codex/packets/qa-review.md"
