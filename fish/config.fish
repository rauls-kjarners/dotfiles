# Homebrew on Linux (Bazzite/UBlue use linuxbrew on host)
if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Add ~/.local/bin and ~/.cargo/bin to PATH for external tools (phpactor, nvim-mcp)
fish_add_path -g ~/.local/bin ~/.cargo/bin

if status is-interactive
    # ====================
    # Environment & Themes
    # ====================
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    # bat theme follows the active light/dark mode (kept in sync by switch_theme)
    if test "$_switch_theme_active" = light
        set -gx BAT_THEME Alucard
    else
        set -gx BAT_THEME Dracula
    end

    # Apply theme matching current macOS dark/light mode (no-op on Linux)
    if test (uname) = Darwin
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

    alias lg="lazygit"

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
