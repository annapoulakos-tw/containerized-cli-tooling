# Containerized CLI Tooling

Run AI coding CLIs in containers while exposing only the current project
directory and a tool-specific persistent home volume.

Supported tools:

- OpenAI Codex
- GitHub Copilot CLI

## Prerequisites

- Docker
- GNU Make and Bash for the setup commands
- Bash or Zsh for sourceable functions, or Zsh for autoload functions

## Quick Start

Choose a tool, build its image, and install its shell function:

```sh
git clone <repository-url>
cd containerized-cli-tooling

make build TOOL=codex
make install-source TOOL=codex
```

The install command prints the `source` line to add to `~/.bashrc` or
`~/.zshrc`. Start a new shell or source that startup file, then run the tool
from a project directory:

```sh
cd /path/to/project
codex
```

By default, the current directory is mounted as the project. Pass a different
project directory as the wrapper's first argument when needed:

```sh
codex /path/to/project
copilot /path/to/project
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
└── AGENTS.md
```

Both Codex and Copilot CLI discover project-scoped skills from
`.agents/skills/` and instructions from `AGENTS.md`. A shared skill must follow
the Agent Skills specification and can be used by either tool.

Custom agents are tool-specific:

- Codex discovers TOML agent files from `.codex/agents/`.
- Copilot CLI discovers Markdown agent profiles from `.github/agents/`.

These files are available automatically because the project directory is
mounted at `/workspace`.

Files elsewhere on the host, including user-level skills and agents, are not
mounted into the container. Add reusable customization files to each project
before launching the relevant tool.

## Zsh Autoload Functions

Zsh users can install a function into `~/.zfunc` instead:

```sh
make build TOOL=codex
make install-zsh TOOL=codex
```

Add the lines printed by `make install-zsh` to `~/.zshrc`. The default setup
is:

```zsh
fpath=("$HOME/.zfunc" $fpath)
autoload -Uz codex
```

Use `TOOL=copilot` for Copilot. To install somewhere else, override the
destination:

```sh
make install-zsh TOOL=codex ZSH_FUNCTION_DIR="$HOME/.config/zsh/functions"
```

## Source Directly From The Clone

Installing is optional. A Bash or Zsh shell can source a function directly:

```sh
source /path/to/containerized-cli-tooling/shell-functions/codex.sh
```

Add that line to the relevant shell startup file to load it automatically.

## Build Commands

```sh
make build TOOL=codex
make build TOOL=copilot
make build-all
make help
```

The standalone build scripts also work from any directory and pass additional
arguments to `docker build`:

```sh
/path/to/containerized-cli-tooling/codex-build.sh --no-cache
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

Named volumes are `codex-home` and `copilot-home`. Remove one to clear the
corresponding tool's persisted credentials and settings:

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
