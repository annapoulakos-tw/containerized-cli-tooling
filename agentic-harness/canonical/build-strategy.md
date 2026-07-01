# Build Strategy

## Purpose

This document defines how canonical harness definitions are prepared for specific AI CLI tools.

The canonical directory is the source of truth.

The build directory contains tool-specific outputs derived from canonical files.

---

# Source of Truth

All durable harness definitions live in:

```text
canonical/
```

This includes:

* agents
* skills
* state
* strategy

Files under `canonical/` should be edited by humans.

---

# Build Outputs

Tool-specific files live in:

```text
build/
```

Examples:

```text
build/codex/
build/copilot/
```

Files under `build/` may be generated, copied, or manually refreshed from canonical files.

The build directory is not the source of truth.

Workflow-specific agent definitions live under:

```text
build/<tool>/agents/
```

Agent definitions are generated or copied from canonical harness definitions. They are smaller instruction files for one workflow and do not replace the generated `AGENTS.md` bootstrap.

---

# Goal

The goal is to support multiple AI CLI tools without rewriting the harness for each tool.

Each tool-specific build should expose the same conceptual harness:

* same agents
* same skills
* same artifact contracts
* same state machine

The format may differ by tool.

The behavior should remain consistent.

---

# Conceptual Mapping

## Canonical

```text
canonical/agents/*
canonical/skills/*
canonical/state/*
```

## Codex Build

```text
build/codex/AGENTS.md
build/codex/agents/*.md
build/codex/skills/*/SKILL.md
```

## Copilot Build

```text
build/copilot/AGENTS.md
build/copilot/agents/*.md
build/copilot/tool-profile.md
```

The Copilot tool profile is copied from canonical Copilot-specific source files.

---

# Initial Build Approach

The first version may be manual.

For Codex:

1. Create `build/codex/AGENTS.md`.
2. Copy workflow agent definitions into `build/codex/agents/`.
3. Copy each canonical skill into `build/codex/skills/<skill-name>/SKILL.md`.

For Copilot:

1. Create `build/copilot/AGENTS.md`.
2. Copy workflow agent definitions into `build/copilot/agents/`.
3. Copy the Copilot tool profile into `build/copilot/tool-profile.md`.
4. Copy each canonical skill into `build/copilot/skills/<skill-name>/SKILL.md`.

---

# Later Build Approach

A future build script may:

1. Read canonical files.
2. Validate required files exist.
3. Render `canonical/bootstrap/AGENTS.md` into tool-specific `AGENTS.md`.
4. Copy workflow agent definitions into tool-specific agent directories.
5. Copy skills into tool-specific skill directories.

The script should be simple and deterministic.

No complex framework is required.

---

# Build Rules

## Canonical Files

Canonical files should be:

* tool-agnostic
* reusable
* explicit
* readable as standalone markdown

## Build Files

Build files may be:

* tool-specific
* concatenated
* reorganized
* simplified

Build files must not introduce new behavior that does not exist in canonical files.

---

# What CLI Tools See

When running inside a sandbox container, the CLI tool should be given access to the appropriate build directory.

Example:

```text
/mnt/agent-kit/build/codex/
```

or:

```text
/mnt/agent-kit/build/copilot/
```

The exact mount location may vary.

The CLI tool does not need to know about the canonical directory.

---

# Runtime Usage

The user invokes the CLI tool normally.

Examples:

```text
/spec create a manifest generator
/implement spec:001
```

The tool should interpret those slash commands using the mounted build instructions.

The build files are the instructions that teach the CLI tool what those commands mean.

---

# Non-Goals

The build strategy does not:

* Define agent behavior.
* Define skill behavior.
* Define artifact schemas.
* Run implementation work.
* Execute tests.
* Manage git.
* Provide orchestration by itself.

It only defines how harness instructions are packaged for tool-specific use.

---

# First Milestone

The first milestone is not automation.

The first milestone is proving that one tool can use one generated or manually assembled build directory to complete a small spec-driven workflow.

Recommended first target:

```text
build/codex/
```

Recommended first test:

```text
/spec create a tiny Python file manifest tool
/implement spec:001
```

Evaluate whether the tool:

* creates a valid spec
* creates a reasonable implementation plan
* creates small tasks
* follows assigned skills
* respects sandbox limits
* provides external verification instructions when needed
