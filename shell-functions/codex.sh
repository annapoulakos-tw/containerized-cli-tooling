codex() {
  set -euo pipefail

  local project="${1:-${PWD}}"
  local image="codex-sandbox"
  local home_volume="codex-home"
  local -a customization_mounts=()

  project="$(cd "${project}" && pwd)"

  [[ -d "${HOME}/.agents/skills" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.agents/skills,dst=/home/codex/.agents/skills,readonly")
  [[ -d "${HOME}/.codex/agents" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.codex/agents,dst=/home/codex/.codex/agents,readonly")

  docker run --rm -it \
    --name "codex-$(basename "${project}" | tr -cd '[:alnum:]-_')" \
    -p 127.0.0.1:1455:1455 \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --read-only \
    --tmpfs /tmp \
    --tmpfs /home/codex/.cache \
    --mount type=bind,src="${project}",dst=/workspace \
    --mount type=volume,src="${home_volume}",dst=/home/codex \
    "${customization_mounts[@]}" \
    --workdir /workspace \
    "${image}" \
    codex --sandbox danger-full-access
}
