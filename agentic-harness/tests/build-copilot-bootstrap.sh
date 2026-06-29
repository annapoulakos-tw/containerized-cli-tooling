#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${root}/build.sh" copilot >/dev/null

bootstrap="${root}/build/copilot/BOOTSTRAP.md"
profile="${root}/canonical/tool-profiles/copilot.md"

[[ -f "${root}/build/copilot/AGENTS.md" ]]
[[ -f "${bootstrap}" ]]
[[ -f "${profile}" ]]
cmp -s "${root}/canonical/bootstrap/copilot.md" "${bootstrap}"

grep -q '/home/copilot/.copilot/agent-harness' "${bootstrap}"
grep -q '/workspace/tooling/agent-harness' "${bootstrap}"
grep -q 'Do not search /workspace for harness files' "${bootstrap}"
grep -q 'Use packets/ for workflow-specific instructions' "${bootstrap}"

grep -q 'smaller prompts' "${profile}"
grep -q 'repeated harness-root anchors' "${profile}"
grep -q 'explicit artifact-root rules' "${profile}"
grep -q 'one role packet per workflow' "${profile}"

for tool in codex gemini rovo; do
    "${root}/build.sh" "${tool}" >/dev/null
    [[ -f "${root}/build/${tool}/AGENTS.md" ]]
    [[ ! -f "${root}/build/${tool}/BOOTSTRAP.md" ]]
done
