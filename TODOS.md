# TODOs

### TODO: Resolve container user IDs

Use a consistent approach for mapping host and container user IDs so files
created in mounted projects have the expected ownership.

Open questions:

- Should image builds accept the host UID and GID as build arguments?
- Should the wrappers set the runtime UID and GID instead?
- Why does the Copilot image require UID and GID `1001` while Codex works
  without an explicit value?
- Should Gemini continue using UID and GID `1001` because its Node.js base
  image already uses `1000`?

Notes:

- Any solution must continue to work with the named home volumes.
- Fix and test the behavior for Codex, Copilot, and Gemini.

### TODO: Fix Copilot project directory argument

Make `copilot /path/to/project` mount the supplied project directory, matching
the documented behavior and the Codex wrapper.

Open questions:

- Should both the sourceable and Zsh autoload functions share an implementation
  to prevent them from drifting apart?

Notes:

- The Copilot wrappers currently resolve the argument but mount the current
  working directory instead.

### TODO: Isolate sourceable function shell options

Prevent sourceable wrapper functions from changing shell options in the
caller's interactive shell.

Open questions:

- Should strict mode be removed from the functions or isolated in a subshell?

Notes:

- `set -euo pipefail` inside a sourced function persists after the function
  returns and may affect unrelated shell commands.

### TODO: Support Gemini browser login without host networking

Find an isolated way for Gemini CLI's localhost OAuth callback to reach the
container.

Open questions:

- Can Gemini CLI use a fixed callback port that can be published only on
  `127.0.0.1`?
- Will Gemini CLI support a device-code or other headless login flow?

Notes:

- The current Gemini wrapper requires `GEMINI_API_KEY`.
- Avoid using Docker host networking so the container remains isolated.

### TODO: Standardize Docker wrapper calls

Replace the duplicated tool-specific Docker commands with a shared wrapper
that accepts tool-specific configuration.

Open questions:

- Where should image names, home volumes, container users, ports, environment
  variables, and CLI arguments be defined?
- How should Bash sourceable functions and Zsh autoload functions call the
  shared implementation?
- Can a new tool be added through configuration without creating another pair
  of wrapper files?

Notes:

- Preserve the existing `codex`, `copilot`, and `gemini` shell commands.
- Keep tool-specific exceptions explicit and easy to audit.
- Avoid introducing a runtime dependency beyond the existing shell tooling.

### TODO: Support per-project persistent home volumes

Allow each tool to optionally use a persistent home volume dedicated to the
current project so sessions, history, configuration, and other tool state do
not leak between projects.

Open questions:

- Should per-project volumes be the default or an opt-in isolation mode?
- How should a stable, collision-resistant volume name be derived from the
  project's canonical path?
- Can authentication be shared separately without also sharing sessions and
  other project-sensitive state?
- How should volumes remain associated with projects that are moved or renamed?

Notes:

- The current setup shares one named home volume across every project for each
  tool: `codex-home`, `copilot-home`, and `gemini-home`.
- Codex and Gemini already associate resumable sessions with working
  directories inside their shared home volumes, but the underlying volume is
  still accessible from every instance of that tool.
- Per-project volumes would preserve context indefinitely until the volume is
  explicitly removed, but may require authenticating once per project.
