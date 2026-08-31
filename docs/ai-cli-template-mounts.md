# `ai-cli` Handoff — Workbench Template Mount Contract

## Purpose

Add a small, opt-in extension to `containerized-cli-tooling`'s `ai-cli` launcher so that a
Workbench-managed agent session can receive canonical instruction templates without modifying the
host worktree.

This is part of ai-teams Milestone 18. It does **not** ask `ai-cli` to take ownership of Docker
image builds, container lifecycle, plugin installation, or the external agent harness. Continue
using the existing launcher behavior for all of those concerns.

## Desired behavior

When ai-teams starts a built-in Codex or Copilot agent through `ai-cli`, it will set these optional
environment variables to absolute paths owned and validated by the Workbench:

```text
AI_TEAM_MANAGED=1
AI_TEAM_PROJECT_TEMPLATE_PATH=/absolute/path/to/templates/PROJECT.md
AI_TEAM_COPILOT_INSTRUCTIONS_PATH=/absolute/path/to/templates/copilot/.github/copilot-instructions.md
```

When `AI_TEAM_MANAGED=1`, `ai-cli` should add read-only file bind mounts to the Docker invocation:

```text
<AI_TEAM_PROJECT_TEMPLATE_PATH> -> /workspace/PROJECT.md
<AI_TEAM_COPILOT_INSTRUCTIONS_PATH> -> /workspace/.github/copilot-instructions.md
```

The project template applies to supported Workbench-managed agent tools. The Copilot instruction
file applies only when `tool=copilot`. Codex and Copilot are the only tools covered by this
contract. All behavior added by this contract must remain gated behind `AI_TEAM_MANAGED=1`.

These variables configure the launcher only. They do not need to be propagated into the agent
container; the Workbench provides its own environment propagation mechanism.

The host project is already bind-mounted at `/workspace`; these are intentional nested mounts that
override the corresponding path only inside the running agent container. They must never write,
create, rename, or delete files in the host worktree.

## Required launcher changes

Update both maintained launcher entrypoints so they stay behaviorally equivalent:

- `shell-functions/ai-cli.sh`
- `zsh-autoload-funcs/ai-cli`

Add the optional mounts after the existing project bind mount has been configured and before the
final `docker run`.

### Validation rules

For each non-empty `AI_TEAM_*_PATH` value:

1. Honor it only when `AI_TEAM_MANAGED=1`; ordinary manual `ai-cli` use must remain unchanged.
2. Require an absolute path to a readable regular file. Reject a missing path, directory, symlink,
   or unreadable source with an actionable error before invoking Docker.
3. Reject the source if its final path component is a symlink. Canonicalize its parent directory
   physically (equivalent to `cd -P -- "$parent" && pwd`), then recombine that canonical parent
   with the original filename before constructing the Docker argument. Symlinks in ancestor
   directories are therefore resolved and accepted.
4. Use Docker's `--mount` argument form and include `readonly`.
5. Do not log file contents, authentication values, or other secret environment values.

If any applicable, non-empty template variable fails source validation, fail the entire managed
launch before the final Docker invocation. The Copilot-specific variable is applicable only when
`tool=copilot` and is ignored for Codex. If Docker rejects an otherwise valid mount at runtime,
allow the managed launch to fail; do not retry with a partial template configuration.

The launcher can trust the Workbench to ensure the source belongs to its asset root; it should
still validate file type and readability because it remains a general local entrypoint.

### Copilot destination-parent check

During the separate real-container verification, test the behavior when the mounted worktree does
and does not contain `.github/`.

- If Docker supports the nested file target without a pre-existing parent, retain the direct
  read-only mount.
- If Docker requires the parent directory, do **not** create `.github/` in the host worktree.
  Instead, fail the managed Copilot launch with a clear message that reports the exact
  prerequisite. Do not invoke the final Docker launch with only a partial template configuration.

Do not mount an entire generated `.github` directory: that could hide repository-owned GitHub
configuration in the container.

## Non-goals

- No changes to the existing shared-skill mount from `~/.agents/skills`; that already carries
  Workbench-installed `wb-*` skills.
- No `docker cp`, post-start file provisioning, or writable template mounts.
- No project-worktree file copy, merge, initialization, or overwrite behavior.
- No changes to normal un-managed `ai-cli` calls.
- No native Agent Plugins 1.0 installer or provider-specific plugin bootstrap.
- No changes to the external agent-harness build/mount behavior.

## Test requirements

Extend the existing `tests/ai-cli-harness-smoke.sh` fake-Docker coverage to assert:

1. A managed Codex launch with a valid project template adds the exact read-only
   `/workspace/PROJECT.md` mount.
2. A managed Copilot launch with both valid files adds both exact read-only mounts.
3. An unmanaged Codex or Copilot launch adds neither mount even when the environment variables
   are present.
4. Missing, directory, symlink, relative, and unreadable template paths fail before the final
   Docker launch and explain which variable is invalid. The unreadable-source case may be skipped
   when the tests run with privileges that make the permission check ineffective.
5. Existing shared-skill, authentication, state-volume, labels, command, and harness assertions
   remain unchanged.
6. Bash and Zsh launcher sources both have static assertions covering the same mount contract.

As a separate, non-blocking follow-up, run a manual smoke check on the developer host with a real
supported container:

1. Create a disposable worktree with no `PROJECT.md`; launch a managed agent and confirm the
   container sees the mounted template while the host worktree remains unchanged.
2. Repeat for Copilot with and without `.github/`; document the observed destination-parent
   behavior.
3. Confirm `docker inspect` reports the mounts read-only.
4. Exit the agent and confirm no template files were created in the worktree.

## Completion criteria

- The two launcher entrypoints accept the documented variables only for Workbench-managed runs.
- Valid templates appear at the intended container paths as read-only mounts.
- Invalid sources fail safely and do not start an incorrectly configured container.
- Existing manual `ai-cli` behavior remains unchanged.
- The result is covered by automated fake-Docker tests. Real local Codex/Copilot verification is
  tracked separately and is not required to ship the launcher change.

## ai-teams follow-up

After this launcher work is available, ai-teams will resolve its installed canonical assets and set
the variables only for its built-in `AgentTool::Codex` and `AgentTool::Copilot` launch path.
Custom agent commands such as `make copilot` remain outside this contract.
