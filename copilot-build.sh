#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

docker build \
  --file "${REPO_ROOT}/dockerfiles/copilot.Dockerfile" \
  --tag copilot-sandbox \
  "$@" \
  "${REPO_ROOT}"
