#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

docker build \
  --file "${REPO_ROOT}/dockerfiles/gemini.Dockerfile" \
  --tag gemini-sandbox \
  "$@" \
  "${REPO_ROOT}"
