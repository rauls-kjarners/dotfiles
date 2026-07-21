# Dotfiles

Cross-platform dotfiles for Linux and macOS, featuring a unified Gruvbox Dark / Gruvbox Light theme that auto-switches with the OS, and ergonomic keyboard mappings (`j k l ;` instead of `h j k l`).

This repository utilizes a native OS approach, using **Homebrew** and **Mise**, replacing isolated package managers like Nix to ensure perfect compatibility with enterprise EDR/security policies.

## Prerequisites

1. Install [Homebrew](https://brew.sh/)
2. Install the `just` command runner:

   ```sh
   brew install just
   ```

## Installation

To install all tools, link all configurations, and set up the environment natively, run:

```sh
just setup
```

### Post-Install / First Run

1. **Neovim setup**: `just setup` clones and links the external Neovim config automatically. Re-run `just setup-nvim` at any time to update it.
2. **Browser (Tridactyl)**: Run `:installnative` in your browser and execute the downloaded script to enable native messaging. Then, `source ~/.config/tridactyl/tridactylrc`.

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
- **External Editor**: `<C-i>` in any text box opens a **Wezterm** window running Neovim to write web comments natively.
- **Hints**: Bound to left-hand keys (`sadfqewcxz`) so the right hand never leaves movement keys.

## Common Aliases

- `lzg`: Launches `lazygit`
- `lzd`: Launches `lazydocker`
- `lzs`: Launches `lazysql`
- `y`: Launches `yazi` and automatically `cd`s to the last directory on exit.
- `dark` / `light`: Manually force a theme switch (`switch_theme dark|light`).
- `update`: Calls `topgrade` directly (brew, mise, fisher, etc.).

## Unified System Automation (Justfile)

This repository uses a unified `justfile` to provide a seamless setup and update experience:

| Command            | Description                                                                 |
| ------------------ | --------------------------------------------------------------------------- |
| `just update`      | The daily driver: topgrade (brew, mise, fisher…) + updates Antigravity CLI. |
| `just clean`       | Cleans up Homebrew caches.                                                  |
| `just setup-nvim`  | Bootstraps Neovim by cloning the external config repo and linking it.       |
| `just clean-nvim`  | Wipes Neovim data/cache directories (`~/.local/share/nvim`, etc.).          |
| `just install-agy` | Native auto-installer for the Antigravity CLI wrapper.                      |
| `just link`        | Safely creates/refreshes all configuration symlinks.                        |
| `just mac-setup`   | Installs JetBrains Mono, configures `dark-notify`, and sets macOS defaults. |
| `just linux-setup` | Sets up flatpaks, distrobox, systemd theme monitor, and fonts.              |

## Theme Switching

This setup uses a dynamic theme switching architecture:

1. **Terminal GUI**: WezTerm and Ghostty query the OS for Dark/Light mode and switch automatically using built-in Gruvbox Material themes.
2. **CLI Tools (Zellij, Bat, Btop, K9s, lazygit, yazi…)**: The `switch_theme dark|light` fish function rewrites all CLI configs in place with native Gruvbox Material themes.
   - **macOS**: `dark-notify` runs as a `launchd` user agent; it calls `switch_theme <mode>` on startup and on every Appearance change.
   - **Linux**: A `systemd` user service watches for theme changes and calls `switch_theme`.
