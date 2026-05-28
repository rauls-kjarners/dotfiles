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

## Neovim IDE Setup (PHP & Web)

The Neovim configuration is heavily customized to act as a JetBrains/PhpStorm replacement. While most tools install automatically via Homebrew, Lazy.nvim, and Mason, a few specific language servers require manual installation. 

If these are missing, Neovim will gracefully ignore them without throwing errors, but you will miss out on the IDE features.

### 1. PHPantom (PHP completion, diagnostics, go-to-def)
PHPantom is an extremely fast Rust-based PHP language server. It is not available on package managers.
- Download the pre-compiled binary for your OS/Architecture from [PHPantom Releases](https://github.com/PHPantom-dev/phpantom_lsp/releases)
- Extract the `phpantom_lsp` executable and place it anywhere in your `$PATH` (e.g. `~/.local/bin/` or `/usr/local/bin/`)

### 2. Phpactor (PHP refactoring)
Phpactor provides powerful automated refactoring tools (Extract Method, Inline Variable, etc).
- **Composer (Recommended):** `composer global require phpactor/phpactor`
- **Homebrew:** `brew install phpactor`

### 3. Twiggy (Symfony Twig templates)
Provides autocompletion and hover support for Twig files.
- **NPM:** `npm install -g @twiggyjs/language-server`

### 4. First Run
Once the above are installed in your `$PATH`:
1. Open Neovim.
2. `Lazy.nvim` will automatically download and install all plugins.
3. `Mason.nvim` will automatically download the rest of the formatters, linters, and debug adapters (`phpstan`, `php-cs-fixer`, `php-debug-adapter`, etc).
4. Run `:checkhealth` to verify everything is wired up correctly.
