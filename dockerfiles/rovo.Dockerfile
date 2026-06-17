FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
  bash ca-certificates curl git \
  && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
RUN set -eux; \
  case "${TARGETARCH:-amd64}" in \
    amd64) acli_arch="amd64" ;; \
    arm64) acli_arch="arm64" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
  esac; \
  curl -fsSL "https://acli.atlassian.com/linux/latest/acli_linux_${acli_arch}/acli" -o /usr/local/bin/acli; \
  chmod 0755 /usr/local/bin/acli

RUN printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  'exec acli rovodev "$@"' \
  > /usr/local/bin/rovo \
  && chmod 0755 /usr/local/bin/rovo

RUN printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  '' \
  'if [[ -n "${ROVO_DEV_API_TOKEN:-}" || -n "${ROVO_SITE:-}" || -n "${ROVO_EMAIL:-}" ]]; then' \
  '  if [[ -z "${ROVO_DEV_API_TOKEN:-}" || -z "${ROVO_SITE:-}" || -z "${ROVO_EMAIL:-}" ]]; then' \
  '    printf "%s\n" "Set ROVO_SITE, ROVO_EMAIL, and ROVO_DEV_API_TOKEN to bootstrap Rovo auth." >&2' \
  '    exit 2' \
  '  fi' \
  '' \
  '  printf "%s" "${ROVO_DEV_API_TOKEN}" | rovo auth login --site "${ROVO_SITE}" --email "${ROVO_EMAIL}" --token' \
  'fi' \
  '' \
  'exec rovo run' \
  > /usr/local/bin/rovo-bootstrap \
  && chmod 0755 /usr/local/bin/rovo-bootstrap

RUN useradd --create-home --home-dir /home/rovo --shell /bin/bash rovo \
  && mkdir -p /home/rovo/.rovodev /home/rovo/.cache /workspace \
  && chown -R rovo:rovo /home/rovo /workspace

ENV HOME=/home/rovo
USER rovo
WORKDIR /workspace

CMD ["rovo-bootstrap"]
