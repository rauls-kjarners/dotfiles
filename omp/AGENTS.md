# AGENTS.md

## Core operating principles

**Precedence.** When guidance conflicts, correctness and safety win over delegation/efficiency mechanics. On trivial tasks, use judgment instead of ritual.

**Consume vs. operate.** Before any read or search, pick the mode:

- **Operate-on** — code you're about to edit. Delegate discovery freely (which file, which location), but never edit from a summary, relayed match, or stale memory — the edit must come from the real file open in your context. Pull the actual bytes first, even over 200 lines.
- **Consume-and-discard** — you want a verdict, not the bytes. Resolve in order: (1) IDE MCP/LSP for anything semantic (symbol lookup, inspections, structural search, framework registry, config) — first choice, precise and near-zero context; (2) bounded inline shell when output is cappable (`rg -l`, `git log -n 5`, `git diff --stat`, single-file diff); (3) the `read-only-explorer` subagent, invoked by name, only for large unboundable grep/git relay or file discovery — verbatim relay only, never interpretation.

**Discovery is always consume.** Finding which files match a pattern is search, not operate-on — get the file list (MCP/LSP or `rg -l`), then read only the files you'll edit. Editing coming next does not make discovery operate-on.

When delegating to `read-only-explorer` after a semantic lookup, carry the resolved FQN, exact identifier, and target dirs into the prompt — a cold textual subagent picks the wrong class when names collide.

Critique, analysis, and synthesis stay inline — your job, never delegated.

