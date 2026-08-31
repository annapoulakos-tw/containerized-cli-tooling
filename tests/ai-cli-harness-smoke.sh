#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_parent="${repo_root}/.tmp"
mkdir -p "${tmp_parent}"
tmpdir="$(mktemp -d "${tmp_parent}/ai-cli-harness.XXXXXX")"
trap 'rm -rf "${tmpdir}"' EXIT

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    exit 1
}

assert_contains() {
    local file="${1}"
    local expected="${2}"

    grep -F -- "${expected}" "${file}" >/dev/null || fail "missing expected text: ${expected}"
}

assert_not_contains() {
    local file="${1}"
    local unexpected="${2}"

    if grep -F -- "${unexpected}" "${file}" >/dev/null; then
        fail "found unexpected text: ${unexpected}"
    fi
}

assert_file_exists() {
    local file="${1}"

    [[ -f "${file}" ]] || fail "missing expected file: ${file}"
}

export HOME="${tmpdir}/home"
export AI_HARNESS_ROOT="${tmpdir}/harness"
mkdir -p "${HOME}/.local/share/ai-cli/codex-auth" "${AI_HARNESS_ROOT}/build/codex" "${AI_HARNESS_ROOT}/build/copilot" "${AI_HARNESS_ROOT}/build/gemini" "${AI_HARNESS_ROOT}/build/rovo" "${tmpdir}/bin" "${tmpdir}/project"
printf '%s\n' '{}' > "${HOME}/.local/share/ai-cli/codex-auth/auth.json"
printf '%s\n' 'generated codex harness' > "${AI_HARNESS_ROOT}/build/codex/AGENTS.md"
printf '%s\n' '/home/copilot/.copilot/agent-harness/BOOTSTRAP.md' > "${AI_HARNESS_ROOT}/build/copilot/AGENTS.md"
printf '%s\n' 'generated gemini harness' > "${AI_HARNESS_ROOT}/build/gemini/AGENTS.md"
printf '%s\n' 'generated rovo harness' > "${AI_HARNESS_ROOT}/build/rovo/AGENTS.md"

cat > "${AI_HARNESS_ROOT}/build.sh" <<'BUILD_SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$1" > "${AI_HARNESS_ROOT}/build-called"
BUILD_SH
chmod +x "${AI_HARNESS_ROOT}/build.sh"

cat > "${tmpdir}/bin/docker" <<'DOCKER_SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "${TMPDIR}/docker-calls"

if [[ "${1:-}" == "volume" && "${2:-}" == "inspect" ]]; then
    [[ -f "${TMPDIR}/codex-volume-created" ]]
    exit
fi

if [[ "${1:-}" == "volume" && "${2:-}" == "create" ]]; then
    touch "${TMPDIR}/codex-volume-created"
    exit
fi

if [[ "$*" == *"test -f /state/.ai-cli-initialized"* ]]; then
    [[ -f "${TMPDIR}/codex-volume-initialized" ]]
    exit
fi

if [[ "$*" == *"chown codex:codex /state"* ]]; then
    touch "${TMPDIR}/codex-volume-initialized"
    exit
fi

printf '%s\n' "$*" > "${TMPDIR}/docker-args"
DOCKER_SH
chmod +x "${tmpdir}/bin/docker"

export TMPDIR="${tmpdir}"
export PATH="${tmpdir}/bin:${PATH}"

mkdir -p "${tmpdir}/templates/copilot/.github"
printf '%s\n' '# Managed project instructions' > "${tmpdir}/templates/PROJECT.md"
printf '%s\n' '# Managed Copilot instructions' > "${tmpdir}/templates/copilot/.github/copilot-instructions.md"
export AI_TEAM_PROJECT_TEMPLATE_PATH="${tmpdir}/templates/PROJECT.md"
export AI_TEAM_COPILOT_INSTRUCTIONS_PATH="${tmpdir}/templates/copilot/.github/copilot-instructions.md"

