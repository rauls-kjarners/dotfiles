# Homebrew on Linux (Bazzite/UBlue use linuxbrew on host)
if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Add ~/.local/bin to PATH for tools installed outside Homebrew (e.g. phpactor)
fish_add_path -g ~/.local/bin

if status is-interactive
    # ====================
    # Environment & Themes
    # ====================
    set -gx EDITOR "nvim"
    set -gx VISUAL "nvim"
    set -gx BAT_THEME "Dracula"

    # Apply theme matching current macOS dark/light mode (no-op on Linux)
    if test (uname) = "Darwin"
        if defaults read -g AppleInterfaceStyle >/dev/null 2>&1
            switch_theme dark
        else
            switch_theme light
        end
    end

    # ====================
    # Aliases
    # ====================
    alias cat="bat"
    alias ls="eza --color=always --icons=always"
    alias ll="eza --color=always --long --git --icons=always"
    alias la="eza --color=always --long --git --icons=always --all"

    alias zj="zellij attach -c main"

    function zjc --description "Attach to main Zellij session or create it in compact mode"
        if zellij list-sessions 2>/dev/null | string match -qr '^main \['
            zellij attach main
        else
            zellij --session main --layout compact
        end
    end

    # ====================
    # Initializations
    # ====================
    zoxide init fish --cmd cd | source
end
