# Runtime Artifact Root

Harness runtime artifacts are written under:

```text
tooling/agent-harness/
```

Use these directories for artifact types:

```text
tooling/agent-harness/specs/
tooling/agent-harness/plans/
tooling/agent-harness/tasks/
tooling/agent-harness/research/
tooling/agent-harness/qa/
tooling/agent-harness/audits/
tooling/agent-harness/completion/
```

Do not write new runtime artifacts to root-level `specs/`, `plans/`, `tasks/`, `research/`, `qa/`, `audits/`, or `completion/` directories.

If root-level artifact directories already exist, do not move or delete them automatically. Users may manually migrate or clean them up after confirming the new artifact root is working.

When a referenced spec does not exist under `tooling/agent-harness/specs/`, stop with a clear not-found error and do not fall back to root-level `specs/`.
