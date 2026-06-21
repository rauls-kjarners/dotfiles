# Dotfiles

Cross-platform dotfiles for Linux and macOS, featuring a unified Dracula (dark) / Alucard (light) theme that auto-switches with the OS, and ergonomic keyboard mappings (`j k l ;` instead of `h j k l`).

## Prerequisites

1. Install [Homebrew](https://brew.sh/)
2. Install the `just` command runner:

   ```sh
   brew install just
   ```

## Installation

To install all tools, link all configurations, and set up the environment, run:

```sh
just setup
```

### Post-Install / First Run

1. **Neovim setup**: Open `nvim`.
   - `Lazy.nvim` will automatically download and install plugins.
   - `Mason.nvim` will install formatters and LSPs.
   - Run `:checkhealth` to verify everything is wired up.
2. **Browser (Tridactyl)**: Tridactyl configuration cannot be fully automated. Manually source `~/.config/tridactyl/tridactylrc` or import it via the extension options.

## Core Tools & Keybinds

### Zellij (Multiplexer)

Pre-configured for ergonomic use and seamless Neovim integration.
Movement keys mirror Neovim: `j=left`, `k=down`, `l=up`, `;=right`.

| Keybind             | Action                                               |
| ------------------- | ---------------------------------------------------- |
| `Alt + j/k/l/;`     | Navigate panes (seamlessly across Zellij and Neovim) |
| `Alt + n`           | New pane                                             |
| `Ctrl+p` then `d/D` | Split pane down / right                              |
| `Ctrl+p` then `x`   | Close pane                                           |
| `Ctrl+s` then `d`   | Detach session                                       |

### Browser (Tridactyl)

Brings Neovim-like keyboard navigation to Zen Browser/Firefox.

- **Movement**: `j=left`, `k=down`, `l=up`, `;=right` for ergonomic home-row usage.
- **External Editor**: `<C-i>` in any text box opens a Ghostty window running Neovim to write web comments natively.
- **Hints**: Bound to left-hand keys (`sadfqewcxz`) so your right hand never leaves movement keys.

### Neovim

Acts as a JetBrains replacement. Most tools install automatically.

- **Obsidian**: Markdown-oxide LSP configuration (`moxide.toml`) is symlinked directly into `~/OneDrive/vaults/main/` to provide workspace-specific LSP features.

## Common Aliases

- `lzg`: Launches `lazygit`
- `lzd`: Launches `lazydocker`
- `lzs`: Launches `lazysql`
- `y`: Launches `yazi` and automatically changes your directory (`cd`) when you exit.

## Individual Commands

Run any step independently if needed:

| Command                         | Description                                        |
| ------------------------------- | -------------------------------------------------- |
| `just brew-install`             | Install Homebrew packages                          |
| `just link`                     | Create/refresh all config symlinks                 |
| `just update`                   | Update entire system and all tools via `topgrade`  |
| `just clean`                    | Clean up system and tool caches via `topgrade`     |
| `just bat-themes`               | Build the custom Alucard bat/delta syntax theme    |
| `just fish-plugins`             | Update Fish shell plugins via fisher               |
| `just dark-mode-notify-install` | Compile and install `dark-mode-notify` from source |
| `just mac-setup`                | Re-install the macOS auto dark-mode daemon         |
| `just linux-setup`              | Re-install the Linux auto dark-mode service        |
