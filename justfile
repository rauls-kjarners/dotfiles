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

# Install OMP plugins (node-based LSPs)
omp-plugins: mise-install
    mise exec -- omp plugin install omp.nvim

# Install and configure OMP skills
omp-skills: mise-install
    rm -rf ~/.omp/skills ~/.omp/agent/skills
    mkdir -p ~/.omp/skills ~/.omp/agent/skills
    mise exec -- skills add mattpocock/skills@grill-me -a pi -g -y
    mise exec -- skills add juliusbrussee/caveman@caveman -a pi -g -y

# Install tools with mise
mise-install:
    mise install

# Install fish plugins with Fisher
fish-plugins:
    fish -c 'fisher update'

# Link dotfiles to home directory
link: omp-skills
    mkdir -p ~/.config/topgrade
    ln -sf {{justfile_directory()}}/topgrade/topgrade.toml ~/.config/topgrade/topgrade.toml

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
    LG_DIR=$(command -v lazygit >/dev/null 2>&1 && lazygit --print-config-dir || echo "$HOME/.config/lazygit"); mkdir -p "$LG_DIR"

    # Remove first to avoid symlink being created inside the dir if it already exists as a real directory
    ln -sfn {{justfile_directory()}}/markdownlint/.markdownlint-cli2.yaml ~/.markdownlint-cli2.yaml

    # Zellij (copy config.kdl to avoid dirtying the repo on theme switch — mirrors lazygit approach)
    rm -rf ~/.config/zellij
    mkdir -p ~/.config/zellij
    cp {{justfile_directory()}}/zellij/config-base.kdl ~/.config/zellij/config.kdl
    ln -sfn {{justfile_directory()}}/zellij/themes ~/.config/zellij/themes
    ln -sfn {{justfile_directory()}}/ideavim/.ideavimrc ~/.ideavimrc

    # Yazi keymap
    mkdir -p ~/.config/yazi
    ln -sfn {{justfile_directory()}}/yazi/keymap.toml ~/.config/yazi/keymap.toml


    # Mise (global tool configuration)
    mkdir -p ~/.config/mise
    ln -sfn {{justfile_directory()}}/mise/config.toml ~/.config/mise/config.toml
    mise trust ~/.config/mise/config.toml
    # Neotest Docker wrapper (project-agnostic path mapper for running tests in Docker)
    mkdir -p ~/.local/bin
    ln -sfn {{justfile_directory()}}/bin/neotest-remote ~/.local/bin/neotest-remote
    chmod +x {{justfile_directory()}}/bin/neotest-remote

    # Tridactyl
    mkdir -p ~/.config/tridactyl
    rm -f ~/.config/tridactyl/tridactylrc
    ln -sf {{justfile_directory()}}/tridactyl/tridactylrc ~/.config/tridactyl/tridactylrc
    ln -sfn {{justfile_directory()}}/tridactyl/themes ~/.config/tridactyl/themes
    rm -rf ~/.config/wezterm ~/.config/ghostty ~/.config/phpactor ~/.config/glamour
    ln -sfn {{justfile_directory()}}/wezterm ~/.config/wezterm
    mkdir -p ~/.config/ghostty
    ln -sfn {{justfile_directory()}}/ghostty/config ~/.config/ghostty/config
    @if [ "$(uname)" = "Linux" ]; then \
        ln -sfn {{justfile_directory()}}/ghostty/linux-local ~/.config/ghostty/linux-local; \
    fi
    mkdir -p ~/.config/herdr
    ln -sfn {{justfile_directory()}}/herdr/config.toml ~/.config/herdr/config.toml
    ln -sfn {{justfile_directory()}}/phpactor ~/.config/phpactor
    ln -sfn {{justfile_directory()}}/glamour ~/.config/glamour
    mkdir -p ~/.omp/agent ~/.claude ~/.gemini/config
    ln -sfn {{justfile_directory()}}/omp/RULES.md ~/.omp/agent/RULES.md
    mkdir -p ~/.omp/agent/extensions
    ln -sfn {{justfile_directory()}}/omp/hooks/pre/git-rule.ts ~/.omp/agent/extensions/git-rule.ts
    ln -sfn {{justfile_directory()}}/claude/CLAUDE.md ~/.claude/CLAUDE.md
    ln -sfn {{justfile_directory()}}/claude/agents ~/.claude/agents
    ln -sfn {{justfile_directory()}}/antigravity/AGENTS.md ~/.gemini/config/AGENTS.md

    # Flatpak Tridactyl Native Messaging (Zen & Firefox)
    -if command -v flatpak >/dev/null 2>&1; then \
        for app in app.zen_browser.zen org.mozilla.firefox; do \
            if flatpak info $$app >/dev/null 2>&1; then \
                flatpak override --user --persist=.mozilla $$app || true; \
                flatpak override --user --talk-name=org.freedesktop.Flatpak $$app || true; \
                mkdir -p ~/.var/app/$$app/.mozilla/native-messaging-hosts; \
                echo '#!/bin/sh' > ~/.var/app/$$app/.mozilla/native-messaging-hosts/wrapper.sh; \
                echo 'exec flatpak-spawn --host ~/.local/share/tridactyl/native_main "$$@"' >> ~/.var/app/$$app/.mozilla/native-messaging-hosts/wrapper.sh; \
                chmod +x ~/.var/app/$$app/.mozilla/native-messaging-hosts/wrapper.sh; \
                echo '{"name": "tridactyl", "description": "Tridactyl", "path": "'$$HOME'/.mozilla/native-messaging-hosts/wrapper.sh", "type": "stdio", "allowed_extensions": ["tridactyl.vim@cmcaine.co.uk", "tridactyl.vim.betas@cmcaine.co.uk"]}' > ~/.var/app/$$app/.mozilla/native-messaging-hosts/tridactyl.json; \
            fi; \
        done; \
    fi

    # Re-apply current OS theme if active to override default repo templates
    @fish -c 'if set -q _switch_theme_active; switch_theme "$_switch_theme_active"; end' || true

