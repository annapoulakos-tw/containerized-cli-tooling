# TODOs

### TODO: Resolve container user IDs

Use a consistent approach for mapping host and container user IDs so files
created in mounted projects have the expected ownership.

Open questions:

- Should image builds accept the host UID and GID as build arguments?
- Should the wrappers set the runtime UID and GID instead?
- Why does the Copilot image require UID and GID `1001` while Codex works
  without an explicit value?

Notes:

- Any solution must continue to work with the named home volumes.
- Fix and test the behavior for both Codex and Copilot.

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
