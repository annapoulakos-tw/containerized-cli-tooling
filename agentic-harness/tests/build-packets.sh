#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

agents=(
    audit-spec
    code-task
    create-spec
    implement-spec
    research-spec
    review-spec
    review-task
    update-spec
)

tools=(
    codex
    copilot
    gemini
    rovo
)

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

check_canonical_layout() {
    [[ -d "${root}/canonical/agents" ]]
    [[ -d "${root}/canonical/bootstrap" ]]
    [[ -d "${root}/canonical/skills" ]]
    [[ -d "${root}/canonical/state" ]]
    [[ -d "${root}/canonical/tool-profiles" ]]
    [[ -f "${root}/canonical/build-strategy.md" ]]
    [[ -f "${root}/canonical/strategy.md" ]]

    [[ ! -d "${root}/canonical/packets" ]]
    [[ ! -d "${root}/canonical/commands" ]]
    [[ ! -d "${root}/canonical/schemas" ]]
    [[ ! -d "${root}/canonical/templates" ]]
    [[ ! -f "${root}/canonical/bootstrap/BOOTSTRAP.md" ]]

    for agent in "${agents[@]}"; do
        [[ -f "${root}/canonical/agents/${agent}.md" ]]
    done

    grep -q 'Write all spec artifacts under:' "${root}/canonical/agents/create-spec.md"
    grep -q '`{{ARTIFACT_ROOT}}/specs/`' "${root}/canonical/agents/create-spec.md"
    grep -q '`{{ARTIFACT_ROOT}}/specs/spec-<id>-<slug>.md`' "${root}/canonical/agents/create-spec.md"
}

check_tool() {
    local tool="${1}"
    local build
    local count
    local file
    local harness_root
    local agent

    mkdir -p "${root}/build/${tool}/packets" "${root}/build/${tool}/commands"
    printf 'stale\n' > "${root}/build/${tool}/packets/stale.md"
    printf 'stale\n' > "${root}/build/${tool}/BOOTSTRAP.md"
    printf 'stale\n' > "${root}/build/${tool}/commands/stale.md"

    "${root}/build.sh" "${tool}" >/dev/null

    build="${root}/build/${tool}"
    harness_root="$(harness_root_for "${tool}")"

    [[ -f "${build}/AGENTS.md" ]]
    [[ -d "${build}/agents" ]]
    [[ -d "${build}/state" ]]
    [[ -d "${build}/skills" ]]
    [[ ! -e "${build}/BOOTSTRAP.md" ]]
    [[ ! -e "${build}/packets" ]]
    [[ ! -e "${build}/commands" ]]
    [[ ! -e "${build}/schemas" ]]
    [[ ! -e "${build}/templates" ]]

    count="$(find "${build}/agents" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')"
    [[ "${count}" == "${#agents[@]}" ]]

    for agent in "${agents[@]}"; do
        file="${build}/agents/${agent}.md"
        [[ -f "${file}" ]]
        grep -q '^# Agent:' "${file}"
        grep -q "^Harness root:$" "${file}"
        grep -q "^Artifact root:$" "${file}"
        grep -q "${harness_root}" "${file}"
        grep -q '/workspace/tooling/agent-harness' "${file}"
        ! grep -q '{{HARNESS_ROOT}}' "${file}"
        ! grep -q '{{ARTIFACT_ROOT}}' "${file}"
    done

    grep -q '`/workspace/tooling/agent-harness/specs/`' "${build}/agents/create-spec.md"
    grep -q '`/workspace/tooling/agent-harness/specs/spec-<id>-<slug>.md`' "${build}/agents/create-spec.md"
}

checksum_build() {
    find "${root}/build" -type f -print0 \
        | sort -z \
        | xargs -0 sha256sum
}

check_canonical_layout

for tool in "${tools[@]}"; do
    check_tool "${tool}"
done

before="$(checksum_build)"

for tool in "${tools[@]}"; do
    check_tool "${tool}"
done

after="$(checksum_build)"
[[ "${before}" == "${after}" ]]
