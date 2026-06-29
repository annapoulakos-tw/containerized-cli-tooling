# Containerized CLI Tooling

Run AI coding CLIs in containers while exposing only the current project
directory and a tool-specific persistent home volume.

Supported tools:

- OpenAI Codex
- GitHub Copilot CLI
- Google Gemini CLI
- Atlassian Rovo Dev CLI

## Prerequisites

- Docker
- GNU Make and Bash for the setup commands
- Bash or Zsh for sourceable functions, or Zsh for autoload functions

## Quick Start

Choose a tool, build its image, and install the shared shell function:

```sh
git clone <repository-url>
cd containerized-cli-tooling

make build TOOL=codex
make install-source
```

The install command prints the `source` line to add to `~/.bashrc` or
`~/.zshrc`. Start a new shell or source that startup file, then run the tool
from a project directory:

```sh
cd /path/to/project
ai-cli codex .
```

By default, the current directory is mounted as the project. Pass a different
tool name and project directory when needed:

```sh
ai-cli codex /path/to/project
ai-cli copilot /path/to/project
ai-cli gemini /path/to/project
```

## Project-Scoped Customization

Skills, custom agents, and instructions must be present inside the project
directory you run the wrapper from:

```text
project/
├── .agents/
│   └── skills/
│       └── example-skill/
│           └── SKILL.md
├── .codex/
│   └── agents/
│       └── codex-agent.toml
├── .github/
│   └── agents/
│       └── copilot-agent.agent.md
├── .gemini/
│   └── settings.json
├── AGENTS.md
└── GEMINI.md
```

Both Codex and Copilot CLI discover project-scoped skills from
`.agents/skills/` and instructions from `AGENTS.md`. A shared skill must follow
the Agent Skills specification and can be used by either tool.

Gemini CLI discovers project settings and commands from `.gemini/` and uses
`GEMINI.md` as its default project instruction file. Gemini can be configured
to use `AGENTS.md` through `.gemini/settings.json`.

Custom agents are tool-specific:

- Codex discovers TOML agent files from `.codex/agents/`.
- Copilot CLI discovers Markdown agent profiles from `.github/agents/`.

These files are available automatically because the project directory is
mounted at `/workspace`.

Files elsewhere on the host, including user-level skills and agents, are not
mounted into the container unless they are in one of the supported personal
customization directories.

## Personal Customization

The wrappers conditionally mount supported personal skills and agents from the
host into each container. A directory is mounted only when it exists, and all
personal customization mounts are read-only.

Shared skills using the Agent Skills standard can be placed here:

```text
~/.agents/skills/
```

Tool-specific personal customization paths are:

```text
~/.codex/agents/
~/.copilot/agents/
~/.copilot/skills/
~/.gemini/agents/
~/.gemini/skills/
~/.rovodev/skills/
```

For example, a personal Copilot agent at
`~/.copilot/agents/lazy-senior-developer.agent.md` is available to Copilot in
every mounted project without being committed to that project.

The wrappers do not mount the complete `~/.codex`, `~/.copilot`, `~/.gemini`,
or `~/.rovodev` directories from the host. Credentials, sessions,
configuration, and other container state remain in the tool-specific named
Docker volumes.

Read-only mounts prevent the containers from changing personal customization
files, but the tools can still read their contents. Do not store secrets in
skills, agent definitions, or their supporting files.

## Agent Harness

To run the Agent Harness in your cli session, use the following snippet:

```
Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md.
Use /home/{TOOL}/.{TOOL}/agent-harness as the harness root.
Acknowledge loaded and wait.
```

Where `{TOOL}` is the name of the tool you are using, i.e. `codex` or `copilot`.

If `${AI_HARNESS_ROOT:-$HOME/github.com/annapoulakos-tw/containerized-cli-tooling/agentic-harness}` contains `build.sh`, the
wrappers refresh the tool-specific harness build before starting the container.
When the generated build exists, it is mounted read-only at the tool's stable
harness path:

```text
/home/codex/.codex/agent-harness
/home/copilot/.copilot/agent-harness
```

The harness mount is separate from `/workspace`, so it does not overwrite
project-owned files such as `/workspace/AGENTS.md`.

To verify the Copilot image can read the mounted harness after starting through
the wrapper, run this from inside that container:

```sh
test -r /home/copilot/.copilot/agent-harness/AGENTS.md
```

To inspect the same mount with Docker directly, point the bind source at the
generated Copilot harness build:

```sh
docker run --rm --entrypoint sh \
  --mount "type=bind,src=${AI_HARNESS_ROOT:-$HOME/code/agentic-harness}/build/copilot,dst=/home/copilot/.copilot/agent-harness,readonly" \
  copilot-sandbox -lc 'test -r /home/copilot/.copilot/agent-harness/AGENTS.md'
```

## Gemini Authentication

Gemini CLI browser-based Google login does not currently work with this
container setup because its localhost OAuth callback cannot reach the
container. Use a Gemini API key instead:

```sh
export GEMINI_API_KEY="<your-api-key>"
gemini
```

The wrapper passes through these Gemini API and Vertex AI environment variables
when they are set on the host:

- `GEMINI_API_KEY`
- `GOOGLE_CLOUD_PROJECT`
- `GOOGLE_CLOUD_LOCATION`
- `GOOGLE_GENAI_USE_VERTEXAI`

User configuration is stored in the persistent `gemini-home` volume.

## Rovo Authentication

Rovo Dev CLI is provided by Atlassian as an Atlassian CLI extension. The
container installs `acli` and exposes `rovo` inside the image as a command that
delegates to `acli rovodev`. The default container command is:

```sh
rovo run
```

