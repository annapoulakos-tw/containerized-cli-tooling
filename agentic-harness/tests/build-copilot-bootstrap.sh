#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_bootstrap() {
    local tool="${1}"
    local bootstrap

    "${root}/build.sh" "${tool}" >/dev/null

    bootstrap="${root}/build/${tool}/BOOTSTRAP.md"

    [[ -f "${root}/build/${tool}/AGENTS.md" ]]
    [[ -f "${bootstrap}" ]]

    cmp -s <(sed "s|{TOOL}|${tool}|g" "${root}/canonical/bootstrap/AGENTS.md") "${root}/build/${tool}/AGENTS.md"
    cmp -s <(sed "s|{TOOL}|${tool}|g" "${root}/canonical/bootstrap/BOOTSTRAP.md") "${bootstrap}"

    ! grep -q '{TOOL}' "${root}/build/${tool}/AGENTS.md"
    ! grep -q '{TOOL}' "${bootstrap}"

    grep -q "/home/${tool}/.${tool}/agent-harness/BOOTSTRAP.md" "${root}/build/${tool}/AGENTS.md"
    grep -q "/home/${tool}/.${tool}/agent-harness" "${bootstrap}"
    grep -q '/workspace/tooling/agent-harness' "${bootstrap}"
    grep -q "/home/${tool}/.${tool}/agent-harness/packets/" "${bootstrap}"
}

check_bootstrap codex
check_bootstrap copilot

profile="${root}/canonical/tool-profiles/copilot.md"
[[ -f "${root}/build/copilot/tool-profile.md" ]]
[[ -f "${profile}" ]]
cmp -s "${profile}" "${root}/build/copilot/tool-profile.md"

grep -q 'smaller prompts' "${root}/build/copilot/tool-profile.md"
grep -q 'repeated harness-root anchors' "${root}/build/copilot/tool-profile.md"
grep -q 'explicit artifact-root rules' "${root}/build/copilot/tool-profile.md"
grep -q 'one role packet per workflow' "${root}/build/copilot/tool-profile.md"

for tool in gemini rovo; do
    "${root}/build.sh" "${tool}" >/dev/null
    [[ -f "${root}/build/${tool}/AGENTS.md" ]]
    [[ ! -f "${root}/build/${tool}/BOOTSTRAP.md" ]]
done
