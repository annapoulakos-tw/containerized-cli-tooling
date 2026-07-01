# Task

Task: `task-012-canonical-directory-cleanup`

Spec: `spec-012-canonical-directory-cleanup`

Role: `task-coder`

Status: QA Passed

# Objective

Implement the approved canonical directory cleanup and build changes for spec 012.

# Scope

You may update:

- `agentic-harness/canonical/`
- `agentic-harness/build.sh`
- `agentic-harness/tests/`

Do not update specs, plans, QA reports, audit reports, or completion reports.

# Requirements

- Replace `canonical/packets/` with `canonical/agents/` containing the agent definition markdown files formerly in `canonical/packets/`, including `audit-spec.md`.
- Remove deprecated canonical directories: `agents`, `commands`, `schemas`, and `templates`, replacing the old `agents` content with the promoted workflow agent definition files.
- Merge `canonical/bootstrap/BOOTSTRAP.md` into `canonical/bootstrap/AGENTS.md`.
- Remove `canonical/bootstrap/BOOTSTRAP.md`.
- Ensure the resulting canonical top-level entries include `agents/`, `bootstrap/`, `skills/`, `state/`, `tool-profiles/`, `build-strategy.md`, and `strategy.md`.
- Update `build.sh` for the new canonical layout.
- Ensure `build.sh` copies `canonical/bootstrap/AGENTS.md` into each managed `build/{TOOL}/AGENTS.md` file.
- Ensure `build.sh` removes any existing build folders or files it will touch before writing them, so stale mounted content cannot remain.
- Correct `create-spec.md` output contract so new spec artifacts go to `/workspace/tooling/agent-harness/specs/`.
- Update final `AGENTS.md` content to use agent terminology and `agents/` paths instead of packet terminology and `packets/` paths.
- Add model delegation rules to final `AGENTS.md`.
- Add a task delegation matrix to final `AGENTS.md` that maps workflow needs to required predefined agents, optional subagents, and handoff conditions.
- State that `spec-implementer` must offload subtasks according to the matrix and must not substitute itself for predefined agents.
- Add the cost guardrail: if the active model begins reasoning about bypassing role boundaries, it must stop immediately and report the active role, required next role, and command or user action needed.
- State that if a required role is unavailable, the active model must stop and hand off.
- Update tests so they validate the new `agents/` layout, merged bootstrap behavior, clean build output, and repeatability.

# Verification

Run the relevant harness tests, including:

- `agentic-harness/tests/build-packets.sh`
- `agentic-harness/tests/build-copilot-bootstrap.sh`
- `agentic-harness/tests/context-budget-rules.sh`
- `agentic-harness/tests/anti-overengineering-guidance.sh`

Record the commands and results in this task artifact.

## Verification Results

- `/workspace/agentic-harness/tests/build-packets.sh` - PASS
- `/workspace/agentic-harness/tests/build-copilot-bootstrap.sh` - PASS
- `/workspace/agentic-harness/tests/context-budget-rules.sh` - PASS
- `/workspace/agentic-harness/tests/anti-overengineering-guidance.sh` - PASS
- `/workspace/agentic-harness/tests/build-packets.sh && /workspace/agentic-harness/tests/build-copilot-bootstrap.sh && /workspace/agentic-harness/tests/context-budget-rules.sh && /workspace/agentic-harness/tests/anti-overengineering-guidance.sh` - PASS
