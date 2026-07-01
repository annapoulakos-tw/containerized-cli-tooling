#!/usr/bin/env bash
set -euo pipefail

tool="${1:-}"

if [[ -z "${tool}" ]]; then
    printf '%s\n' "Usage: ./build.sh <codex|copilot|gemini|rovo>" >&2
    exit 2
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
canonical="${root}/canonical"
build="${root}/build/${tool}"
artifact_root="/workspace/tooling/agent-harness"

if [[ ! -d "${canonical}" ]]; then
    printf '%s\n' "Missing canonical directory: ${canonical}" >&2
    exit 1
fi

rm -rf "${build}"
mkdir -p "${build}"

render_template() {
    local file="${1}"
    local harness_root

    harness_root="$(tool_harness_root)"
    sed \
        -e "s|{{HARNESS_ROOT}}|${harness_root}|g" \
        -e "s|{{ARTIFACT_ROOT}}|${artifact_root}|g" \
        -e "s|{TOOL}|${tool}|g" \
        "${file}"
}

copy_skills() {
    local skill_dir
    local skill_name

    mkdir -p "${build}/skills"

    for skill_dir in "${canonical}/skills"/*; do
        [[ -d "${skill_dir}" ]] || continue

        skill_name="$(basename "${skill_dir}")"

        if [[ -f "${skill_dir}/SKILL.md" ]]; then
            mkdir -p "${build}/skills/${skill_name}"
            cp "${skill_dir}/SKILL.md" "${build}/skills/${skill_name}/SKILL.md"
        fi
    done
}

copy_support_dir() {
    local name="${1}"

    if [[ -d "${canonical}/${name}" ]]; then
        mkdir -p "${build}/${name}"
        cp -R "${canonical}/${name}/." "${build}/${name}/"
    fi
}

tool_harness_root() {
    case "${tool}" in
        rovo)
            printf '/home/rovo/.rovodev/agent-harness'
            ;;
        *)
            printf '/home/%s/.%s/agent-harness' "${tool}" "${tool}"
            ;;
    esac
}

copy_agents() {
    local file

    rm -rf "${build}/agents"
    mkdir -p "${build}/agents"

    for file in "${canonical}/agents/"*.md; do
        [[ -f "${file}" ]] || continue
        render_template "${file}" > "${build}/agents/$(basename "${file}")"
    done
}

copy_copilot_files() {
    cp "${canonical}/tool-profiles/copilot.md" "${build}/tool-profile.md"
}

render_bootstrap_files() {
    rm -f "${build}/AGENTS.md"
    render_template "${canonical}/bootstrap/AGENTS.md" > "${build}/AGENTS.md"
}

case "${tool}" in
    codex|copilot|gemini|rovo)
        render_bootstrap_files
        copy_skills
        copy_agents
        ;;
    *)
        printf '%s\n' "Unsupported tool: ${tool}" >&2
        exit 2
        ;;
esac

if [[ "${tool}" == "copilot" ]]; then
    copy_copilot_files
fi

copy_support_dir "state"

printf 'Built harness for %s: %s\n' "${tool}" "${build}"
