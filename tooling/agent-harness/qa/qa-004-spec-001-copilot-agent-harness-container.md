# QA Review qa:004: spec:001 Copilot Agent Harness Container Support

## Scope

Full-spec QA and audit for spec:001

## Result

Pass

## Scope Instruction

Existing Rovo and Makefile changes are accepted external context per user instruction and were not evaluated as part of the Copilot harness delta.

## Verification

* Copilot harness build support exists and produces `build/copilot`.
* Bash and Zsh wrappers refresh the harness build when tooling is available.
* Bash and Zsh wrappers mount `build/copilot` read-only at `/home/copilot/.copilot/agent-harness`.
* The harness mount does not target `/workspace/AGENTS.md`.
* Codex harness path remains documented as `/home/codex/.codex/agent-harness`.
* README documents the Copilot mount path and manual verification commands.
* Non-goals were respected; no automatic Copilot discovery, harness workflow redesign, daemon, or auth change was added as part of the Copilot harness delta.

## Commands Run

```sh
bash /workspace/tests/ai-cli-harness-smoke.sh
bash /workspace/agentic-harness/build.sh copilot
bash -n /workspace/shell-functions/ai-cli.sh /workspace/tests/ai-cli-harness-smoke.sh
```

## Independent Audit

The scoped spec auditor reported PASS with no blocking findings.

## Status

Complete
