# Dotfiles 🚀

Cross-platform dotfiles for Linux and macOS. Features a unified Gruvbox Dark / Light theme that auto-switches with the OS, and ergonomic keyboard mappings (`j k l ;` instead of `h j k l`).

Uses **Homebrew** and **Mise** for native OS package management, ensuring perfect compatibility with enterprise EDR/security policies.

## 📦 Prerequisites

1. Install [Homebrew](https://brew.sh/)
2. Install the `just` command runner:

   ```sh
   brew install just
   ```

## 🚀 Installation

To install all tools, link all configurations, and set up the environment natively, run:

```sh
just setup
```

### 📝 Post-Install / First Run

1. **Neovim**: `just setup` clones and links the external Neovim config automatically. Re-run `just setup-nvim` to update.
2. **Browser (Tridactyl)**: Run `:installnative` in the browser and execute the downloaded script to enable native messaging. Then run `source ~/.config/tridactyl/tridactylrc`.

## 📂 Architecture & Core Tools

### 🖥️ Herdr (Multiplexer)

Primary workspace multiplexer, pre-configured for ergonomic use and seamless integration. Zellij remains configured as a fallback/backup.
Movement keys mirror Neovim: `j=left`, `k=down`, `l=up`, `;=right`.

| Keybind                | Action           |
| ---------------------- | ---------------- |
| `Alt + j/k/l/;`        | Navigate panes   |
| `Prefix+Shift+j/k/l/;` | Swap panes       |
| `Alt + 1..9`           | Switch workspace |

### 🌐 Browser Navigation (Tridactyl & Vimium C)

Brings Neovim-like keyboard navigation to web browsers.

- **Movement**: `j=left`, `k=down`, `l=up`, `;=right` for ergonomic home-row usage.
- **Tridactyl** (Zen Browser / Firefox):
  - **External Editor**: `<C-i>` in any text box opens a **Wezterm** window running Neovim to write web comments natively.
  - **Hints**: Bound to left-hand keys (`sadfqewcxz`) so the right hand never leaves movement keys.
- **Vimium C** (Chromium): Configured with the same custom mappings and hint logic.

### 💻 IDE (IdeaVim)

Provides JetBrains IDEs with the custom `j k l ;` motion layout, matching the Neovim and Herdr workflows. Integrates plugins like Flash, Dial, and matches LazyVim keybinds for native IDE actions.

### 🔗 Common Aliases

- `lzg`: Launches `lazygit`
- `lzd`: Launches `lazydocker`
- `lzs`: Launches `lazysql`
- `y`: Launches `yazi` and automatically `cd`s to the last directory on exit.
- `zj` / `zjc`: Attach to main Zellij session (`zjc` uses compact mode).
- `box`: Alias for `distrobox`.
- `dark` / `light`: Manually force a theme switch (`switch_theme dark|light`).
- `update`: Calls `topgrade` directly to update all system packages and dotfile-managed tools.

## 🤖 Unified System Automation (Justfile)

Uses a unified `justfile` to provide a seamless setup and update experience:

| Command            | Description                                                                 |
| ------------------ | --------------------------------------------------------------------------- |
| `just update`      | The daily driver: topgrade (brew, mise, fisher…) + updates Antigravity CLI. |
| `just clean`       | Cleans up Homebrew caches.                                                  |
| `just setup-nvim`  | Bootstraps Neovim by cloning the external config repo and linking it.       |
| `just clean-nvim`  | Wipes Neovim data/cache directories (`~/.local/share/nvim`, etc.).          |
| `just install-agy` | Native auto-installer for the Antigravity CLI wrapper.                      |
| `just link`        | Safely creates/refreshes all configuration symlinks.                        |
| `just mac-setup`   | Installs JetBrains Mono, configures `dark-notify`, and sets macOS defaults. |

## 🖥️ Terminals & Theme Switching

Dynamic theme switching architecture:

1. **Terminal GUI**: WezTerm, Ghostty, and Herdr query the OS for Dark/Light mode and switch automatically using built-in Gruvbox Material themes.
2. **CLI Tools (Zellij, Bat, Btop, K9s, lazygit, yazi…)**: The `switch_theme dark|light` fish function rewrites all CLI configs in place with native Gruvbox Material themes.
   - **macOS**: `dark-notify` runs as a `launchd` user agent; it calls `switch_theme <mode>` on startup and on every Appearance change.
   - **Linux**: A `systemd` user service watches for theme changes and calls `switch_theme`.
