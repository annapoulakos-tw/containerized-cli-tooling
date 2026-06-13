FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y \
  curl git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @google/gemini-cli

RUN useradd --create-home --home-dir /home/gemini --shell /bin/bash gemini \
  && mkdir -p /home/gemini/.gemini /home/gemini/.cache /workspace \
  && chown -R gemini:gemini /home/gemini /workspace

ENV HOME=/home/gemini
USER gemini
WORKDIR /workspace

CMD ["gemini"]
