# Identifier

spec-012-canonical-directory-cleanup

# Title

Canonical Directory Cleanup

# Summary

Clean up the `canonical/` source layout by removing deprecated directories, promoting workflow agent definitions into the `agents/` directory, consolidating bootstrap instructions, and ensuring the build process produces clean mounted output.

# Outcome

The canonical source tree no longer contains the deprecated `agents`, `commands`, `schemas`, or `templates` directories, the existing workflow agent definition content is available under `canonical/agents/`, bootstrap instructions are consolidated into `canonical/bootstrap/AGENTS.md`, and `build.sh` reliably produces a clean `build/` output for every directory or file it manages.

# Context

`canonical/bootstrap/AGENTS.md` is the source of truth for bootstrap behavior. `build.sh` copies that file into each `build/{TOOL}/AGENTS.md` file used during build and container startup phases. The final generated `AGENTS.md` files must reflect the directory rename from workflow agent source files to agent definitions and must preserve role boundaries during model delegation.

# Acceptance Criteria

- `canonical/agents/` contains the agent definition files previously provided by `canonical/packets/`, including workflow files such as `audit-spec.md`.
- `canonical/packets/` no longer exists after the cleanup.
- `canonical/commands/`, `canonical/schemas/`, and `canonical/templates/` no longer exist after the cleanup.
- The obsolete pre-existing `canonical/agents/` directory content is removed before the workflow agent definition content is promoted into `canonical/agents/`.
- `canonical/bootstrap/AGENTS.md` contains the bootstrap entry point instructions and the effective content previously provided by `canonical/bootstrap/BOOTSTRAP.md`.
- `canonical/bootstrap/BOOTSTRAP.md` no longer exists after its content is merged into `canonical/bootstrap/AGENTS.md`.
- The resulting canonical structure includes these top-level entries: `agents/`, `bootstrap/`, `skills/`, `state/`, `tool-profiles/`, `build-strategy.md`, and `strategy.md`.
- `build.sh` supports the new canonical layout and builds the expected output without referencing removed canonical directories.
- `build.sh` copies `canonical/bootstrap/AGENTS.md` into each managed `build/{TOOL}/AGENTS.md` file.
- Before `build.sh` writes any managed folder or file under `build/`, it removes the existing target so stale mounted content cannot remain.
- Running `build.sh` from a clean checkout succeeds.
- Running `build.sh` twice in a row succeeds and produces the same managed `build/` layout on the second run.
- `create-spec.md` has a corrected output contract that consistently directs new spec artifacts to `/workspace/tooling/agent-harness/specs/`.
- The final `AGENTS.md` refers to workflow agent definitions in the `agents/` directory instead of workflow packets in the `packets/` directory.
- The final `AGENTS.md` replaces packet terminology with agent terminology wherever the renamed files are referenced.
- The final `AGENTS.md` includes model delegation rules that define how active roles hand work to required agents or subagents.
- The final `AGENTS.md` includes a task delegation matrix that maps workflow needs to required predefined agents, optional subagents, and the condition under which each handoff is required.
- The final `AGENTS.md` states that the `spec-implementer` agent must offload work for subtasks according to the task delegation matrix.
- The final `AGENTS.md` states that the `spec-implementer` agent must not substitute itself for one of the predefined agents when that predefined agent is required.
- The final `AGENTS.md` includes a cost guardrail that requires the active model to stop immediately if it begins reasoning about bypassing role boundaries.
- The cost guardrail requires the active model to report the active role, the required next role, and the command or user action needed to continue.
- The final `AGENTS.md` requires the active model to stop and hand off when a required role is unavailable.

# Assumptions

- Confirmed assumption: `skils/` in the example output is intended to mean `skills/`; the desired canonical directory is `canonical/skills/`.
- Structural assumption: the cleanup applies to the canonical source tree and any build output generated from it.
- Bootstrap assumption: merging `BOOTSTRAP.md` into `AGENTS.md` means `canonical/bootstrap/AGENTS.md` becomes self-sufficient for bootstrap behavior.
- Build assumption: `build.sh` owns only the build paths it currently generates or will generate from canonical sources.
- Harness artifact assumption: `specs/` is the canonical directory for spec artifacts; singular `spec/` paths are invalid.
- Terminology assumption: after the rename, files formerly described as workflow source files should be described as agent definitions.
- Delegation assumption: predefined workflow agents remain authoritative for their roles after the directory rename.

# Constraints

- The change must not create root-level harness artifact directories such as `specs/`, `tasks/`, `plans/`, `qa/`, `research/`, `audits/`, or `completion/`.
- The spec defines desired behavior only and does not prescribe implementation details.
- Cleanup must preserve the workflow agent definition content when moving it into `canonical/agents/`.
- Build cleanup must avoid deleting unmanaged files outside the build paths controlled by `build.sh`.
- Role and delegation instructions must be represented in the final `AGENTS.md` without weakening predefined agent responsibilities.
- The task delegation matrix must be limited to role handoff and delegation behavior; it must not become an implementation plan for this spec.

# Non Goals

- Redesigning the agent harness workflow model is out of scope.
- Changing the contents or semantics of individual workflow agent definition files is out of scope except as required by the directory rename.
- Adding new commands, schemas, templates, skills, or tool profiles is out of scope.
- Changing generated artifact locations under `/workspace/tooling/agent-harness` is out of scope.
- Redefining the responsibilities of existing predefined agents is out of scope except to clarify delegation and handoff requirements.

# Status

Approved
