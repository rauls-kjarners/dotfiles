# CLAUDE.md

## Core operating principles

Two rules govern everything below.

**Precedence.** When guidance conflicts, correctness and safety win over delegation/efficiency mechanics. On genuinely trivial tasks, use judgment instead of ritual — these rules bias toward caution, which is pure overhead on small work.

**Never commit without permission.** NEVER commit anything without explicit permission from the user. NEVER run `git commit` or `git push` unless the user has explicitly requested or approved it.

**The routing gate — consume vs. operate.** Before any read, search, or analysis, pick the mode:

- **Operate-on** — code you're about to edit. Read the file and edit it yourself - even if it's over 200 lines; don't delegate it. Never edit from a summary.
- **Consume-and-discard** — you want a verdict, not the bytes (audits, searches, reviews, git history, external research). Delegate to agy.
- **Unsure which mode?** If you don't yet know whether you'll edit, treat it as consume and delegate. Only keep it local once you've committed to editing it.

If a review leads straight into editing the same file, read it locally once - don't delegate then re-read it.

## Engineering discipline

**Think before coding.** State assumptions explicitly; if uncertain, ask. If multiple interpretations exist, surface them rather than picking silently. If a simpler approach exists, say so. If something's unclear, stop and name it before implementing.

**Simplicity first.** Minimum code that solves the problem, nothing speculative — no unrequested features, no abstractions for single-use code, no "flexibility" nobody asked for, no error handling for impossible states. If 200 lines could be 50, rewrite. Test: would a senior engineer call this overcomplicated?

**Surgical changes.** Touch only what the task requires. Don't "improve" adjacent code, reformat, or refactor what isn't broken; match existing style even if you'd do it differently. Remove imports/variables your own changes orphaned; leave pre-existing dead code alone (mention it, don't delete). Every changed line should trace directly to the request.

**Goal-driven execution.** Turn tasks into verifiable goals ("add validation" → "write tests for invalid inputs, then make them pass"; "fix the bug" → "write a failing test that reproduces it, then make it pass"). For multi-step work, state a brief plan with a verify check per step. Strong success criteria let you loop independently; weak ones ("make it work") force constant clarification.

## Delegating to agy (`delegate_to_agy`)

Offloading heavy _consume-and-discard_ work to agy keeps your context window lean — you get the verdict back, not the raw bytes. This is the context-budget win, and it's larger than per-query savings.

**What to offload.** Within consume-and-discard:

- **grep — always delegate.** Flag combinations (`-r`, `-A`, `-B`, `-C`) make output size unpredictable regardless of `-m`. **NEVER** run grep directly.
- **`git diff` / `git log` — delegate by default.** Exception: when you can bound it small and need it inline — `git log -n 5`, `git diff --stat`, a `git diff` of the single file you just touched — run it directly. **NEVER** run unbounded versions directly.
- **Files >200 lines** you're reading to analyze or review (not edit). If you are unsure whether a file exceeds 200 lines, delegate it anyway - Antigravity CLI handles the cost, not you.
- **Multi-file analysis spanning >3 files** for bug-hunting, architecture, or debugging you're not editing.
- **Bulky or multi-source external research.** A single-fact lookup you can do inline — but if answering needs fetching a full web page, delegate it; the page lands in context whole regardless of how small the answer is. Delegate any real documentation/research dig.
- **Adversarial review and plan critique** — delegate not mainly for tokens but because agy is a _different model_ and won't share your blind spots.

Don't assume you remember a file's contents — code changes. If you're verifying rather than editing, delegate and check.

### How to delegate

Pass a clear `prompt` (exactly what to find or analyze), the absolute `cwd`, and relevant paths in `files`. Await the JSON response and use the summary. **CRITICAL: You must explicitly instruct agy in your prompt to act in READ-ONLY mode and forbid it from modifying any files or running mutating commands.**

- **Carry semantic context forward.** If a delegation follows a semantic lookup (e.g., via JetBrains MCP `mcp__*__search_symbol` or Neovim MCP LSP tools), include the resolved FQN, exact identifier string, and target directories in the prompt — agy starts cold and will re-derive textually, risking the wrong class when method names collide.
- **agy reads disk; MCP reads the IDE's in-memory model.** Unsaved edits are invisible to agy. If delegating after making edits, save first or say so in the prompt.

### STOP & VERIFY

The rules above describe what to do; this layer fights the excuses you'll generate against them at execution time. Failure runs in **both** directions — under-delegating consume work, and over-delegating work you should be doing yourself.

