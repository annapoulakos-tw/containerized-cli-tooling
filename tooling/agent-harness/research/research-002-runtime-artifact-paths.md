# Research research:002: Runtime Artifact Paths

## Parent Spec

spec:002

## Question

Which current harness workflow paths read or write runtime artifacts?

## Findings

* `agentic-harness/canonical/commands/spec.md` declares that `/spec` creates or updates `spec:<id>` but does not define a filesystem path.
* `agentic-harness/canonical/commands/implement.md` declares output directories as `plans/*`, `research/*`, `tasks/*`, `qa/*`, and `completion/*`.
* No canonical `/qa` or `/audit` command files exist in this repository, but QA and audit are described inside `/implement`; their artifact paths must be covered there.
* Templates do not define filesystem directories, but they are copied into generated harness builds and should document/use the new artifact root where helpful.
* Tool-specific build outputs under `agentic-harness/build/<tool>/` are generated from canonical files by `agentic-harness/build.sh`.

## Result

Complete