Authentication is still Atlassian-managed. To bootstrap auth through the
agnostic wrapper, export your Atlassian email and scoped Rovo Dev API token
before starting Rovo:

```sh
export ROVO_EMAIL="you@example.com"
export ROVO_DEV_API_TOKEN="<token>"

ai-cli rovo .
```

When both variables are set, the container runs `rovo auth login` with the
token, then starts `rovo run`. Auth state persists in the `rovo-home` Docker
volume, so the token does not need to be exported after the first successful
login. Unset `ROVO_DEV_API_TOKEN` after authentication to avoid passing it into
future containers.

The equivalent command inside the container is:

```sh
printf '%s' "$ROVO_DEV_API_TOKEN" | rovo auth login --email "$ROVO_EMAIL" --token && rovo run
```

Atlassian documents that Rovo Dev CLI requires an activated Rovo Dev site, an
allocation of Rovo Dev credits, and a paid Rovo Dev Standard subscription.
It is not available during a Rovo Dev Standard trial.

The `rovo` image can be built with Make:

```sh
make build TOOL=rovo
```

This repository currently provides `rovo.Dockerfile` for the agnostic wrapper
path, so `ai-cli rovo .` starts Rovo Dev in the mounted project. The shared
`ai-cli` sourceable and Zsh autoload functions support Rovo through the same
`ai-cli <tool> <project>` command form as the other tools.

Rovo Dev stores user configuration at `~/.rovodev/config.yml`. The agnostic
wrapper mounts `/home/rovo` from the persistent `rovo-home` volume, so Rovo
configuration, sessions, MCP config, and Atlassian auth state persist there.
Rovo also writes and downloads runtime files under `~/.cache`, so the wrapper
mounts `/home/rovo/.cache` from a separate persistent `rovo-cache` Docker
volume.
Project skills can live in `.rovodev/skills/` or `.agents/skills/` inside the
mounted project. User skills can live in `~/.rovodev/skills/` or
`~/.agents/skills/` on the host; those directories are mounted read-only when
they exist.

## Zsh Autoload Functions

Zsh users can install a function into `~/.zfunc` instead:

```sh
make build TOOL=codex
make install-zsh
```

Add the lines printed by `make install-zsh` to `~/.zshrc`. The default setup
is:

```zsh
fpath=("$HOME/.zfunc" $fpath)
autoload -Uz ai-cli
```

Use `ai-cli copilot .` for Copilot. To install somewhere else, override the
destination:

```sh
make install-zsh ZSH_FUNCTION_DIR="$HOME/.config/zsh/functions"
```

## Source Directly From The Clone

Installing is optional. A Bash or Zsh shell can source a function directly:

```sh
source /path/to/containerized-cli-tooling/shell-functions/ai-cli.sh
```

Add that line to the relevant shell startup file to load it automatically.

## Build Commands

```sh
make build TOOL=codex
make build TOOL=copilot
make build TOOL=gemini
make build TOOL=rovo
make build-all
make help
```

The Make targets build images from `dockerfiles/<tool>.Dockerfile` and tag
them as `<tool>-sandbox`. To pass additional arguments to `docker build`, run
Docker directly:

```sh
docker build --file ./dockerfiles/rovo.Dockerfile --tag rovo-sandbox --no-cache .
```

## Security Model

Each wrapper:

- Drops all Linux capabilities and enables `no-new-privileges`.
- Uses a read-only container filesystem with temporary cache directories.
- Mounts only the current directory at `/workspace`.
- Stores CLI credentials and configuration in a named Docker volume.
- Publishes the Codex authentication callback port only on `127.0.0.1`.

The current project is intentionally mounted read-write so the CLI can edit
it. The container also retains network access. Treat the current directory,
the tool-specific Docker volume, and any data reachable over the network as
accessible to the CLI.

Named home volumes are `codex-home`, `copilot-home`, `gemini-home`, and
`rovo-home`. Rovo also uses `rovo-cache` for downloaded runtime files. Remove
one to clear the corresponding tool's persisted credentials, settings, or
cache:

```sh
docker volume rm codex-home
```

## Bibliography

- [OpenAI Codex: Agent Skills](https://developers.openai.com/codex/skills)
- [OpenAI Codex: Custom instructions with AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [OpenAI Codex: Subagents](https://developers.openai.com/codex/subagents)
- [GitHub Copilot CLI: Adding agent skills](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills)
- [GitHub Copilot CLI: Creating and using custom agents](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)
- [GitHub Copilot CLI: Adding custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions)
- [Google Gemini CLI: Installation](https://geminicli.com/docs/get-started/installation/)
- [Google Gemini CLI: Authentication](https://geminicli.com/docs/get-started/authentication/)
- [Google Gemini CLI: Configuration](https://geminicli.com/docs/reference/configuration/)
- [Google Gemini CLI: GEMINI.md files](https://geminicli.com/docs/cli/gemini-md/)
- [Atlassian Rovo: Use Rovo Dev CLI](https://support.atlassian.com/rovo/docs/use-rovo-dev-cli/)
- [Atlassian Rovo: Install and run Rovo Dev CLI on your device](https://support.atlassian.com/rovo/docs/install-and-run-rovo-dev-cli-on-your-device/)
- [Atlassian Rovo: Manage Rovo Dev CLI settings](https://support.atlassian.com/rovo/docs/manage-rovo-dev-cli-settings/)
- [Atlassian Rovo: Extend Rovo Dev CLI with Agent Skills](https://support.atlassian.com/rovo/docs/extend-rovo-dev-cli-with-agent-skills/)
- [Atlassian CLI: Install on Linux](https://developer.atlassian.com/cloud/acli/guides/install-linux/)