# Exercise the sourceable Bash wrapper with fake docker and harness tooling.
source "${repo_root}/shell-functions/ai-cli.sh"
export AI_WORKSTREAM_ID='story-123'
ai-cli codex "${tmpdir}/project"
assert_contains "${tmpdir}/docker-args" "--name codex-story-123"
assert_contains "${tmpdir}/docker-args" "--env CODEX_HOME=/home/codex/state"
assert_contains "${tmpdir}/docker-args" "type=volume,src=codex-home-story-123,dst=/home/codex/state"
assert_contains "${tmpdir}/docker-args" "dst=/home/codex/state/auth.json,readonly"
assert_not_contains "${tmpdir}/docker-args" "127.0.0.1:1455:1455"
assert_contains "${tmpdir}/docker-calls" "volume create codex-home-story-123"
assert_contains "${tmpdir}/docker-calls" "--user root --mount type=volume,src=codex-home-story-123,dst=/state codex-sandbox sh -eu -c"
assert_contains "${tmpdir}/docker-calls" "chown codex:codex /state"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/PROJECT.md"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/.github/copilot-instructions.md"

ai-cli codex "${tmpdir}/project"
[[ "$(grep -c '^volume create codex-home-story-123$' "${tmpdir}/docker-calls")" -eq 1 ]] || fail "Codex volume was recreated on repeat launch"
[[ "$(grep -Ec '^[[:space:]]*chown codex:codex /state$' "${tmpdir}/docker-calls")" -eq 1 ]] || fail "Codex volume was reinitialized on repeat launch"
unset AI_WORKSTREAM_ID

ai-cli-auth codex
assert_contains "${tmpdir}/docker-args" "--name codex-auth"
assert_contains "${tmpdir}/docker-args" "--env CODEX_HOME=/home/codex/auth"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${HOME}/.local/share/ai-cli/codex-auth,dst=/home/codex/auth"
assert_contains "${tmpdir}/docker-args" "codex-sandbox codex login --device-auth"
assert_not_contains "${tmpdir}/docker-args" "127.0.0.1:1455:1455"
[[ "$(stat -c '%a' "${HOME}/.local/share/ai-cli/codex-auth")" == "700" ]] || fail "Codex auth directory permissions are not 700"
[[ "$(stat -c '%a' "${HOME}/.local/share/ai-cli/codex-auth/auth.json")" == "600" ]] || fail "Codex auth file permissions are not 600"

export COPILOT_GITHUB_TOKEN="fake-token-must-not-be-logged"
ai-cli copilot "${tmpdir}/project"

grep -Fx 'copilot' "${AI_HARNESS_ROOT}/build-called" >/dev/null || fail "copilot harness build was not refreshed"
assert_contains "${tmpdir}/docker-args" "--env COPILOT_GITHUB_TOKEN"
assert_not_contains "${tmpdir}/docker-args" "fake-token-must-not-be-logged"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${AI_HARNESS_ROOT}/build/copilot,dst=/home/copilot/.copilot/agent-harness,readonly"
assert_contains "${tmpdir}/docker-args" "copilot-sandbox copilot"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/AGENTS.md"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/PROJECT.md"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/.github/copilot-instructions.md"

export AI_TEAM_MANAGED=1
ai-cli copilot "${tmpdir}/project"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${tmpdir}/templates/PROJECT.md,dst=/workspace/PROJECT.md,readonly"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${tmpdir}/templates/copilot/.github/copilot-instructions.md,dst=/workspace/.github/copilot-instructions.md,readonly"
assert_not_contains "${tmpdir}/docker-args" "--env AI_TEAM_PROJECT_TEMPLATE_PATH"
assert_not_contains "${tmpdir}/docker-args" "--env AI_TEAM_COPILOT_INSTRUCTIONS_PATH"

export AI_TEAM_COPILOT_INSTRUCTIONS_PATH="${tmpdir}/templates/missing-copilot-instructions.md"
ai-cli codex "${tmpdir}/project"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${tmpdir}/templates/PROJECT.md,dst=/workspace/PROJECT.md,readonly"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/.github/copilot-instructions.md"
export AI_TEAM_COPILOT_INSTRUCTIONS_PATH="${tmpdir}/templates/copilot/.github/copilot-instructions.md"