You're off the rails if:

- You edited from agy's summary instead of reading the file yourself. Editing is local - never edit from a summary.
- You ran `grep` directly, or an **unbounded** `git diff` / `git log` in-terminal instead of delegating. (Bounded git commands like `-n 5` or `--stat` are fine).
- You read a whole file over 200 lines locally to audit or review it, instead of delegating.
- You answered a consume trigger from memory instead of verifying — code changes.

### Rationalization table

| Excuse                                                                 | Reality                                                                                               |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| "I already know this / can answer from memory."                        | Code changes and memory goes stale. If you're verifying or consuming, delegate.                       |
| "The file is probably small."                                          | If you're consuming and unsure, delegate - don't guess.                                               |
| "It's faster if I just read it."                                       | For consume work, context-budget conservation outranks speed.                                         |
| "I only need a small part of the file."                                | _Consuming_ → delegate the whole file, let agy extract. _Editing_ → just read the file and edit it.   |
| "I'll just delegate this file I'm about to edit."                      | It's operate-on: read the file and edit it yourself. Never edit from a summary.                       |
| "I'll delegate the review, then read the file to make the change."     | If the review leads straight to an edit, read it once locally. Don't fetch it twice.                  |
| "I just ran a bounded grep/git command, so this next one is fine too." | _Independent bounds_ → a prior bounded command doesn't make an unbounded one safe. Re-check per call. |

## JetBrains MCP — tool priority (PhpStorm, PyCharm, GoLand)

When working in a project where `mcp__*__*` tools are exposed, prefer them over text/regex/shell tools per the rules below. Trust the exposed tool list — availability varies by JetBrains IDE build, plugins, and `idea_mcp_allowed_tools`. **If a tool named in these rules is not in the current session's exposed list, say so explicitly before falling back to grep/regex.** Tool names below are illustrative of a PHP/Symfony-oriented server and are not verified against every build's exposed set — treat unrecognized names per the escape-hatch above.

1. **Semantic lookup first.** Start any class/method/function investigation with `mcp__*__search_symbol` → `mcp__*__get_symbol_info`. Only call `mcp__*__read_file` (or built-in `Read`) once the FQN and location are known. Never start with text/regex search for code identifiers. `mcp__*__read_file` supports partial reads (line/range/offset/indentation modes, `max_lines`) — read only the known location, not whole files. `mcp__*__get_file_text_by_path` is the simpler project-relative variant when you only have a project-relative path; it also supports truncation modes but not fine-grained range selection.

2. **Never text-replace identifiers.** Use `mcp__*__rename_refactoring` for any rename of a class, method, property, function, or constant. Follow with `mcp__*__search_text` to audit string literals that semantic rename misses — search for the **old** identifier name in framework route names, dependency injection container IDs (e.g., Symfony service IDs), template references (e.g., Twig, Jinja), and fully-qualified names in config files. _(Some builds expose two search families: `search_text`/`search_regex` use glob `paths` and return match coordinates — prefer these for precision. `search_in_files_by_text`/`search_in_files_by_regex` use dir+fileMask and return IntelliJ `||`-marked snippets. Either satisfies the audit step.)_

3. **Structural over regex for code patterns.** For syntax-shaped migrations or repeated code shapes (API rewrites, signature changes, decorator wraps), use `mcp__*__search_structural` instead of `mcp__*__search_regex`. Structural search respects language grammar; regex does not. Call `mcp__*__get_structural_patterns` first to discover valid pattern syntax before running a structural search.

4. **Inspections before guessing fixes.** After editing code, call `mcp__*__get_inspections` (broad) or `mcp__*__get_file_problems` (single file) on touched files. The IDE runs inspections asynchronously off the indexer — if results look empty or suspiciously sparse right after a write, re-query once before treating the file as clean. Read the diagnostics and patch manually with `Edit`. **Do not call `mcp__*__apply_quick_fix`** — auto-fixes can be destructive (mass-rewrite imports, silently change semantics) without diff preview. This trades away some safe fixes (e.g. add-missing-import) for safety; that tradeoff is intentional.

   **Write path.** Always use built-in `Edit`/`Write` for file changes — the harness tracks file state. Do not switch to `mcp__*__replace_text_in_file` or `mcp__*__create_new_file` to work around inspection lag; rule 4's "re-query once" already handles that. Note: built-in writes land on disk immediately; MCP inspections read the IDE's in-memory model and may lag a beat behind via file-watch — this is expected.

