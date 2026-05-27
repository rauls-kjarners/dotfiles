# Dotfiles

These are cross-platform dotfiles for Bazzite (Linux) and macOS, featuring a unified Dracula theme and custom ergonomic keyboard mappings (`j k l ;`).

## Prerequisites

1. Install [Homebrew](https://brew.sh/)
2. Install the `just` command runner:
   ```sh
   brew install just
   ```

## Installation

To install all tools, link all configurations, and setup the environment, simply run:

```sh
just setup
```

### What `just setup` does:
1. **Installs Tools:** Runs `brew bundle` to install core CLI utilities (`fish`, `neovim`, `lazygit`, `eza`, `bat`, etc).
2. **Symlinks Configs:** Safely links `fish`, `nvim`, `lazygit`, `.gitconfig`, and `.ideavimrc` into their proper places in `~/.config` and `~/`.
3. **Installs Plugins:** Uses `fisher` to install Fish shell plugins and sets up the prompt.
4. **OS Specific Setup:** Installs and enables the auto dark-mode switching service for macOS (launchd) or Bazzite (systemd).

## Individual Commands

If you ever need to run specific steps individually, you can use the sub-commands:
- `just brew-install` - Only installs the brew packages
- `just link` - Only creates/refreshes the configuration symlinks
- `just fish-plugins` - Only updates the Fish shell plugins
- `just dark-mode-notify-install` - Compiles and installs `dark-mode-notify` from source (run automatically by `mac-setup`)
- `just mac-setup` - Re-installs the macOS auto dark-mode daemon
- `just linux-setup` - Re-installs the Bazzite/Linux auto dark-mode service