assert_invalid_template() {
    local variable_name="${1}"
    local invalid_path="${2}"
    local error_file="${tmpdir}/${variable_name}.err"
    local calls_before
    local calls_after

    calls_before="$(wc -l < "${tmpdir}/docker-calls")"
    export "${variable_name}=${invalid_path}"
    if ai-cli copilot "${tmpdir}/project" 2>"${error_file}"; then
        fail "copilot wrapper accepted invalid ${variable_name}: ${invalid_path}"
    fi
    calls_after="$(wc -l < "${tmpdir}/docker-calls")"
    [[ "${calls_before}" -eq "${calls_after}" ]] || fail "Docker was called for invalid ${variable_name}: ${invalid_path}"
    assert_contains "${error_file}" "${variable_name}"
}

mkdir -p "${tmpdir}/invalid-template-directory"
ln -s "${tmpdir}/templates/PROJECT.md" "${tmpdir}/template-symlink"
assert_invalid_template AI_TEAM_PROJECT_TEMPLATE_PATH "relative/PROJECT.md"
assert_invalid_template AI_TEAM_PROJECT_TEMPLATE_PATH "${tmpdir}/missing-template.md"
assert_invalid_template AI_TEAM_PROJECT_TEMPLATE_PATH "${tmpdir}/invalid-template-directory"
assert_invalid_template AI_TEAM_PROJECT_TEMPLATE_PATH "${tmpdir}/template-symlink"

export AI_TEAM_PROJECT_TEMPLATE_PATH="${tmpdir}/templates/PROJECT.md"
assert_invalid_template AI_TEAM_COPILOT_INSTRUCTIONS_PATH "relative/copilot-instructions.md"
assert_invalid_template AI_TEAM_COPILOT_INSTRUCTIONS_PATH "${tmpdir}/missing-copilot-instructions.md"
assert_invalid_template AI_TEAM_COPILOT_INSTRUCTIONS_PATH "${tmpdir}/invalid-template-directory"
assert_invalid_template AI_TEAM_COPILOT_INSTRUCTIONS_PATH "${tmpdir}/template-symlink"

if [[ "$(id -u)" -ne 0 ]]; then
    printf '%s\n' '# Unreadable template' > "${tmpdir}/unreadable-template.md"
    chmod 000 "${tmpdir}/unreadable-template.md"
    assert_invalid_template AI_TEAM_PROJECT_TEMPLATE_PATH "${tmpdir}/unreadable-template.md"
    chmod 600 "${tmpdir}/unreadable-template.md"
fi

export AI_TEAM_PROJECT_TEMPLATE_PATH="${tmpdir}/templates/PROJECT.md"
export AI_TEAM_COPILOT_INSTRUCTIONS_PATH="${tmpdir}/templates/copilot/.github/copilot-instructions.md"
unset AI_TEAM_MANAGED

unset COPILOT_GITHUB_TOKEN
ai-cli copilot "${tmpdir}/project"
assert_not_contains "${tmpdir}/docker-args" "--env COPILOT_GITHUB_TOKEN"

ai-cli gemini "${tmpdir}/project"
assert_contains "${tmpdir}/docker-args" "--env GEMINI_API_KEY"
assert_contains "${tmpdir}/docker-args" "--env GOOGLE_CLOUD_PROJECT"
assert_contains "${tmpdir}/docker-args" "--env GOOGLE_CLOUD_LOCATION"
assert_contains "${tmpdir}/docker-args" "--env GOOGLE_GENAI_USE_VERTEXAI"
assert_not_contains "${tmpdir}/docker-args" "--env COPILOT_GITHUB_TOKEN"

ai-cli rovo "${tmpdir}/project"
assert_contains "${tmpdir}/docker-args" "--env ROVO_EMAIL"
assert_contains "${tmpdir}/docker-args" "--env ROVO_DEV_API_TOKEN"
assert_not_contains "${tmpdir}/docker-args" "--env COPILOT_GITHUB_TOKEN"

# Validate the Zsh autoload wrapper mirrors the same behavior without requiring zsh.
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'AI_HARNESS_ROOT:-${HOME}/github.com/annapoulakos-tw/containerized-cli-tooling/agentic-harness'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" '"${harness_root}/build.sh" "${tool}"'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'Missing generated harness build: %s'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'old aggregate harness build'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=${customization_root}/agent-harness,readonly'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'command=("${tool}")'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" '--env COPILOT_GITHUB_TOKEN'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" '"${AI_TEAM_MANAGED:-}" == "1"'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'AI_TEAM_PROJECT_TEMPLATE_PATH must be an absolute path'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'AI_TEAM_COPILOT_INSTRUCTIONS_PATH must be an absolute path'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=/workspace/PROJECT.md,readonly'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=/workspace/.github/copilot-instructions.md,readonly'
assert_not_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=/workspace/AGENTS.md'

