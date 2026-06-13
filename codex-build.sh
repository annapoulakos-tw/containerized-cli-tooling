#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

docker build \
  --file "${REPO_ROOT}/dockerfiles/codex.Dockerfile" \
  --tag codex-sandbox \
  "$@" \
  "${REPO_ROOT}"
