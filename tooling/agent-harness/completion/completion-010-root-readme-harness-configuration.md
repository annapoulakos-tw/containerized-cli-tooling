# Completion Report completion:010: Root README Harness Configuration

## Spec

spec:010

## Result

Complete

## Summary

The root README Agent Harness section now tells users to configure the harness with the current single generated-entrypoint prompt, `Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md.` The old manual harness-root and acknowledgement lines were removed while preserving the existing `{TOOL}` guidance, wrapper refresh explanation, and stable mount paths.

## Completed Tasks

* task:011 - Update root README Agent Harness prompt

## Verification

```sh
sed -n '112,145p' README.md
git diff -- README.md tooling/agent-harness/plans/plan-010-root-readme-harness-configuration.md tooling/agent-harness/tasks/task-011-root-readme-harness-configuration.md
grep -n "Use /home/{TOOL}/.{TOOL}/agent-harness as the harness root\|Acknowledge loaded and wait\|Read /home/{TOOL}/.{TOOL}/agent-harness/AGENTS.md" README.md
```

## QA And Audit

* qa:task:011 passed task QA.
* audit:spec:010 passed final audit.

## Known Follow-Up Work

* None

## Session Metrics

- Tool: Codex
- Token usage: total=88,225 input=80,094 (+ 584,448 cached) output=8,131 (reasoning 1,537)

## Status

Complete
