#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

harness_root_for() {
    local tool="${1}"

    case "${tool}" in
        rovo)
            printf '/home/rovo/.rovodev/agent-harness'
            ;;
        *)
            printf '/home/%s/.%s/agent-harness' "${tool}" "${tool}"
            ;;
    esac
}

render_bootstrap() {
    local tool="${1}"
    local harness_root

    harness_root="$(harness_root_for "${tool}")"
    sed \
        -e "s|{{HARNESS_ROOT}}|${harness_root}|g" \
        -e "s|{{ARTIFACT_ROOT}}|/workspace/tooling/agent-harness|g" \
        -e "s|{TOOL}|${tool}|g" \
        "${root}/canonical/bootstrap/AGENTS.md"
}

check_bootstrap() {
    local tool="${1}"
    local agents="${root}/build/${tool}/AGENTS.md"
    local harness_root

    harness_root="$(harness_root_for "${tool}")"

    "${root}/build.sh" "${tool}" >/dev/null

    [[ -f "${agents}" ]]
    [[ ! -f "${root}/build/${tool}/BOOTSTRAP.md" ]]

    cmp -s <(render_bootstrap "${tool}") "${agents}"

    ! grep -q '{TOOL}' "${agents}"
    ! grep -q '{{HARNESS_ROOT}}' "${agents}"
    ! grep -q '{{ARTIFACT_ROOT}}' "${agents}"
    ! grep -q 'BOOTSTRAP.md' "${agents}"
    ! grep -q 'packets/' "${agents}"
    ! grep -q 'workflow packet' "${agents}"

    grep -q "${harness_root}" "${agents}"
    grep -q '/workspace/tooling/agent-harness' "${agents}"
    grep -q "${harness_root}/agents/" "${agents}"
    grep -q 'Available workflow agent definitions:' "${agents}"
    grep -q '## Model Delegation Rules' "${agents}"
    grep -q '## Task Delegation Matrix' "${agents}"
    grep -q 'must offload subtasks according to this matrix' "${agents}"
    grep -q 'must not substitute itself for a predefined agent' "${agents}"
    grep -q 'If a required role is unavailable, stop and hand off' "${agents}"
    grep -q 'bypassing role boundaries' "${agents}"
    grep -q 'active role' "${agents}"
    grep -q 'required next role' "${agents}"
    grep -q 'command or user action needed to continue' "${agents}"
}

check_bootstrap codex
check_bootstrap copilot
check_bootstrap gemini
check_bootstrap rovo

profile="${root}/canonical/tool-profiles/copilot.md"
[[ -f "${root}/build/copilot/tool-profile.md" ]]
[[ -f "${profile}" ]]
cmp -s "${profile}" "${root}/build/copilot/tool-profile.md"

grep -q 'smaller prompts' "${root}/build/copilot/tool-profile.md"
grep -q 'repeated harness-root anchors' "${root}/build/copilot/tool-profile.md"
grep -q 'explicit artifact-root rules' "${root}/build/copilot/tool-profile.md"
grep -q 'one workflow agent definition per workflow' "${root}/build/copilot/tool-profile.md"
