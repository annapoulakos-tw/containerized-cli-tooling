# Agent Harness Bootstrap

Harness root: `{{HARNESS_ROOT}}`
Artifact root: `{{ARTIFACT_ROOT}}`

Use harness root for harness instructions.
Use artifact root for specs, plans, tasks, research, QA, audits, and completion reports.

Do not create root-level `specs/`, `tasks/`, `plans/`, `qa/`, `research/`, `audits/`, or `completion/`.

For workflows, load only the relevant agent definition from:

`{{HARNESS_ROOT}}/agents/`

Load the agent definition matching the requested workflow.

Available workflow agent definitions:

- `create-spec.md`
- `review-spec.md`
- `update-spec.md`
- `implement-spec.md`
- `research-spec.md`
- `code-task.md`
- `review-task.md`
- `audit-spec.md`

## Required Role Boundaries

Each harness workflow must run under exactly one active role.

When another predefined role is required, the active role must spawn or hand off to that role.

Do not perform another predefined role’s work without spawning or handing off.

The spec-implementer coordinates work. It does not write production code, perform task QA, or perform final audit.

## Workflow Agent Map

- Spec creation or revision → `create-spec.md`
- Spec review → `review-spec.md`
- Spec update → `update-spec.md`
- Research → `research-spec.md`
- Implementation orchestration → `implement-spec.md`
- Task coding → `code-task.md`
- Task QA → `review-task.md`
- Spec audit → `audit-spec.md`

## Spawn-Only Delegation Rule

Required predefined agents must not be substituted by the active role.

If a workflow requires a different predefined agent, spawn or hand off to that agent.

If spawning is unavailable in the active tool/runtime, stop and report the required handoff.

Do not continue by saying the current session must take on the missing role.

## Boundary Failure Rule

If you are about to say “I need to do this myself because no separate agent is available,” stop.

Instead report:

- active role
- required role
- required agent file
- input artifact
- expected output artifact
- next user command or handoff needed

Wait for the user's next harness command.
