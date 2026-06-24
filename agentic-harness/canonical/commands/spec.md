# Command: /spec

# Invocation

Preferred portable form:

harness spec <arguments>

Legacy conceptual form:

/spec <arguments>

## Purpose

Create, revise, review, or approve a specification.

The `/spec` command is the primary entry point for defining work.

A specification describes the desired outcome, acceptance criteria, constraints, and scope of a piece of work.

Specifications are created and maintained by the spec-creator agent.

---

# Inputs

The command accepts one of the following forms.

## Create Spec

```text
/spec <description>
```

Examples:

```text
/spec create a manifest generator
/spec add authentication to the API
/spec support recursive directory traversal
```

If no existing spec is referenced, a new spec should be created.

New spec artifacts must be written under:

```text
tooling/agent-harness/specs/
```

---

## Revise Spec

```text
/spec spec:<id> revise <changes>
```

Examples:

```text
/spec spec:001 revise add support for symlinks
/spec spec:002 revise remove upload functionality
```

The existing spec should be updated while preserving history.

The referenced spec must be resolved only from:

```text
tooling/agent-harness/specs/
```

If the spec is not found there, stop with a clear not-found error. The workflow does not fall back to root-level `specs/`.

---

## Review Spec

```text
/spec spec:<id>
```

Displays the current spec and identifies:

* Open questions
* Missing acceptance criteria
* Schema violations
* Approval readiness

The referenced spec must be resolved only from `tooling/agent-harness/specs/`.
If the spec is not found there, stop with a clear not-found error. The workflow does not fall back to root-level `specs/`.

---

## Approve Spec

```text
/spec spec:<id> approve
```

Approves the spec for implementation.

A spec may only be approved when:

* Required fields are present.
* Acceptance criteria exist.
* No blocking open questions remain.
* The spec passes schema validation.

The referenced spec must be resolved only from `tooling/agent-harness/specs/`.
If the spec is not found there, stop with a clear not-found error. The workflow does not fall back to root-level `specs/`.

## Hard Stop

The `/spec` command must stop after creating, revising, reviewing, or approving a spec.

The `/spec` command must not:

- create implementation plans
- create tasks
- write code
- run QA
- run audit
- create completion reports
- invoke `/implement`
- continue into implementation automatically

After creating or revising a spec, the command must report the spec path and status, then stop.

Implementation may only begin after a separate explicit `/implement spec:<id>` command.

---

# Behavior

When creating or revising a spec:

1. Load the spec template.
2. Follow the spec schema.
3. Collaborate with the user.
4. Ask questions only when required.
5. Prefer reasonable assumptions over excessive questioning.
6. Keep the spec concise.
7. Focus on outcomes rather than implementation details.

---

# Outputs

Creates or updates:

```text
tooling/agent-harness/specs/spec-<id>-<slug>.md
```

The resulting artifact must conform to:

```text
schemas/spec.schema.md
```

---

# Constraints

The command must:

* Follow the spec schema.
* Remain outcome-focused.
* Avoid implementation details.
* Avoid speculative architecture.
* Explicitly define non-goals.
* Explicitly define acceptance criteria.

---

# State Transitions

Valid transitions:

```text
Draft -> Approved
Draft -> Cancelled

Approved -> Draft
Approved -> In Progress
```

Transitions must comply with:

```text
state/state-machine.md
```

---

# Success Criteria

The command succeeds when:

* A valid spec artifact exists.
* The spec passes schema validation.
* The requested operation completes successfully.

---

# Failure Conditions

The command fails when:

* The target spec cannot be located.
* The spec cannot be validated.
* Required information is unavailable.
* A requested state transition is invalid.

````

---

One thing I'd deliberately **not** put in this command:

```text
Generate tasks
Create implementation plan
Perform research
Write code
````

Those belong entirely to `/implement`.

I want `/spec` to remain laser-focused on:

```text
idea
  ↓
specification
```

and nothing else.

Once this is written, I think `/implement` becomes much easier because its responsibility boundary is now extremely clear:

```text
approved specification
  ↓
completed implementation
```

with all the orchestration happening in between.
