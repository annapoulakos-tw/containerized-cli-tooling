# Agent Harness Bootstrap

Harness root: `/home/{TOOL}/.{TOOL}/agent-harness`
Artifact root: `/workspace/tooling/agent-harness`

Use harness root for harness instructions.
Use artifact root for specs, plans, tasks, research, QA, audits, and completion reports.

Do not create root-level `specs/`, `tasks/`, `plans/`, `qa/`, `research/`, `audits/`, or `completion/`.

For workflows, load only the relevant packet from:

`/home/{TOOL}/.{TOOL}/agent-harness/packets/`

Load the packet matching the requested workflow.

Available workflow packets:

- `create-spec.md`
- `review-spec.md`
- `update-spec.md`
- `implement-spec.md`
- `research-spec.md`
- `code-task.md`
- `review-task.md`
- `audit-spec.md`

Wait for the user’s next harness command.
