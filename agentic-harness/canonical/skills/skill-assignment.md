# Skill Assignment

## Purpose

This document defines which reusable skills are applied to each agent by default and which skills may be added based on repository context.

Skills are behavior modifiers. Agents define roles and workflows. Skills define reusable constraints, preferences, and operating rules.

---

# Core Rules

1. Agents should use only the skills relevant to their role.
2. Skills should remain small and composable.
3. Task-specific skills may be added by the spec-implementer.
4. Repository-specific skills should be selected based on the files, tools, and conventions present.
5. If a skill conflicts with the spec, the spec takes precedence.
6. If a skill conflicts with sandbox limits, sandbox limits take precedence.

---

# Default Agent Skills

## spec-creator

```text
outcome-driven
```

The spec-creator should focus on desired outcomes, acceptance criteria, constraints, and non-goals.

---

## spec-implementer

```text
outcome-driven
repo-awareness
sandbox-awareness
```

The spec-implementer should plan work around the spec, repository reality, and sandbox limitations.

---

## spec-researcher

```text
repo-awareness
sandbox-awareness
dependency-minimization
```

The spec-researcher should prefer repository-local evidence, account for environment limits, and avoid recommending unnecessary dependencies.

---

## task-coder

```text
tdd
minimal-code
outcome-driven
repo-awareness
sandbox-awareness
human-verification-loop
dependency-minimization
```

The task-coder should implement small verified changes while respecting the sandbox and avoiding unnecessary dependencies.

---

## qa-reviewer

```text
outcome-driven
repo-awareness
sandbox-awareness
human-verification-loop
```

The qa-reviewer should evaluate observable behavior and distinguish between agent-verified, user-verified, and unverified results.

---

## spec-auditor

```text
outcome-driven
repo-awareness
```

The spec-auditor should verify alignment between the approved spec and delivered outcome.

---

# Context Skills

The spec-implementer may add context skills when creating or assigning tasks.

## Python

Apply when the task modifies Python code, Python tests, Python packaging, or Python tooling.

```text
python-style
```

---

## Rust

Apply when the task modifies Rust code, Cargo configuration, Rust tests, or Rust tooling.

```text
rust-style
```

---

## Shell

Apply when the task modifies shell scripts or command-line automation.

```text
shell-style
```

---

## Infrastructure

Apply when the task modifies infrastructure-as-code or operational automation.

Examples include:

* Ansible
* Terraform
* Packer
* cloud-init
* systemd units
* deployment scripts
* provisioning scripts

```text
infra-style
```

---

# Skill Selection Rules

## For Specs

When creating or revising a spec, prefer:

```text
outcome-driven
```

Do not attach implementation-specific skills unless they are explicit constraints.

---

## For Implementation Plans

When creating an implementation plan, prefer:

```text
outcome-driven
repo-awareness
sandbox-awareness
dependency-minimization
```

Add context skills only when they materially affect task planning.

---

## For Coding Tasks

Every coding task should include:

```text
tdd
minimal-code
outcome-driven
repo-awareness
sandbox-awareness
human-verification-loop
dependency-minimization
```

Then add one or more context skills based on the task.

Example:

```text
Python task:
- tdd
- minimal-code
- outcome-driven
- repo-awareness
- sandbox-awareness
- human-verification-loop
- dependency-minimization
- python-style
```

---

## For QA Reviews

Every QA review should include:

```text
outcome-driven
repo-awareness
sandbox-awareness
human-verification-loop
```

Add context skills only when they help evaluate conventions or likely regressions.

---

# Conflict Rules

## Spec vs Skill

If the spec explicitly requires behavior that conflicts with a skill, follow the spec and record the conflict.

## Sandbox vs Skill

If a skill requires an action unavailable in the sandbox, follow sandbox-awareness and record the limitation.

## Repository Convention vs Style Skill

If repository conventions conflict with a language style skill, follow the repository convention.

Example:

```text
Existing Python code does not strictly follow PEP 8.
```

In that case, prefer consistency with the surrounding code over introducing unrelated style churn.

---

# Non-Goals

Skill assignment does not:

* Define agent responsibilities.
* Define artifact schemas.
* Define command behavior.
* Override the spec.
* Override sandbox restrictions.
* Require all skills to be used on every task.

---

# Review Guidance

When behavior seems inconsistent, check in this order:

1. Spec
2. State machine
3. Command contract
4. Agent definition
5. Assigned skills
6. Repository conventions
7. General style preferences
