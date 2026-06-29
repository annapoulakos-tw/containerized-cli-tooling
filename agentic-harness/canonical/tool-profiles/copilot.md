# Tool Profile: Copilot

Copilot needs smaller prompts than the full harness bundle for routine workflow execution.

Copilot needs repeated harness-root anchors so it consistently uses `/home/copilot/.copilot/agent-harness` as the harness root.

Copilot needs explicit artifact-root rules so runtime specs, plans, tasks, research, QA, audits, and completion reports stay under `/workspace/tooling/agent-harness`.

Copilot should use one role packet per workflow. Load the packet for the active workflow from `packets/`, then load only the focused context that packet requires.