# Update system packages and dotfile-managed tools
update: install-agy
    @topgrade

# Clean system and dotfile tool caches
clean:
    @topgrade --cleanup

# Setup macOS specific tools (auto dark mode, fonts)
mac-setup:
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 15
    brew install --cask font-jetbrains-mono-nerd-font || true
    ln -sfn {{justfile_directory()}}/mac/com.user.dark-mode-notify.plist ~/Library/LaunchAgents/com.user.dark-mode-notify.plist
    launchctl unload ~/Library/LaunchAgents/com.user.dark-mode-notify.plist 2>/dev/null || true
    launchctl load ~/Library/LaunchAgents/com.user.dark-mode-notify.plist

# Install Flatpaks on Linux
flatpak-install:
    @if command -v flatpak > /dev/null; then \
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; \
        FLATPAKS=$$(cat linux/flatpaks.txt | grep -v '^#' | grep -v '^$$'); \
        if [ -n "$$FLATPAKS" ]; then \
            flatpak install -y flathub $$FLATPAKS; \
        fi; \
    fi

# Assemble distrobox containers
distrobox-setup:
    @if command -v distrobox > /dev/null; then \
        distrobox assemble create --file linux/distrobox.ini; \
    fi

# Setup Linux specific tools (auto dark mode, fonts)
linux-setup: flatpak-install distrobox-setup
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
    # Note: install Ghostty natively on immutable Linux hosts via rpm-ostree (do NOT use Distrobox)

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
setup: brew-install gh-extensions mise-install install-agy setup-nvim link fish-plugins omp-plugins os-setup

# Bootstrap and symlink Neovim from external repo
setup-nvim:
    #!/usr/bin/env bash
    set -e
    if [ ! -d "{{justfile_directory()}}/../nvim-config" ]; then
        git clone https://github.com/rauls-kjarners/nvim-config.git "{{justfile_directory()}}/../nvim-config"
    fi
    # Safely remove existing symlink or backup existing folder
    if [ -L "$HOME/.config/nvim" ]; then
        rm "$HOME/.config/nvim"
    elif [ -d "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    fi
    ln -s "{{justfile_directory()}}/../nvim-config" "$HOME/.config/nvim"

# Wipe Neovim data and cache directories (fixes state corruption)
clean-nvim:
    #!/usr/bin/env bash
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim

# Install or update Antigravity CLI
install-agy:
    #!/usr/bin/env bash
    if [ ! -f ~/.local/bin/agy ]; then
        curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir ~/.local/bin
    fi
