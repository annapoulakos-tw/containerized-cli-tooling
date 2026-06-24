#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
harness_root="${repo_root}/agentic-harness"
artifact_root="tooling/agent-harness"

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    exit 1
}

assert_contains() {
    local file="${1}"
    local expected="${2}"

    grep -F -- "${expected}" "${file}" >/dev/null || fail "${file} missing: ${expected}"
}

assert_not_contains() {
    local file="${1}"
    local unexpected="${2}"

    if grep -F -- "${unexpected}" "${file}" >/dev/null; then
        fail "${file} unexpectedly contains: ${unexpected}"
    fi
}

assert_no_exact_line() {
    local file="${1}"
    local unexpected="${2}"

    if grep -Fx -- "${unexpected}" "${file}" >/dev/null; then
        fail "${file} unexpectedly contains exact line: ${unexpected}"
    fi
}

for tool in codex copilot gemini rovo; do
    "${harness_root}/build.sh" "${tool}" >/dev/null

    command_dir="${harness_root}/build/${tool}/commands"
    spec_command="${command_dir}/spec.md"
    implement_command="${command_dir}/implement.md"

    assert_contains "${spec_command}" "${artifact_root}/specs/"
    assert_contains "${spec_command}" "does not fall back to root-level"
    assert_contains "${implement_command}" "${artifact_root}/plans/"
    assert_contains "${implement_command}" "${artifact_root}/research/"
    assert_contains "${implement_command}" "${artifact_root}/tasks/"
    assert_contains "${implement_command}" "${artifact_root}/qa/"
    assert_contains "${implement_command}" "${artifact_root}/audits/"
    assert_contains "${implement_command}" "${artifact_root}/completion/"

    assert_no_exact_line "${implement_command}" "plans/*"
    assert_no_exact_line "${implement_command}" "research/*"
    assert_no_exact_line "${implement_command}" "tasks/*"
    assert_no_exact_line "${implement_command}" "qa/*"
    assert_no_exact_line "${implement_command}" "completion/*"
done

assert_contains "${harness_root}/README.md" "${artifact_root}/specs/"
assert_contains "${harness_root}/README.md" "manual"

printf '%s\n' "agent harness artifact root smoke checks passed"
