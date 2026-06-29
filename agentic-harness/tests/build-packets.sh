#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

packets=(
    spec-create
    spec-review
    spec-update
    implement-orchestrate
    task-code
    qa-review
    audit-review
)

tools=(
    codex
    copilot
    gemini
    rovo
)

check_tool() {
    local tool="${1}"
    local build
    local count
    local file
    local packet
    local packet_dir

    "${root}/build.sh" "${tool}" >/dev/null

    build="${root}/build/${tool}"
    packet_dir="${build}/packets"

    [[ -f "${build}/AGENTS.md" ]]
    [[ -d "${packet_dir}" ]]
    [[ -d "${build}/commands" ]]
    [[ -d "${build}/schemas" ]]
    [[ -d "${build}/templates" ]]
    [[ -d "${build}/state" ]]
    [[ -d "${build}/skills" ]]

    count="$(find "${packet_dir}" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')"
    [[ "${count}" == "${#packets[@]}" ]]

    for packet in "${packets[@]}"; do
        file="${packet_dir}/${packet}.md"
        [[ -f "${file}" ]]
        grep -q '^## Command$' "${file}"
        grep -q '^## Agent$' "${file}"
        grep -q '^## Artifact Rules$' "${file}"
        grep -q '^## Context Budget$' "${file}"
        grep -q '^## Schema and Template Summary$' "${file}"
        grep -q '^## Assigned Skills$' "${file}"
    done
}

checksum_packets() {
    find "${root}/build" -path '*/packets/*.md' -type f -print0 \
        | sort -z \
        | xargs -0 sha256sum
}

for tool in "${tools[@]}"; do
    check_tool "${tool}"
done

before="$(checksum_packets)"

for tool in "${tools[@]}"; do
    check_tool "${tool}"
done

after="$(checksum_packets)"
[[ "${before}" == "${after}" ]]
