# Parallel Codex Containers: Authentication and State Isolation

This repository supports concurrent Codex workers by separating authentication
from mutable workstream state:

```text
host auth.json (shared, read-only)
├── codex-home-story-123 (sessions, SQLite, logs, config)
└── codex-home-story-456 (sessions, SQLite, logs, config)
```

Neither `ai-cli-auth codex` nor normal `ai-cli codex` workers publish the OAuth
callback port.

## 1. Build and install

```sh
make build TOOL=codex
make install-source
```

Source the file printed by `make install-source`. Zsh users may instead run
`make install-zsh` and autoload both `ai-cli` and `ai-cli-auth` as instructed.

The canonical credential defaults to:

```text
~/.local/share/ai-cli/codex-auth/auth.json
```

Override its containing directory with `CODEX_AUTH_DIR` if required.

## 2. Authenticate or refresh the canonical login

If migration is unavailable, or the login expires, run:

```sh
ai-cli-auth codex
```

This dedicated container mounts the auth directory writable at
`/home/codex/auth`, sets `CODEX_HOME` to that path, and runs
`codex login --device-auth`. Codex displays a device-login URL and one-time
code; no localhost callback is involved. The resulting directory and file are
restricted to modes `0700` and `0600`.

Verify without displaying the secret:

```sh
test -s "${CODEX_AUTH_DIR:-$HOME/.local/share/ai-cli/codex-auth}/auth.json"
```

## 3. Run isolated workers

Give every durable story or workstream a stable identifier:

```sh
AI_WORKSTREAM_ID=story-123 ai-cli codex /path/to/worktree-123
AI_WORKSTREAM_ID=story-456 ai-cli codex /path/to/worktree-456
```

Each invocation gets:

- container `codex-<workstream-id>`;
- volume `codex-home-<workstream-id>`;
- `CODEX_HOME=/home/codex/state`;
- only its selected project mounted at `/workspace`;
- the canonical `auth.json` mounted read-only inside its private state volume;
- no published OAuth callback port.

Before the hardened worker starts, `ai-cli` creates the workstream volume when
needed and runs a separate root helper from `codex-sandbox`. The helper assigns
the volume root to `codex:codex` and writes `.ai-cli-initialized`. Existing
volumes without the marker are initialized once, which automatically repairs
volumes created by older versions. Marked volumes are never recursively
re-owned or otherwise reinitialized during normal launches.

When `AI_WORKSTREAM_ID` is absent, the sanitized project basename is used. The
orchestrator should always set it when running multiple worktrees from one
repository. Allowed Docker-name characters are letters, numbers, `.`, `_`, and
`-`; all other characters are removed.

The wrappers retain a read-only root filesystem, dropped capabilities,
`no-new-privileges`, and tmpfs mounts. Workers do not receive Docker socket,
SSH, cloud credential, or broad home-directory access.

## 4. Verify concurrency and isolation

With two workers running:

```sh
docker volume ls | grep codex-home-
docker inspect codex-story-123 --format '{{range .Config.Env}}{{println .}}{{end}}' | grep '^CODEX_HOME='
docker port codex-story-123
```

Expected results are distinct volumes, `CODEX_HOME=/home/codex/state`, and no
published ports. Inside a worker, verify:

```sh
test -r "${CODEX_HOME}/auth.json"
test ! -w "${CODEX_HOME}/auth.json"
touch "${CODEX_HOME}/write-test" && rm "${CODEX_HOME}/write-test"
```

## Token refresh

OpenAI documents that ChatGPT login tokens refresh automatically during use.
If Codex reports an invalid or already-used refresh token, rerun
`ai-cli-auth codex`. Do not copy stale credentials from workstream volumes;
authentication state remains canonical and separate from mutable worker state.

## Orchestrator contract

Treat the workstream as the durable object. At minimum persist its ID, worktree
path, tool, container name, home volume, workflow state, and current gate. Run
the eventual supervisor on the host when practical. A Codex worker should not
control Docker; mounting `/var/run/docker.sock` into an AI-controlled worker
effectively grants broad host-engine control.

## References

- [OpenAI Codex authentication](https://developers.openai.com/codex/auth/)

The OpenAI documentation identifies `auth.json` under `CODEX_HOME` as the
file-based credential cache and treats it as a password.
