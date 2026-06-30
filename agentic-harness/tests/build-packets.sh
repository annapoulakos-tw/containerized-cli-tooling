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

check_tool() {
    local tool="${1}"
    local build
    local count
    local file
    local harness_root
    local packet
    local packet_dir

    "${root}/build.sh" "${tool}" >/dev/null

    build="${root}/build/${tool}"
    packet_dir="${build}/packets"
    harness_root="$(harness_root_for "${tool}")"

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
        grep -q '^## Runtime$' "${file}"
        grep -q '^## Embedded Command:' "${file}"
        grep -q '^## Embedded Agent:' "${file}"
        grep -q '^## Embedded State Rules: state/state-machine.md$' "${file}"
        grep -Eq '^## Embedded Skill:|^## Embedded Skills$' "${file}"
        grep -q "^Harness root: \`${harness_root}\`$" "${file}"
        grep -q '^Artifact root: `/workspace/tooling/agent-harness`$' "${file}"

        ! grep -Eiq '(load|read|open|consult|refer to|see)[^.\n]*(commands/|agents/|schemas/|templates/|state/|skills/)' "${file}"
    done

    file="${packet_dir}/spec-create.md"
    grep -q '^## Embedded Command: commands/spec.md$' "${file}"
    grep -q '^## Embedded Agent: agents/spec-creator/AGENTS.md$' "${file}"
    grep -q '^## Embedded Template: templates/spec.md$' "${file}"
    grep -q '^## Embedded Schema: schemas/spec.schema.md$' "${file}"
    grep -q '^## Embedded State Rules: state/state-machine.md$' "${file}"
    grep -q '^## Embedded Skill: skills/outcome-driven/SKILL.md$' "${file}"
    grep -q 'Artifact path: `tooling/agent-harness/specs/spec-{{ID}}-{{SLUG}}.md`' "${file}"
    grep -q 'A valid spec must contain all required fields' "${file}"
    grep -q 'Draft -> Approved' "${file}"

    grep -q '^## Embedded Template: templates/spec.md$' "${packet_dir}/spec-update.md"
    grep -q '^## Embedded Schema: schemas/spec.schema.md$' "${packet_dir}/spec-review.md"
    grep -q '^## Embedded Templates$' "${packet_dir}/implement-orchestrate.md"
    grep -q '^## Embedded Template: templates/task.md$' "${packet_dir}/task-code.md"
    grep -q '^## Embedded Template: templates/qa.md$' "${packet_dir}/qa-review.md"
    grep -q '^## Embedded Template: templates/audit.md$' "${packet_dir}/audit-review.md"
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
