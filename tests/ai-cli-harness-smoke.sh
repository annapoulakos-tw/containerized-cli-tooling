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
mkdir -p "${HOME}" "${AI_HARNESS_ROOT}/build/copilot" "${tmpdir}/bin" "${tmpdir}/project"
printf 'generated harness\n' > "${AI_HARNESS_ROOT}/build/copilot/AGENTS.md"

cat > "${AI_HARNESS_ROOT}/build.sh" <<'BUILD_SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$1" > "${AI_HARNESS_ROOT}/build-called"
BUILD_SH
chmod +x "${AI_HARNESS_ROOT}/build.sh"

cat > "${tmpdir}/bin/docker" <<'DOCKER_SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" > "${TMPDIR}/docker-args"
DOCKER_SH
chmod +x "${tmpdir}/bin/docker"

export TMPDIR="${tmpdir}"
export PATH="${tmpdir}/bin:${PATH}"

# Exercise the sourceable Bash wrapper with fake docker and harness tooling.
source "${repo_root}/shell-functions/ai-cli.sh"
ai-cli copilot "${tmpdir}/project"

grep -Fx 'copilot' "${AI_HARNESS_ROOT}/build-called" >/dev/null || fail "copilot harness build was not refreshed"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${AI_HARNESS_ROOT}/build/copilot,dst=/home/copilot/.copilot/agent-harness,readonly"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/AGENTS.md"

# Validate the Zsh autoload wrapper mirrors the same behavior without requiring zsh.
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'AI_HARNESS_ROOT:-${HOME}/code/agentic-harness'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" '"${harness_root}/build.sh" "${tool}"'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=${container_home}/.${customization_base}/agent-harness,readonly'
assert_not_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=/workspace/AGENTS.md'

# Validate documentation exposes the stable Copilot mount path and verification command.
assert_contains "${repo_root}/README.md" '/home/copilot/.copilot/agent-harness'
assert_contains "${repo_root}/README.md" 'docker run --rm --entrypoint sh'
assert_contains "${repo_root}/README.md" "copilot-sandbox -lc 'test -r /home/copilot/.copilot/agent-harness/AGENTS.md'"

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
assert_contains "${tmpdir}/zfunc/ai-cli" 'Usage: ai-cli <codex|copilot|gemini|rovo> [project]'
[[ "${zsh_install_output}" == *'autoload -Uz ai-cli'* ]] || fail "install-zsh output does not autoload ai-cli"

assert_contains "${repo_root}/README.md" 'ai-cli codex .'
assert_contains "${repo_root}/README.md" 'ai-cli <tool> <project>'

printf '%s\n' 'ai-cli harness smoke checks passed'
