gemini() {
  set -euo pipefail

  local project="${1:-${PWD}}"
  local image="gemini-sandbox"
  local home_volume="gemini-home"

  project="$(cd "${project}" && pwd)"

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
    --workdir /workspace \
    "${image}"
}
