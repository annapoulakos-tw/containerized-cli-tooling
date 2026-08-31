ai-cli () {
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        emulate -L zsh
    fi

    local tool="${1:-}"
    local project="${2:-${PWD}}"

    if [[ "${#}" -gt 2 || -z "${tool}" ]]; then
        printf '%s\n' "Usage: ai-cli <codex|copilot|gemini|rovo> [project]" >&2
        return 2
    fi

    project="$(cd "${project}" && pwd)" || return

    local image="${tool}-sandbox"
    local container_home="/home/${tool}"
    local home_volume="${tool}-home"
    local project_name
    project_name="$(basename "${project}" | tr -cd '[:alnum:]-_')"

    # local workstream_id=""
    # if [[ "${tool}" == "codex" ]]; then
    #     workstream_id="${AI_WORKSTREAM_ID:-${project_name}}"
    #     workstream_id="$(printf '%s' "${workstream_id}" | tr -cd '[:alnum:]_.-')"
    #     if [[ -z "${workstream_id}" ]]; then
    #         printf '%s\n' 'AI_WORKSTREAM_ID must contain a letter, number, dot, underscore, or hyphen.' >&2
    #         return 2
    #     fi
    # fi

    local workstream_id="${AI_WORKSTREAM_ID:-${project_name}}"
    workstream_id="$(printf '%s' "${workstream_id}" | tr -cd '[:alnum:]_.-')"
    if [[ -z "${workstream_id}" ]]; then
        printf '%s\n' 'Container worker ID must contain a letter, number, dot, underscore, or
        hyphen.' >&2
        return 2
    fi
    local container_name="${tool}-${workstream_id}"



    local state_home="${container_home}"
    local container_name="${tool}-${workstream_id:-${project_name}}"
    local customization_root="${container_home}/.${tool}"

    local customization_base="${tool}"
    local -a customization_directories=(agents)
    local -a post_home_mounts=()
    local -a command=()

    local cache_tmpfs="${container_home}/.cache"
    local harness_root="${AI_HARNESS_ROOT:-${HOME}/github.com/annapoulakos-tw/containerized-cli-tooling/agentic-harness}"
    local harness_build="${harness_root}/build/${tool}"

    local -a docker_arguments=(
        --rm
        -it
        --name "${container_name}"
        --cap-drop ALL
        --security-opt no-new-privileges
        --read-only
        --tmpfs /tmp
    )

    if [[ "${AI_TEAM_MANAGED:-}" == "1" ]]; then
        docker_arguments+=(
        --label "ai-team.managed=true"
        --label "ai-team.worker-id=${workstream_id}"
        --env "AI_WORKSTREAM_ID=${workstream_id}"
        )
    fi

    case "${tool}" in
        codex)
            local auth_file="${CODEX_AUTH_DIR:-${HOME}/.local/share/ai-cli/codex-auth}/auth.json"
            if [[ ! -s "${auth_file}" ]]; then
                printf 'Missing Codex authentication: %s\n' "${auth_file}" >&2
                printf '%s\n' 'Run: ai-cli-auth codex' >&2
                return 1
            fi

            state_home="/home/codex/state"
            customization_root="${state_home}"
            home_volume="codex-home-${workstream_id}"
            docker_arguments+=(--env CODEX_HOME="${state_home}")
            post_home_mounts+=(
                --mount "type=bind,src=${auth_file},dst=${state_home}/auth.json,readonly"
            )
            command=(codex -c 'cli_auth_credentials_store="file"' --sandbox danger-full-access)
            ;;
        copilot|gemini)
            cache_tmpfs="${cache_tmpfs}:uid=1001,gid=1001,mode=700,exec"
            customization_directories=(skills agents)
            command=("${tool}")

            if [[ "${tool}" == "copilot" && -n "${COPILOT_GITHUB_TOKEN:-}" ]]; then
                docker_arguments+=(--env COPILOT_GITHUB_TOKEN)
            fi

            if [[ "${tool}" == "gemini" ]]; then
                docker_arguments+=(
                    --env GEMINI_API_KEY
                    --env GOOGLE_CLOUD_PROJECT
                    --env GOOGLE_CLOUD_LOCATION
                    --env GOOGLE_GENAI_USE_VERTEXAI
                )
            fi
            ;;
        rovo)
            cache_tmpfs=""
            customization_base="rovodev"
            customization_directories=(skills)
            docker_arguments+=(
                --env ROVO_EMAIL
                --env ROVO_DEV_API_TOKEN
            )
            post_home_mounts+=(
                --mount "type=volume,src=rovo-cache,dst=${container_home}/.cache"
            )
            ;;
        *)
            printf '%s\n' "Unsupported tool: ${tool}" >&2
            return 2
            ;;
    esac

    if [[ -n "${cache_tmpfs}" ]]; then
        docker_arguments+=(--tmpfs "${cache_tmpfs}")
    fi

    docker_arguments+=(
        --mount "type=bind,src=${project},dst=/workspace"
        --mount "type=volume,src=${home_volume},dst=${state_home}"
    )

    docker_arguments+=("${post_home_mounts[@]}")

    # Shared global skills.
    local source_directory="${HOME}/.agents/skills"
    if [[ -d "${source_directory}" ]]; then
        docker_arguments+=(
            --mount "type=bind,src=${source_directory},dst=${container_home}/.agents/skills,readonly"
        )
    fi

    # Existing tool-specific customizations.
    local customization_directory
    for customization_directory in "${customization_directories[@]}"; do
        source_directory="${HOME}/.${customization_base}/${customization_directory}"
        if [[ -d "${source_directory}" ]]; then
            docker_arguments+=(
                --mount "type=bind,src=${source_directory},dst=${customization_root}/${customization_directory},readonly"
            )
        fi
    done

    # Optional harness build refresh.
    if [[ -x "${harness_root}/build.sh" ]]; then
        "${harness_root}/build.sh" "${tool}" || return
    fi

    if [[ ! -d "${harness_build}" ]]; then
        printf 'Missing generated harness build: %s\n' "${harness_build}" >&2
        printf 'Set AI_HARNESS_ROOT to the agentic-harness checkout or run its build.sh first.\n' >&2
        return 1
    fi

    # Tool-specific generated harness.
    #
    # This intentionally does NOT mount over /workspace/AGENTS.md.
    # Project-level AGENTS.md remains owned by the project.
    docker_arguments+=(
        --mount "type=bind,src=${harness_build},dst=${customization_root}/agent-harness,readonly"
    )

    docker_arguments+=(--workdir /workspace)

    if [[ "${tool}" == "codex" ]]; then
        if ! docker volume inspect "${home_volume}" >/dev/null 2>&1; then
            docker volume create "${home_volume}" >/dev/null || return
        fi

        if ! docker run --rm \
            --user root \
            --mount "type=volume,src=${home_volume},dst=/state" \
            "${image}" \
            sh -eu -c 'test -f /state/.ai-cli-initialized'
        then
            docker run --rm \
                --user root \
                --mount "type=volume,src=${home_volume},dst=/state" \
                "${image}" \
                sh -eu -c '
                    chown codex:codex /state
                    touch /state/.ai-cli-initialized
                    chown codex:codex /state/.ai-cli-initialized
                ' || return
        fi
    fi

    if [[ -n "${AI_CLI_DEBUG:-}" ]]; then
        printf 'Docker Args: %s\n' "${docker_arguments[*]}"
        printf 'Image: %s\n' "${image}"
        printf 'Command: %s\n' "${command[*]}"
    fi

    docker run "${docker_arguments[@]}" "${image}" "${command[@]}"
}

ai-cli-auth () {
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        emulate -L zsh
    fi

    if [[ "${#}" -ne 1 || "${1:-}" != "codex" ]]; then
        printf '%s\n' 'Usage: ai-cli-auth codex' >&2
        return 2
    fi

    local auth_dir="${CODEX_AUTH_DIR:-${HOME}/.local/share/ai-cli/codex-auth}"
    mkdir -p "${auth_dir}" || return
    chmod 700 "${auth_dir}" || return

    docker run --rm -it \
        --name codex-auth \
        --cap-drop ALL \
        --security-opt no-new-privileges \
        --read-only \
        --tmpfs /tmp \
        --tmpfs /home/codex/.cache \
        --env CODEX_HOME=/home/codex/auth \
        --mount "type=bind,src=${auth_dir},dst=/home/codex/auth" \
        codex-sandbox \
        codex login --device-auth
    local status="${?}"

    if [[ "${status}" -eq 0 && -f "${auth_dir}/auth.json" ]]; then
        chmod 600 "${auth_dir}/auth.json" || return
    fi
    return "${status}"
}
