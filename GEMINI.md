# Gemini / Antigravity Rules

## Core operating principles

**Never commit without permission.** NEVER commit anything without explicit permission from the user. NEVER run `git commit` or `git push` unless the user has explicitly requested or approved it.

## Engineering discipline

**Think before coding.** State assumptions explicitly; if uncertain, ask. If multiple interpretations exist, surface them rather than picking silently. If a simpler approach exists, say so. If something's unclear, stop and name it before implementing.

**Simplicity first.** Minimum code that solves the problem, nothing speculative — no unrequested features, no abstractions for single-use code, no "flexibility" nobody asked for, no error handling for impossible states. If 200 lines could be 50, rewrite. Test: would a senior engineer call this overcomplicated?

**Surgical changes.** Touch only what the task requires. Don't "improve" adjacent code, reformat, or refactor what isn't broken; match existing style even if you'd do it differently. Remove imports/variables your own changes orphaned; leave pre-existing dead code alone (mention it, don't delete). Every changed line should trace directly to the request.

**Goal-driven execution.** Turn tasks into verifiable goals ("add validation" → "write tests for invalid inputs, then make them pass"; "fix the bug" → "write a failing test that reproduces it, then make it pass"). For multi-step work, state a brief plan with a verify check per step. Strong success criteria let you loop independently; weak ones ("make it work") force constant clarification.

## JetBrains MCP — tool priority (PhpStorm, PyCharm, GoLand)

When working in a project where `mcp__*__*` tools are exposed, prefer them over text/regex/shell tools per the rules below. Trust the exposed tool list — availability varies by JetBrains IDE build, plugins, and `idea_mcp_allowed_tools`. **If a tool named in these rules is not in the current session's exposed list, say so explicitly before falling back to grep/regex.** Tool names below are illustrative of a PHP/Symfony-oriented server and are not verified against every build's exposed set — treat unrecognized names per the escape-hatch above.

1. **Semantic lookup first.** Start any class/method/function investigation with `mcp__*__search_symbol` → `mcp__*__get_symbol_info`. Only call `mcp__*__read_file` (or built-in `Read`) once the FQN and location are known. Never start with text/regex search for code identifiers.

2. **Never text-replace identifiers.** Use `mcp__*__rename_refactoring` for any rename of a class, method, property, function, or constant. Follow with `mcp__*__search_text` to audit string literals that semantic rename misses — search for the **old** identifier name in framework route names, dependency injection container IDs (e.g., Symfony service IDs), template references (e.g., Twig, Jinja), and fully-qualified names in config files.

3. **Structural over regex for code patterns.** For syntax-shaped migrations or repeated code shapes (API rewrites, signature changes, decorator wraps), use `mcp__*__search_structural` instead of `mcp__*__search_regex`. Structural search respects language grammar; regex does not. Call `mcp__*__get_structural_patterns` first to discover valid pattern syntax before running a structural search.

4. **Inspections before guessing fixes.** After editing code, call `mcp__*__get_inspections` (broad) or `mcp__*__get_file_problems` (single file) on touched files. The IDE runs inspections asynchronously off the indexer — if results look empty or suspiciously sparse right after a write, re-query once before treating the file as clean. Read the diagnostics and patch manually with `Edit`. **Do not call `mcp__*__apply_quick_fix`** — auto-fixes can be destructive (mass-rewrite imports, silently change semantics) without diff preview. This trades away some safe fixes (e.g. add-missing-import) for safety; that tradeoff is intentional.

   **Write path.** Always use built-in `Edit`/`Write` for file changes — the harness tracks file state. Do not switch to `mcp__*__replace_text_in_file` or `mcp__*__create_new_file` to work around inspection lag; rule 4's "re-query once" already handles that. Note: built-in writes land on disk immediately; MCP inspections read the IDE's in-memory model and may lag a beat behind via file-watch — this is expected.

5. **Bootstrap once per session for non-trivial edits.** Before significant code work, call the IDE's project config tools (e.g., `mcp__*__get_project_config` or `mcp__*__get_composer_dependencies`) + `mcp__*__get_run_configurations` (lists targets; `mcp__*__execute_run_configuration` runs them) so language version, packages, and named test/run targets are known. Cache mentally for the session.