5. **Bootstrap once per session for non-trivial edits.** Before significant code work, call:
   - `mcp__*__get_php_project_config` — PHP level, interpreter, extensions. The only source for remote/Docker interpreter details.
   - `mcp__*__get_composer_dependencies` or `mcp__*__get_project_dependencies` — installed packages.
   - `mcp__*__get_run_configurations` — lists named targets; `mcp__*__execute_run_configuration` runs them.

   Cache language version, packages, and test/run targets mentally for the session.

6. **Framework navigation via MCP — prefer the narrowest tool.** Prefer dedicated MCP tools over grep (e.g., Symfony tools for PHP, or equivalent Django/FastAPI tools for Python). When the target is known, use the specific lookup; full-list tools dump everything and are token-heavy on large apps — use them only when genuinely exploring. _(Note: The list below contains PHP/Symfony examples; look for your framework's equivalent if using PyCharm or GoLand)_:
   - `mcp__*__locate_symfony_service` — single service lookup (prefer over listing all)
   - `mcp__*__list_symfony_routes_url_controllers` — all routes (broad, use sparingly)
   - `mcp__*__list_doctrine_entities` — entity discovery
   - `mcp__*__list_doctrine_entity_fields` — fields/columns/types/relations/enumType for one entity as CSV; prefer over reading XML mapping files
   - `mcp__*__find_files_by_glob` / `mcp__*__find_files_by_name_keyword` — lightweight file discovery; prefer over shell glob/find
   - `mcp__*__list_directory_tree` — directory tree view; prefer over shell `ls`/`find` for exploring structure

7. **Validation ladder after edits.**
   - **PHP / Python (not compiled):** `mcp__*__build_project` is an index/inspection sweep, not a compile check, and is project-wide (slow, token-heavy). Prefer static analysis (e.g., PHPStan / Pyright / mypy) via `mcp__*__execute_run_configuration` for cross-file type correctness.
   - **Go (compiled):** `mcp__*__build_project` _is_ a real compile check — use it for cross-package build/type errors; pair with `go vet` / staticcheck run configs.

   Regardless of language:
   - **Static edit** (single file, no cross-file impact): `mcp__*__get_file_problems` or `mcp__*__get_inspections` on touched files.
   - **Cross-file edit** (rename, signature change, new dependency): `mcp__*__get_inspections` on touched files + `mcp__*__execute_run_configuration` (Static Analysis) + `mcp__*__search_text` audit for the **old** identifier name in string literals.
   - **Behavior change** (logic, control flow, new feature): `mcp__*__execute_run_configuration` (relevant tests). Static analysis alone is never enough for behavior changes.

8. **Framework component registration.** When registering a new handler, controller, or repository, use the relevant framework MCP generator (e.g., `generate_symfony_service_definition` for PHP, or equivalent Django generators) rather than hand-writing boilerplate. Do not hand-write service definitions.

9. **Debugging.** Prefer using the IDE's built-in debugger suite (e.g., Xdebug, PyDev, Delve) over ad-hoc print debugging (e.g., `echo`, `print()`, `fmt.Println()`). Debug workflow by language:
   - **PHP (Xdebug):** `mcp__*__xdebug_set_breakpoint` → `mcp__*__xdebug_run` / `mcp__*__xdebug_request` → `mcp__*__xdebug_eval` / `mcp__*__xdebug_context` / `mcp__*__xdebug_stack` → `mcp__*__xdebug_step_over` / `mcp__*__xdebug_step_into` / `mcp__*__xdebug_step_out` → `mcp__*__xdebug_stop`. For HTTP/controller behavior, inspect via `mcp__*__list_profiler_requests`.
   - **Python / Go:** Use the IDE's native debugger (PyCharm debugger / Delve in GoLand). If no `mcp__*__debug_*` tools are exposed, set breakpoints in the IDE and drive via a debug run configuration — do not assume `xdebug_*` exists.

10. **Database inspection (read-only).** Start with `mcp__*__list_database_connections` to get the connection IDs required by other DB tools. Then use `mcp__*__list_database_schemas` / `mcp__*__list_schema_objects` / `mcp__*__get_database_object_description` / `mcp__*__preview_table_data` to inspect schema and data (verify migrations, check FK/enum constraints). `mcp__*__execute_sql_query` is allowed for read-only verification — never run writes through it; writes go through `make db-migrate` / fixtures.

### Tools to avoid

- **`mcp__*__reformat_file`** — prefer using the project's dedicated CLI formatting tools (e.g., `black`, `gofmt`, `php-cs-fixer`) via the shell. IDE reformat can produce config drift.
- **`mcp__*__execute_terminal_command`** — runs in the host IDE terminal. Prefer using standard shell tools directly rather than routing commands through the IDE, unless you specifically need to run a command within an IDE-managed container or environment.
- **`mcp__*__apply_quick_fix`** — see rule 4 above.
- **`mcp__*__invoke_ide_action`** — generic IDE-action driver (use `mcp__*__search_ide_actions` to discover action IDs first). Same risk class as `apply_quick_fix`: actions like ReformatCode/refactors run without diff preview. Use only for clearly safe, read-only or navigation actions (open a tool window, focus a file); never for bulk edits or refactors. Pass `filePaths` when targeting a specific file or folder — without it, file-focused actions may run globally or fail.

## Neovim MCP — Tool Priority

When working in a project where Neovim is running and `nvim` MCP tools are exposed, prefer them over raw text/regex/shell tools per the rules below. Trust the exposed tool list — availability depends on Neovim's active LSP and Treesitter state. **If a tool named in these rules is not in the current session's exposed list, say so explicitly before falling back to grep/regex.**

**Connection is automatic — no manual discovery needed.** The nvim-mcp server runs with `--connect auto` and auto-connects at startup. Workflow:

1. Read the `nvim-connections://` MCP resource (JSON: `[{id, target}]`) and use `id` as the `connection_id`. **Never** call `get_targets` or shell out to `nvim --server … --remote-expr`.
2. If `nvim-connections://` is empty (MCP server started before nvim opened its socket): call the `connect` tool with target `/tmp/nvim-<cwd-basename>.sock`, then re-read the resource. This is the only permitted recovery step.
3. If `connect` also fails: Neovim is not running for this project — say so and ask the user to start it.

### Rules

1. **Semantic lookup first.** Start any class/method/function investigation with Neovim's MCP LSP tools (`lsp_workspace_symbols` or `lsp_definition`). Only call `read` once the file and location are known. Never start with text/regex search for identifiers.

2. **Never text-replace identifiers.** Use Neovim's `lsp_rename` tool for any rename of a class, method, property, function, or constant. Follow with a text search audit via the shell for string literals that semantic rename misses (e.g., config, templates, tags).

3. **Structural over regex for patterns.** For syntax-shaped migrations or repeated code shapes (API rewrites, signature changes), prioritize shell structural search tools (like `ast-grep`/`sg`) over raw regex. Structural search respects grammar; regex does not.

4. **Inspections before guessing fixes.** After editing code, pull diagnostics using `buffer_diagnostics` to surface issues in the current file. Read the diagnostics and patch manually. **Do not** blindly rely on auto-fixes.

5. **Validation ladder after edits.**
   - **Static edit (single file, no cross-file impact):** Fetch `buffer_diagnostics` via Neovim MCP on touched files.
   - **Cross-file edit (rename, signature change, new dependency):** Fetch `buffer_diagnostics` on touched files + run project-wide static analysis (e.g., PHPStan, Pyright) via the shell + audit for the **old** identifier name in string literals.
   - **Behavior change (logic, control flow, new feature):** Run relevant test targets via the shell. Static analysis alone is never enough for behavior changes.

6. **Framework navigation via Shell.** For framework-specific lookups, bypass Neovim MCP and use the specific framework CLI tool via the shell (e.g., `php bin/console debug:router` or `php bin/console debug:container`).

## Routing: IDE MCP vs. agy

Applies only to _consume-and-discard_ work (operate-on stays in context — see Core principles) in projects where an IDE MCP (JetBrains or Neovim) is exposed. Within consume-and-discard, the split is **semantic vs. textual**:

- **IDE MCP** — semantic, bounded queries: single-symbol lookup, single-file or small-set inspections, structural search within a target directory, rename refactors, framework registry lookups, project config introspection. Also the **post-rename text search audit** — even when codebase-wide, it's a single known identifier following a semantic operation, so keep it in MCP to keep the rename context coupled.
- **agy** — wide textual queries: codebase-wide grep/search audits spanning many modules, `git diff` / `git log`, multi-file analysis, bulky external research, adversarial review.

**Text search boundary:** bounded / single-identifier / post-rename → IDE MCP; wide and exploratory → agy.

When both fit, prefer IDE MCP for precision; switch to agy if the result set will exceed a handful of files.
