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
mkdir -p "${HOME}" "${AI_HARNESS_ROOT}/build/copilot" "${AI_HARNESS_ROOT}/build/gemini" "${AI_HARNESS_ROOT}/build/rovo" "${tmpdir}/bin" "${tmpdir}/project"
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
printf '%s\n' "$*" > "${TMPDIR}/docker-args"
DOCKER_SH
chmod +x "${tmpdir}/bin/docker"

export TMPDIR="${tmpdir}"
export PATH="${tmpdir}/bin:${PATH}"

# Exercise the sourceable Bash wrapper with fake docker and harness tooling.
source "${repo_root}/shell-functions/ai-cli.sh"
export COPILOT_GITHUB_TOKEN="fake-token-must-not-be-logged"
ai-cli copilot "${tmpdir}/project"

grep -Fx 'copilot' "${AI_HARNESS_ROOT}/build-called" >/dev/null || fail "copilot harness build was not refreshed"
assert_contains "${tmpdir}/docker-args" "--env COPILOT_GITHUB_TOKEN"
assert_not_contains "${tmpdir}/docker-args" "fake-token-must-not-be-logged"
assert_contains "${tmpdir}/docker-args" "type=bind,src=${AI_HARNESS_ROOT}/build/copilot,dst=/home/copilot/.copilot/agent-harness,readonly"
assert_contains "${tmpdir}/docker-args" "copilot-sandbox copilot"
assert_not_contains "${tmpdir}/docker-args" "dst=/workspace/AGENTS.md"

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
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=${container_home}/.${customization_base}/agent-harness,readonly'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'command=("${tool}")'
assert_contains "${repo_root}/zsh-autoload-funcs/ai-cli" '--env COPILOT_GITHUB_TOKEN'
assert_not_contains "${repo_root}/zsh-autoload-funcs/ai-cli" 'dst=/workspace/AGENTS.md'

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
assert_contains "${tmpdir}/zfunc/ai-cli" 'Usage: ai-cli <codex|copilot|gemini|rovo> [project]'
[[ "${zsh_install_output}" == *'autoload -Uz ai-cli'* ]] || fail "install-zsh output does not autoload ai-cli"

assert_contains "${repo_root}/README.md" 'ai-cli codex .'
assert_contains "${repo_root}/README.md" 'ai-cli <tool> <project>'

printf '%s\n' 'ai-cli harness smoke checks passed'
