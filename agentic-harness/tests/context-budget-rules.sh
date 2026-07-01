#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${root}/build.sh" codex >/dev/null

canonical_agent_files=(
    "${root}/canonical/agents/code-task.md"
    "${root}/canonical/agents/review-task.md"
)

build_agent_files=(
    "${root}/build/codex/agents/code-task.md"
    "${root}/build/codex/agents/review-task.md"
)

for file in "${canonical_agent_files[@]}"; do
    [[ -f "${file}" ]]
    grep -qi 'Never search `/workspace` for harness definitions' "${file}"
    grep -qi 'Artifact root' "${file}"
    grep -qi '{{ARTIFACT_ROOT}}' "${file}"
done

for file in "${build_agent_files[@]}"; do
    [[ -f "${file}" ]]
    grep -qi 'Never search `/workspace` for harness definitions' "${file}"
    grep -qi 'Artifact root' "${file}"
    grep -qi '/workspace/tooling/agent-harness' "${file}"
    ! grep -qi '{{ARTIFACT_ROOT}}' "${file}"
done

grep -q 'smallest correct change' "${root}/canonical/agents/code-task.md"
grep -q 'Red-Green-Refactor' "${root}/canonical/agents/code-task.md"
grep -q 'Verification recorded' "${root}/canonical/agents/code-task.md"
grep -q 'Do not create new tasks' "${root}/canonical/agents/code-task.md"

grep -q 'smallest correct change' "${root}/build/codex/agents/code-task.md"
grep -q 'Red-Green-Refactor' "${root}/build/codex/agents/code-task.md"
grep -q 'Verification recorded' "${root}/build/codex/agents/code-task.md"
grep -q 'Do not create new tasks' "${root}/build/codex/agents/code-task.md"

grep -q 'independently verify' "${root}/canonical/agents/review-task.md"
grep -q 'Do not modify implementation files' "${root}/canonical/agents/review-task.md"
grep -q 'Reject unnecessary complexity' "${root}/canonical/agents/review-task.md"

grep -q 'independently verify' "${root}/build/codex/agents/review-task.md"
grep -q 'Do not modify implementation files' "${root}/build/codex/agents/review-task.md"
grep -q 'Reject unnecessary complexity' "${root}/build/codex/agents/review-task.md"

[[ ! -d "${root}/canonical/packets" ]]
[[ ! -d "${root}/build/codex/packets" ]]
