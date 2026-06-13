FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
  curl git ca-certificates nodejs npm \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @github/copilot

RUN useradd --create-home --home-dir /home/copilot --shell /bin/bash copilot \
  && mkdir -p /home/copilot/.config /home/copilot/.cache /workspace \
  && chown -R copilot:copilot /home/copilot /workspace

ENV HOME=/home/copilot
USER copilot
WORKDIR /workspace

CMD ["copilot"]
