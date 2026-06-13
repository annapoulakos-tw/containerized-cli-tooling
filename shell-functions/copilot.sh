copilot() {
  set -euo pipefail

  local project="${1:-${PWD}}"
  local image="copilot-sandbox"
  local home_volume="copilot-home"
  local -a customization_mounts=()

  project="$(cd "${project}" && pwd)"

  [[ -d "${HOME}/.agents/skills" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.agents/skills,dst=/home/copilot/.agents/skills,readonly")
  [[ -d "${HOME}/.copilot/skills" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.copilot/skills,dst=/home/copilot/.copilot/skills,readonly")
  [[ -d "${HOME}/.copilot/agents" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.copilot/agents,dst=/home/copilot/.copilot/agents,readonly")

  docker run --rm -it \
    --name "copilot-$(basename "${PWD}" | tr -cd '[:alnum:]-_')" \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --read-only \
    --tmpfs /tmp \
    --tmpfs /home/copilot/.cache:uid=1001,gid=1001,mode=700,exec \
    --mount type=bind,src="$(pwd)",dst=/workspace \
    --mount type=volume,src=copilot-home,dst=/home/copilot \
    "${customization_mounts[@]}" \
    --workdir /workspace \
    copilot-sandbox
}
