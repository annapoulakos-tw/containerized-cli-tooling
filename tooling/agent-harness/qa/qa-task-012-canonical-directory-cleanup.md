# QA: task-012-canonical-directory-cleanup

Status: PASS

## Scope Reviewed

- `/workspace/tooling/agent-harness/tasks/task-012-canonical-directory-cleanup.md`
- `/workspace/tooling/agent-harness/specs/spec-012-canonical-directory-cleanup.md`
- `/workspace/agentic-harness/canonical/`
- `/workspace/agentic-harness/build.sh`
- `/workspace/agentic-harness/tests/`
- generated `/workspace/agentic-harness/build/`

Note: `/home/codex/.codex/agent-harness/packets/review-task.md` was requested but does not exist in this environment; no `review-task.md` packet was found under `/home/codex`.

## Acceptance Criteria

PASS: `canonical/agents/` exists and contains the promoted workflow agent definition files:

- `audit-spec.md`
- `code-task.md`
- `create-spec.md`
- `implement-spec.md`
- `research-spec.md`
- `review-spec.md`
- `review-task.md`
- `update-spec.md`

PASS: deprecated canonical source directories are absent:

- `canonical/packets/`
- `canonical/commands/`
- `canonical/schemas/`
- `canonical/templates/`

PASS: obsolete pre-existing nested `canonical/agents/<role>/AGENTS.md` content is removed from the on-disk canonical tree.

PASS: `canonical/bootstrap/BOOTSTRAP.md` is removed and `canonical/bootstrap/AGENTS.md` is self-contained. It includes the bootstrap entry point, artifact-root guidance, agent-definition loading from `agents/`, model delegation rules, task delegation matrix, `spec-implementer` offload and substitution constraints, required-role unavailable handoff behavior, and the cost guardrail requiring active role, required next role, and command or user action.

PASS: canonical top-level entries are exactly the approved structure:

- `agents`
- `bootstrap`
- `build-strategy.md`
- `skills`
- `state`
- `strategy.md`
- `tool-profiles`

PASS: `build.sh` supports the new layout, renders `canonical/agents/*.md` into `build/{tool}/agents/`, renders `canonical/bootstrap/AGENTS.md` into each managed `build/{tool}/AGENTS.md`, and removes the managed `build/{tool}` target before writing.

PASS: generated build output contains no stale `packets`, `commands`, `schemas`, `templates`, or `BOOTSTRAP.md` entries after the build.

PASS: `create-spec.md` directs new specs to `/workspace/tooling/agent-harness/specs/` through the rendered artifact root and no longer uses the singular `/spec/` contract.

PASS: generated `AGENTS.md` content uses agent terminology and `agents/` paths instead of packet terminology and `packets/` paths.

PASS: tests were updated for the new layout, merged bootstrap behavior, stale-output cleanup, and repeatability.

## Verification

Commands run:

- `/workspace/agentic-harness/tests/build-packets.sh` - PASS
- `/workspace/agentic-harness/tests/build-copilot-bootstrap.sh` - PASS
- `/workspace/agentic-harness/tests/context-budget-rules.sh` - PASS
- `/workspace/agentic-harness/tests/anti-overengineering-guidance.sh` - PASS

Additional inspection:

- Confirmed canonical removed directories and `BOOTSTRAP.md` are absent.
- Confirmed generated build trees do not contain removed directory names or stale `BOOTSTRAP.md`.
- Confirmed repeatability is covered by `build-packets.sh` checksum comparison after a second build.

## Minimality

PASS: Implementation is scoped to the approved areas: `agentic-harness/canonical/`, `agentic-harness/build.sh`, and `agentic-harness/tests/`. No implementation changes were observed outside the allowed task scope.

PASS: The build cleanup is simple and direct: removing the managed `build/{tool}` directory before rendering avoids stale mounted content without adding unnecessary abstractions.

## Result

PASS: The implementation satisfies the task and spec acceptance criteria reviewed here.