6. **Framework navigation via MCP — prefer the narrowest tool.** Prefer dedicated MCP tools over grep (e.g., Symfony tools for PHP, or equivalent Django/FastAPI tools for Python). When the target is known, use the specific lookup; full-list tools dump everything and are token-heavy on large apps — use them only when genuinely exploring. *(Note: The list below contains PHP/Symfony examples; look for your framework's equivalent if using PyCharm or GoLand)*:
   - `mcp__*__locate_symfony_service` — single service lookup (prefer over listing all)
   - `mcp__*__list_symfony_routes_url_controllers` — all routes (broad, use sparingly)
   - `mcp__*__list_doctrine_entities` — entity discovery
   - `mcp__*__find_files_by_glob` / `mcp__*__find_files_by_name_keyword` — lightweight file discovery; prefer over shell glob/find

7. **Validation ladder after edits.**
   - **PHP / Python (not compiled):** `mcp__*__build_project` is an index/inspection sweep, not a compile check, and is project-wide (slow, token-heavy). Prefer static analysis (e.g., PHPStan / Pyright / mypy) via `mcp__*__execute_run_configuration` for cross-file type correctness.
   - **Go (compiled):** `mcp__*__build_project` *is* a real compile check — use it for cross-package build/type errors; pair with `go vet` / staticcheck run configs.

   Regardless of language:
   - **Static edit** (single file, no cross-file impact): `mcp__*__get_file_problems` or `mcp__*__get_inspections` on touched files.
   - **Cross-file edit** (rename, signature change, new dependency): `mcp__*__get_inspections` on touched files + `mcp__*__execute_run_configuration` (Static Analysis) + `mcp__*__search_text` audit for the **old** identifier name in string literals.
   - **Behavior change** (logic, control flow, new feature): `mcp__*__execute_run_configuration` (relevant tests). Static analysis alone is never enough for behavior changes.

8. **Framework component registration.** When registering a new handler, controller, or repository, use the relevant framework MCP generator (e.g., `generate_symfony_service_definition` for PHP, or equivalent Django generators) rather than hand-writing boilerplate. Do not hand-write service definitions.

9. **Debugging.** Prefer using the IDE's built-in debugger suite (e.g., Xdebug, PyDev, Delve) over ad-hoc print debugging (e.g., `echo`, `print()`, `fmt.Println()`). Debug workflow by language:
   - **PHP (Xdebug):** `mcp__*__xdebug_set_breakpoint` → `mcp__*__xdebug_run` / `mcp__*__xdebug_request` → `mcp__*__xdebug_eval` / `mcp__*__xdebug_context` / `mcp__*__xdebug_stack` → `mcp__*__xdebug_step_over` / `mcp__*__xdebug_step_into` / `mcp__*__xdebug_step_out` → `mcp__*__xdebug_stop`. For HTTP/controller behavior, inspect via `mcp__*__list_profiler_requests`.
   - **Python / Go:** Use the IDE's native debugger (PyCharm debugger / Delve in GoLand). If no `mcp__*__debug_*` tools are exposed, set breakpoints in the IDE and drive via a debug run configuration — do not assume `xdebug_*` exists.

10. **Database inspection (read-only).** Use `mcp__*__list_database_schemas` / `mcp__*__list_schema_objects` / `mcp__*__get_database_object_description` / `mcp__*__preview_table_data` to inspect schema and data (verify migrations, check FK/enum constraints). `mcp__*__execute_sql_query` is allowed for read-only verification — never run writes through it; writes go through `make db-migrate` / fixtures.

### Tools to avoid

- **`mcp__*__reformat_file`** — prefer using the project's dedicated CLI formatting tools (e.g., `black`, `gofmt`, `php-cs-fixer`) via the shell. IDE reformat can produce config drift.
- **`mcp__*__execute_terminal_command`** — runs in the host IDE terminal. Prefer using standard shell tools directly rather than routing commands through the IDE, unless you specifically need to run a command within an IDE-managed container or environment.
- **`mcp__*__apply_quick_fix`** — see rule 4 above.

## Neovim MCP — Tool Priority

When working in a project where Neovim is running and `nvim-mcp` tools are exposed, prefer them over raw text/regex/shell tools per the rules below. Trust the exposed tool list — availability depends on Neovim's active LSP and Treesitter state. **If a tool named in these rules is not in the current session's exposed list, say so explicitly before falling back to grep/regex.**

### Rules

1. **Semantic lookup first.** Start any class/method/function investigation with Neovim's MCP LSP tools (e.g., `workspace_symbol` or `definition`). Only call `read_file` once the file and location are known. Never start with text/regex search for identifiers.

2. **Never text-replace identifiers.** Use Neovim's LSP rename capability (if exposed via the MCP) for any rename of a class, method, property, function, or constant. Follow with a text search audit for string literals that semantic rename misses (e.g., config, templates, tags).

3. **Structural over regex for patterns.** For syntax-shaped migrations or repeated code shapes (API rewrites, signature changes), prioritize Treesitter-backed tools or structural search tools (like `ast-grep`/`sg` in the shell) over raw `search_regex`. Structural search respects grammar; regex does not.

4. **Inspections before guessing fixes.** After editing code, pull diagnostics via the Neovim MCP (e.g., fetching `vim.diagnostic.get()`) to surface issues. Read the diagnostics and patch manually. **Do not** blindly apply auto-fixes without previewing them. This trades away some safe fixes for safety; that tradeoff is intentional.

5. **Validation ladder after edits.** 
   - **Static edit (single file, no cross-file impact):** Fetch diagnostics via Neovim MCP on touched files.
   - **Cross-file edit (rename, signature change, new dependency):** Fetch diagnostics on touched files + run project-wide static analysis (e.g., PHPStan, Pyright) via the shell + audit for the **old** identifier name in string literals.
   - **Behavior change (logic, control flow, new feature):** Run relevant test targets via the shell. Static analysis alone is never enough for behavior changes.

6. **Framework navigation via Shell.** For framework-specific lookups, bypass Neovim MCP and use the specific framework CLI tool via the shell (e.g., `php bin/console debug:router` or `php bin/console debug:container`).
