# Research research:003: Self-Contained Role Packet Roots and Chained Reads

## Request

Identify supported tool harness roots, runtime artifact roots, and existing packet text that depends on chained reads of harness command, agent, schema, template, skill, or state files.

## Context

Parent spec: spec:008. Role packets must be executable for normal delegated-agent workflows without reading other harness instruction files. Tool-specific generated packets must include the relevant tool harness root and artifact root.

## Findings

* `shell-functions/ai-cli.sh` and `zsh-autoload-funcs/ai-cli` mount generated harness builds at `/home/${tool}/.${customization_base}/agent-harness`.
* `customization_base` is the tool name for `codex`, `copilot`, and `gemini`.
* `rovo` uses `customization_base=rovodev`, so its harness root is `/home/rovo/.rovodev/agent-harness`.
* Supported tool harness roots are:
  * `codex`: `/home/codex/.codex/agent-harness`
  * `copilot`: `/home/copilot/.copilot/agent-harness`
  * `gemini`: `/home/gemini/.gemini/agent-harness`
  * `rovo`: `/home/rovo/.rovodev/agent-harness`
* Runtime harness artifacts are written under `/workspace/tooling/agent-harness`, per `agentic-harness/canonical/strategy.md`, `agentic-harness/README.md`, and prior spec:002.
* The `/home/{TOOL}/.{TOOL}/agent-harness`-style path is the tool-specific harness root, not the runtime artifact root used for specs, plans, tasks, research, QA, audits, and completion reports.
* Existing canonical packet context budgets directly referenced chained harness reads:
  * `commands/spec.md`
  * `commands/implement.md`
  * `agents/spec-creator/AGENTS.md`
  * `agents/spec-implementer/AGENTS.md`
  * `schemas/spec.schema.md`
  * `templates/spec.md`
  * `state/state-machine.md`
  * required skills
* Existing generated packets are copied from canonical packets without tool-specific root injection.

## Recommendation

Render packets per tool during `build.sh` instead of copying them verbatim. Add a packet header with the tool-specific harness root and `/workspace/tooling/agent-harness` artifact root. Rewrite packet content so context budgets and workflow rules inline the minimum executable artifact formats, lifecycle rules, and skill guidance instead of instructing normal delegated agents to read other harness files.

## Alternatives Considered

* Keep copying canonical packets unchanged and rely on `AGENTS.md` for roots. Rejected because tool-specific packets must contain roots directly.
* Put full command, agent, schema, template, state, and skill files into each packet. Rejected because packets should stay minimal and focused.

## Risks

* If wrapper mount conventions change, generated root values must be updated with verification.
* Negative grep tests can miss indirect wording unless they check both known paths and normal-execution read instructions.

## Confidence

High

## Status

Complete
