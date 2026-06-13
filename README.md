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
