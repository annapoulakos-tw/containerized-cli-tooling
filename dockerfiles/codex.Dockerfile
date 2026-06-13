FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
  curl git ca-certificates nodejs npm \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

RUN useradd --create-home --home-dir /home/codex --shell /bin/bash codex \
  && mkdir -p /home/codex/.codex /home/codex/.cache /workspace \
  && chown -R codex:codex /home/codex /workspace

ENV HOME=/home/codex
USER codex
WORKDIR /workspace

CMD ["codex"]
