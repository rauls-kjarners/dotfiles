# Dotfiles

Cross-platform dotfiles for Linux and macOS, featuring a unified Dracula (dark) / Alucard (light) theme that auto-switches with the OS, and ergonomic keyboard mappings (`j k l ;` instead of `h j k l`).

## Prerequisites

1. Install [Homebrew](https://brew.sh/)
2. Install the `just` command runner:

   ```sh
   brew install just
   ```

## Installation

To install all tools, link all configurations, and set up the environment, simply run:

```sh
just setup
```

### What `just setup` does

1. **Installs Tools** — Runs `brew bundle` to install core CLI utilities (`fish`, `neovim`, `lazygit`, `eza`, `bat`, `zellij`, `slk`, `jiratui`, `jira-cli`, etc.) and **Ghostty** (macOS only, via cask).
2. **Symlinks Configs** — Safely links `fish`, `nvim`, `.gitconfig`, `.ideavimrc`, and `~/.config/ghostty` into their proper places. `lazygit` config is generated per-theme into the OS-correct directory (`~/Library/Application Support/lazygit` on macOS, `~/.config/lazygit` on Linux). Zellij `config.kdl` is copied (not symlinked) so theme switching doesn't dirty the repo.
3. **Builds bat Themes** — Compiles the custom Alucard bat/delta syntax theme.
4. **Installs Fish Plugins** — Uses `fisher` to install Fish shell plugins and sets up the prompt.
5. **Installs Fonts** — Downloads and installs JetBrains Mono Nerd Font (via Homebrew on macOS, or manual download on Linux).
6. **OS-Specific Setup** — Installs and enables the auto dark-mode switching daemon for macOS (launchd) or Linux (systemd).

## Individual Commands

Run any step independently if needed:

| Command                         | Description                                              |
| ------------------------------- | -------------------------------------------------------- |
| `just brew-install`             | Install Homebrew packages                                |
| `just link`                     | Create/refresh all config symlinks                       |
| `just update`                   | Update dotfiles-managed tools (mise, nvim, fish plugins) |
| `just clean`                    | Clean up caches (mise prune)                             |
| `just bat-themes`               | Build the custom Alucard bat/delta syntax theme          |
| `just fish-plugins`             | Update Fish shell plugins via fisher                     |
| `just dark-mode-notify-install` | Compile and install `dark-mode-notify` from source       |
| `just mac-setup`                | Re-install the macOS auto dark-mode daemon               |
| `just linux-setup`              | Re-install the Linux auto dark-mode service              |

## Theme System

Themes auto-switch to match the OS dark/light mode. No manual action needed after setup.

| Slot                   | Dark (Dracula)       | Light (Alucard)      |
| ---------------------- | -------------------- | -------------------- |
| Terminal (Ghostty)     | `Dracula` built-in   | `alucard` (custom)   |
| Shell colors (fish)    | Dracula palette      | Alucard palette      |
| Prompt (Hydro)         | Dracula palette      | Alucard palette      |
| Fuzzy finder (fzf)     | Dracula palette      | Alucard palette      |
| Multiplexer (Zellij)   | `dracula` built-in   | `alucard` (custom)   |
| Git diff (delta)       | Dracula syntax theme | Alucard syntax theme |
| Git UI (lazygit)       | Dracula colors       | Alucard colors       |
| File Manager (yazi)    | Dracula colors       | Alucard colors       |
| Docker UI (lazydocker) | Dracula colors       | Alucard colors       |
| Disk monitor (btop)    | Dracula theme        | Alucard theme        |
| Database CLI (pgcli)   | Dracula syntax       | Alucard syntax       |
| tldr (tealdeer)        | Dracula syntax       | Alucard syntax       |
| Browser (Tridactyl)    | Dracula theme        | Alucard theme        |
| Syntax highlight (bat) | `Dracula` built-in   | `Alucard` (custom)   |
| K8s UI (k9s)           | `dracula` skin       | `dracula` skin       |
| Markdown (glamour)     | `dracula` style      | `alucard` style      |
| Antigravity (agy)      | `solarized dark`     | `solarized light`    |
| Jira TUI (jiratui)     | `dracula` theme      | `solarized-light`    |

Switching is handled by `switch_theme dark|light` (a fish function). It is called automatically on shell startup by reading the OS dark mode preference.

### Alucard Palette

| Role                   | Color                  |
| ---------------------- | ---------------------- |
| Background             | `#FFFBEB` (warm cream) |
| Foreground             | `#1F1F1F` (near-black) |
| Red                    | `#CB3A2A`              |
| Green                  | `#14710A`              |
| Yellow                 | `#846E15`              |
| Blue/Purple            | `#644AC9`              |
| Magenta/Crimson        | `#A3144D`              |
| Cyan/Teal              | `#036A96`              |
| Orange                 | `#A34D14`              |
| Neutral (selection bg) | `#CFCFDE`              |
| Comment                | `#6C664B`              |

## Common Aliases

- `lzg`: Launches `lazygit`
- `lzd`: Launches `lazydocker`
- `lzs`: Launches `lazysql`
- `y`: Launches `yazi` and automatically changes your directory (`cd`) when you exit.

## Zellij

Zellij is the default terminal multiplexer, pre-configured for ergonomic use and seamless Neovim integration.

- Theme hot-swaps live — `switch_theme` patches `config.kdl` using `string replace` and Zellij picks it up automatically.
- Built-in Dracula theme is used for dark mode; the custom `alucard` theme (`zellij/themes/alucard.kdl`) is used for light mode.
- Keybinds otherwise follow Zellij defaults (`Ctrl+p` for pane mode, `Ctrl+t` for tab mode, etc.).

Movement keys mirror Neovim: `j=left`, `k=down`, `l=up`, `;=right`.

| Keybind             | Action                                               |
| ------------------- | ---------------------------------------------------- |
| `Alt + j/k/l/;`     | Navigate panes (seamlessly across Zellij and Neovim) |
| `Alt + n`           | New pane                                             |
| `Ctrl+p` then `d/D` | Split pane down / right                              |
| `Ctrl+p` then `x`   | Close pane                                           |
| `Ctrl+s` then `d`   | Detach session                                       |

## Ghostty

Config is symlinked to `~/.config/ghostty` by `just link`. Theme auto-switches with the OS.

- **Font:** JetBrains Mono Nerd Font, 13pt
- **Dark theme:** Dracula (built-in)
- **Light theme:** Alucard (custom, from `ghostty/themes/alucard`)
- **Pane management:** handled by Zellij (see Zellij section above)

## Browser (Tridactyl)

Tridactyl is used to bring Neovim-like keyboard navigation to Zen Browser/Firefox.
Config is copied to `~/.config/tridactyl/tridactylrc` by `just link` so theme switching doesn't dirty the repo.

- **Theme**: Auto-switches between Dracula (dark) and Alucard (light) via `switch_theme`.
- **Movement**: Re-mapped to `j=left`, `k=down`, `l=up`, `;=right` for ergonomic home-row usage.
- **External Editor**: The `<C-i>` shortcut in any text box will pop open a temporary Ghostty window running Neovim (with your fish shell `$PATH` and LSPs enabled), allowing you to write web comments using real Neovim.
- **Hints**: Bound exclusively to the left-hand keys (`sadfqewcxz`) so your right hand never has to leave the movement keys while browsing.

## Neovim (PHP & Web IDE)

The Neovim configuration acts as a JetBrains replacement. Most tools install automatically via Homebrew, Lazy.nvim, and Mason. A few language servers require manual installation.

If missing, Neovim gracefully ignores them without errors — but you'll miss IDE features.

### PHP Language Servers

**php-lsp** and **Phpactor** run together: **php-lsp** handles diagnostics (fast), **Phpactor** provides refactoring actions. **intelephense** is configured as a fallback and only starts if **php-lsp** is absent.

**php-lsp** _(highest priority — fast, Rust-based)_

- Automatically installed via `mise` (`github:jorgsowa/php-lsp`).

**intelephense** _(fallback alternative, standard Node-based PHP LSP)_

- Handled by LazyVim defaults if `php-lsp` is not installed.

**Phpactor** _(refactoring — runs alongside php-lsp/intelephense with diagnostics disabled)_

- Handled completely by `mason.nvim`.
- **Configuration**: The `just link` command automatically symlinks a global `phpactor.json` to `~/.config/phpactor/phpactor.json`. This configures critical performance exclusions (ignoring `var/cache` proxy noise and coverage reports) while preserving autocomplete for Symfony Config Builders.

### Twiggy (Symfony Twig templates)

Provides autocompletion and hover support for `.twig` files.

- Handled completely by `mason.nvim`. No need to install globally via npm!

### AI Assistants

- **Antigravity (agy)**: Used as the primary AI coding assistant CLI. Run the `agy` command natively in a Zellij split pane next to Neovim.
- **claudecode.nvim**: Integrates the Claude Code CLI directly into Neovim. Use `<leader>ac` to toggle Claude, `<leader>as` to send buffers/selections, and `<leader>aa` / `<leader>ad` to accept/deny diffs.
- **Copilot**: GitHub Copilot is enabled for inline code suggestions.

#### Skills & Rules

- **caveman**: An installed skill for the AI agents that enforces ultra-compressed, dense, action-oriented communication without conversational filler. It maximizes token efficiency and minimizes noise, and is enabled by default via dotfile-tracked system prompts.
- **grill-me**: An installed skill for the AI agents that relentlessly interviews you about a plan or design until a shared understanding is reached. Just tell the agent to "grill me" to stress-test your ideas.
- **Oh My Pi (OMP)**: The dotfiles repository contains custom rules (`RULES.md`) and agents (`AGENTS.md`) which are symlinked to `~/.omp/agent/` during setup.

### Remote Testing

- **neotest-remote**: A script installed to `~/.local/bin/neotest-remote` that intercepts Neotest commands, translates host paths to container paths, and executes PHP tests inside Docker via `docker-compose run`. It rewrites the resulting JUnit XML paths back to host paths so Neotest can display results inline.

### Config Backups

- **Vimium / Vimium C**: Configuration backups are available in the `vimium/` directory. These must be imported manually via the browser extension's options page.
- **Obsidian**: Markdown-oxide LSP configuration (`moxide.toml`) is symlinked directly into `~/OneDrive/vaults/main/` to provide workspace-specific LSP features.

### First Run

Once the above are installed:

1. Open Neovim.
2. `Lazy.nvim` will automatically download and install all plugins.
3. `Mason.nvim` will automatically install formatters, linters, and debug adapters (`phpstan`, `php-cs-fixer`, `php-debug-adapter`, etc.).
4. Run `:checkhealth` to verify everything is wired up correctly.
