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

1. **Installs Tools** — Runs `brew bundle` to install core CLI utilities (`fish`, `neovim`, `lazygit`, `eza`, `bat`, `zellij`, etc.) and **Ghostty** (macOS only, via cask).
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
| `just install-nvim-mcp`         | Register Neovim MCP server with Claude                   |
| `just dark-mode-notify-install` | Compile and install `dark-mode-notify` from source       |
| `just mac-setup`                | Re-install the macOS auto dark-mode daemon               |
| `just linux-setup`              | Re-install the Linux auto dark-mode service              |

## Theme System

Themes auto-switch to match the OS dark/light mode. No manual action needed after setup.

| Slot                 | Dark (Dracula)       | Light (Alucard)      |
| -------------------- | -------------------- | -------------------- |
| Terminal (Ghostty)   | `Dracula` built-in   | `alucard` (custom)   |
| Shell colors (fish)  | Dracula palette      | Alucard palette      |
| Prompt (Hydro)       | Dracula palette      | Alucard palette      |
| Fuzzy finder (fzf)   | Dracula palette      | Alucard palette      |
| Multiplexer (Zellij) | `dracula` built-in   | `alucard` (custom)   |
| Git diff (delta)     | Dracula syntax theme | Alucard syntax theme |
| Git UI (lazygit)     | Dracula colors       | Alucard colors       |
| File Manager (yazi)   | Dracula colors       | Alucard colors       |
| Docker UI (lazydocker) | Dracula colors      | Alucard colors       |
| Kubernetes TUI (k9s)  | Dracula skin         | Dracula skin         |
| Disk monitor (btop)   | Dracula theme        | Alucard theme        |
| Database CLI (pgcli)  | Dracula syntax       | Alucard syntax       |
| tldr (tealdeer)       | Dracula syntax       | Alucard syntax       |

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

> **Bazzite note:** Ghostty has no Flatpak. Install via Distrobox:
>
> ```sh
> distrobox create -n ghostty-box -i fedora:latest
> distrobox enter ghostty-box -- bash -c "sudo dnf copr enable pgdev/ghostty -y && sudo dnf install ghostty -y && distrobox-export --app ghostty"
> ```

## Neovim (PHP & Web IDE)

The Neovim configuration acts as a JetBrains replacement. Most tools install automatically via Homebrew, Lazy.nvim, and Mason. A few language servers require manual installation.

If missing, Neovim gracefully ignores them without errors — but you'll miss IDE features.

### PHP Language Servers

**PHPantom** and **Phpactor** run together: PHPantom handles diagnostics (fast), Phpactor provides refactoring actions. **php-lsp** only starts if PHPantom is absent. Priority for diagnostics: **PHPantom** > **php-lsp**. You can hot-swap (e.g., `:LspStop phpantom` then `:LspStart php-lsp`).

**PHPantom** _(highest priority — extremely fast, Rust-based)_

- Download from [PHPantom Releases](https://github.com/PHPantom-dev/phpantom_lsp/releases)
- Place `phpantom_lsp` in your `$PATH` (e.g. `~/.local/bin/`)

**php-lsp** _(fast alternative, Rust-based)_

- Download from [php-lsp Releases](https://github.com/jorgsowa/php-lsp/releases)
- Place `php-lsp` in your `$PATH`

**Phpactor** _(refactoring — runs alongside PHPantom with diagnostics disabled)_

- Handled completely by `mason.nvim`.
- Note on Code Actions: Phpactor's code actions are separated to avoid UI bloat. Use `<leader>ca` for fast, standard code actions. Use `<leader>cp` specifically to access Phpactor's advanced refactoring tools.

### Twiggy (Symfony Twig templates)

Provides autocompletion and hover support for `.twig` files.

- Handled completely by `mason.nvim`. No need to install globally via npm!

### AI & Claude Code

- **claudecode.nvim**: Integrates the Claude Code CLI directly into Neovim. Use `<leader>ac` to toggle Claude, `<leader>as` to send buffers/selections, and `<leader>aa` / `<leader>ad` to accept/deny diffs.
- **nvim-mcp**: A Rust-based MCP server that allows Claude to read your Neovim buffers and use its LSP securely. The binary is compiled automatically by Lazy.nvim, but you must register it with Claude Code by running `just install-nvim-mcp` manually.
- **Copilot**: GitHub Copilot is enabled for inline code suggestions.

### First Run

Once the above are installed:

1. Open Neovim.
2. `Lazy.nvim` will automatically download and install all plugins.
3. `Mason.nvim` will automatically install formatters, linters, and debug adapters (`phpstan`, `php-cs-fixer`, `php-debug-adapter`, etc.).
4. Run `:checkhealth` to verify everything is wired up correctly.
