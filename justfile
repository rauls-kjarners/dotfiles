# default recipe presents an interactive menu using gum
default:
    @if command -v gum > /dev/null; then \
        just $(just --summary | tr ' ' '\n' | gum choose --header "Select a recipe to run:"); \
    else \
        just --list; \
    fi

# Install GitHub CLI extensions
gh-extensions:
    gh extension install dlvhdr/gh-dash || true

# Install packages with Homebrew
brew-install:
    brew bundle

# Install tools with mise
mise-install:
    mise install

# Install fish plugins with Fisher
fish-plugins:
    fish -c 'fisher update'

# Link dotfiles to home directory
link:
    mkdir -p ~/.config/fish
    
    # Safely source fish config (keeps OS-generated paths out of dotfiles repo)
    touch ~/.config/fish/config.fish
    grep -q "source {{justfile_directory()}}/fish/config.fish" ~/.config/fish/config.fish || echo "source {{justfile_directory()}}/fish/config.fish" >> ~/.config/fish/config.fish
    
    # Symlink fish_plugins for fisher
    ln -sfn {{justfile_directory()}}/fish/fish_plugins ~/.config/fish/fish_plugins
    
    # Symlink switch_theme function
    mkdir -p ~/.config/fish/functions
    ln -sfn {{justfile_directory()}}/fish/functions/switch_theme.fish ~/.config/fish/functions/switch_theme.fish
    
    # Safely include gitconfig (keeps user name/email out of dotfiles repo)
    touch ~/.gitconfig
    grep -q "path = {{justfile_directory()}}/git/.gitconfig" ~/.gitconfig || printf "[include]\n    path = {{justfile_directory()}}/git/.gitconfig\n" >> ~/.gitconfig

    # Global gitignore: tracked portable entries + machine-local entries (e.g. antigravity)
    # First run: migrate existing ~/.gitignore_global into ~/.gitignore_global.local to preserve it
    if [ ! -f ~/.gitignore_global.local ] && [ -f ~/.gitignore_global ]; then \
        mv ~/.gitignore_global ~/.gitignore_global.local; \
    fi
    touch ~/.gitignore_global.local
    cat {{justfile_directory()}}/git/gitignore_global ~/.gitignore_global.local > ~/.gitignore_global
    
    # Setup lazygit config dir at the OS-correct path (don't symlink — generated per theme switch)
    LG_DIR=$(command -v lazygit >/dev/null 2>&1 && lazygit --print-config-dir || echo "$HOME/.config/lazygit"); rm -rf "$LG_DIR" 2>/dev/null; mkdir -p "$LG_DIR"

    # Remove first to avoid symlink being created inside the dir if it already exists as a real directory
    rm -rf ~/.config/nvim
    ln -sfn {{justfile_directory()}}/nvim ~/.config/nvim
    ln -sfn {{justfile_directory()}}/ideavim/.ideavimrc ~/.ideavimrc

    # Zellij (copy config.kdl to avoid dirtying the repo on theme switch — mirrors lazygit approach)
    rm -rf ~/.config/zellij
    mkdir -p ~/.config/zellij
    cp {{justfile_directory()}}/zellij/config.kdl ~/.config/zellij/config.kdl
    ln -sfn {{justfile_directory()}}/zellij/themes ~/.config/zellij/themes

    # Ghostty (config dir — works on both macOS and Linux)
    rm -rf ~/.config/ghostty
    ln -sfn {{justfile_directory()}}/ghostty ~/.config/ghostty

    # Mise (global tool configuration)
    mkdir -p ~/.config/mise
    ln -sfn {{justfile_directory()}}/mise/config.toml ~/.config/mise/config.toml

    just bat-themes

# Build custom bat syntax themes (Alucard + any others in bat/themes/)
bat-themes:
    mkdir -p ~/.config/bat/themes
    ln -sfn {{justfile_directory()}}/bat/themes/Alucard.tmTheme ~/.config/bat/themes/Alucard.tmTheme
    bat cache --build
    @echo "bat themes rebuilt — Alucard is ready for delta syntax-theme = Alucard"

# Install dark-mode-notify from source (not available on Homebrew)
dark-mode-notify-install:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v dark-mode-notify &>/dev/null; then
        echo "dark-mode-notify already installed, skipping."
        exit 0
    fi
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT
    git clone --depth=1 https://github.com/bouk/dark-mode-notify.git "$TMP"
    swift build -c release --disable-sandbox --package-path "$TMP"
    cp "$TMP/.build/release/dark-mode-notify" "$(brew --prefix)/bin/dark-mode-notify"
    echo "dark-mode-notify installed to $(brew --prefix)/bin/dark-mode-notify"

# Update system packages and dotfile-managed tools
update:
    brew update && brew upgrade
    mise upgrade
    fish -c 'fisher update'
    gh extension upgrade --all || true
    nvim --headless "+Lazy! sync" +qa

# Clean system and dotfile tool caches
clean:
    brew cleanup
    mise prune

# Register nvim-mcp (Rust-based Neovim MCP server for Claude)
install-nvim-mcp:
    claude mcp add -s user nvim ~/.cargo/bin/nvim-mcp -- --connect auto || true
    @echo "nvim-mcp registered with Claude (compiled by Lazy.nvim)"

# Setup macOS specific tools (auto dark mode, fonts)
mac-setup: dark-mode-notify-install
    brew install --cask font-jetbrains-mono-nerd-font || true
    ln -sfn {{justfile_directory()}}/mac/com.user.dark-mode-notify.plist ~/Library/LaunchAgents/com.user.dark-mode-notify.plist
    launchctl unload ~/Library/LaunchAgents/com.user.dark-mode-notify.plist 2>/dev/null || true
    launchctl load ~/Library/LaunchAgents/com.user.dark-mode-notify.plist

# Setup Linux specific tools (auto dark mode, fonts)
linux-setup:
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "Setting up auto dark mode service..."
    mkdir -p ~/.config/systemd/user
    ln -sfn {{justfile_directory()}}/linux/theme-monitor.service ~/.config/systemd/user/theme-monitor.service
    systemctl --user daemon-reload
    systemctl --user enable --now theme-monitor.service
    
    echo "Installing JetBrains Mono Nerd Font..."
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
    mkdir -p "$FONT_DIR"
    curl -L -o /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o -q /tmp/JetBrainsMono.zip -d "$FONT_DIR"
    rm /tmp/JetBrainsMono.zip
    fc-cache -fv
    # Note: install Ghostty on Bazzite via Distrobox (see README)

    if command -v podman > /dev/null; then
        echo "Enabling Podman socket (for lazydocker/k9s compatibility)..."
        systemctl --user enable --now podman.socket
    fi



# OS specific setup
os-setup:
    @if [ "$(uname)" = "Darwin" ]; then \
        just mac-setup; \
    else \
        just linux-setup; \
    fi

# Run all setup tasks
setup: brew-install gh-extensions mise-install link fish-plugins bat-themes os-setup
