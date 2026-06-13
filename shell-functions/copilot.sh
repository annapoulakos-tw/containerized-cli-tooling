copilot() {
  set -euo pipefail

  local project="${1:-${PWD}}"
  local image="copilot-sandbox"
  local home_volume="copilot-home"

  project="$(cd "${project}" && pwd)"

  docker run --rm -it \
    --name "copilot-$(basename "${PWD}" | tr -cd '[:alnum:]-_')" \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --read-only \
    --tmpfs /tmp \
    --tmpfs /home/copilot/.cache:uid=1001,gid=1001,mode=700,exec \
    --mount type=bind,src="$(pwd)",dst=/workspace \
    --mount type=volume,src=copilot-home,dst=/home/copilot \
    --workdir /workspace \
    copilot-sandbox
}