assert_contains "${repo_root}/shell-functions/ai-cli.sh" '"${AI_TEAM_MANAGED:-}" == "1"'
assert_contains "${repo_root}/shell-functions/ai-cli.sh" 'AI_TEAM_PROJECT_TEMPLATE_PATH must be an absolute path'
assert_contains "${repo_root}/shell-functions/ai-cli.sh" 'AI_TEAM_COPILOT_INSTRUCTIONS_PATH must be an absolute path'
assert_contains "${repo_root}/shell-functions/ai-cli.sh" 'dst=/workspace/PROJECT.md,readonly'
assert_contains "${repo_root}/shell-functions/ai-cli.sh" 'dst=/workspace/.github/copilot-instructions.md,readonly'

chmod -x "${AI_HARNESS_ROOT}/build.sh"
rm -rf "${AI_HARNESS_ROOT}/build/copilot"
if ai-cli copilot "${tmpdir}/project" 2>"${tmpdir}/missing-build.err"; then
    fail "copilot wrapper succeeded without a generated harness build"
fi
assert_contains "${tmpdir}/missing-build.err" "Missing generated harness build: ${AI_HARNESS_ROOT}/build/copilot"

mkdir -p "${AI_HARNESS_ROOT}/build/copilot"
printf '%s\n' '# Agentic Harness' > "${AI_HARNESS_ROOT}/build/copilot/AGENTS.md"
if ai-cli copilot "${tmpdir}/project" 2>"${tmpdir}/old-build.err"; then
    fail "copilot wrapper succeeded with an old aggregate AGENTS.md"
fi
assert_contains "${tmpdir}/old-build.err" 'old aggregate harness build'

# Validate documentation exposes the stable Copilot mount path and verification command.
assert_contains "${repo_root}/README.md" '/home/copilot/.copilot/agent-harness'
assert_contains "${repo_root}/README.md" 'docker run --rm --entrypoint sh'
assert_contains "${repo_root}/README.md" "copilot-sandbox -lc 'test -r /home/copilot/.copilot/agent-harness/AGENTS.md'"
assert_contains "${repo_root}/README.md" '## Copilot Authentication'
assert_contains "${repo_root}/README.md" 'export COPILOT_GITHUB_TOKEN="<your-token>"'
assert_contains "${repo_root}/README.md" '[GitHub Copilot CLI: Authenticating GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli)'
assert_contains "${repo_root}/dockerfiles/copilot.Dockerfile" '/home/copilot/.copilot'

# Validate Make install targets install the shared ai-cli entrypoint without TOOL.
source_install_output="$(
    make -C "${repo_root}" install-source SOURCE_FUNCTION_DIR="${tmpdir}/source-functions" 2>&1
)"
assert_file_exists "${tmpdir}/source-functions/ai-cli.sh"
assert_contains "${tmpdir}/source-functions/ai-cli.sh" 'ai-cli ()'
[[ "${source_install_output}" == *'source "'*"ai-cli.sh"* ]] || fail "install-source output does not source ai-cli.sh"

zsh_install_output="$(
    make -C "${repo_root}" install-zsh ZSH_FUNCTION_DIR="${tmpdir}/zfunc" 2>&1
)"
assert_file_exists "${tmpdir}/zfunc/ai-cli"
assert_file_exists "${tmpdir}/zfunc/ai-cli-auth"
assert_contains "${tmpdir}/zfunc/ai-cli" 'Usage: ai-cli <codex|copilot|gemini|rovo> [project]'
[[ "${zsh_install_output}" == *'autoload -Uz ai-cli'* ]] || fail "install-zsh output does not autoload ai-cli"

assert_contains "${repo_root}/README.md" 'ai-cli codex .'
assert_contains "${repo_root}/README.md" 'ai-cli <tool> <project>'

printf '%s\n' 'ai-cli harness smoke checks passed'
