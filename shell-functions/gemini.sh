gemini() {
  set -euo pipefail

  local project="${1:-${PWD}}"
  local image="gemini-sandbox"
  local home_volume="gemini-home"
  local -a customization_mounts=()

  project="$(cd "${project}" && pwd)"

  [[ -d "${HOME}/.agents/skills" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.agents/skills,dst=/home/gemini/.agents/skills,readonly")
  [[ -d "${HOME}/.gemini/skills" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.gemini/skills,dst=/home/gemini/.gemini/skills,readonly")
  [[ -d "${HOME}/.gemini/agents" ]] &&
    customization_mounts+=(--mount "type=bind,src=${HOME}/.gemini/agents,dst=/home/gemini/.gemini/agents,readonly")

  docker run --rm -it \
    --name "gemini-$(basename "${project}" | tr -cd '[:alnum:]-_')" \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --read-only \
    --tmpfs /tmp \
    --tmpfs /home/gemini/.cache:uid=1001,gid=1001,mode=700,exec \
    --env GEMINI_API_KEY \
    --env GOOGLE_CLOUD_PROJECT \
    --env GOOGLE_CLOUD_LOCATION \
    --env GOOGLE_GENAI_USE_VERTEXAI \
    --mount type=bind,src="${project}",dst=/workspace \
    --mount type=volume,src="${home_volume}",dst=/home/gemini \
    "${customization_mounts[@]}" \
    --workdir /workspace \
    "${image}"
}
