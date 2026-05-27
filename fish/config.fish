if status is-interactive
    # ====================
    # Environment & Themes
    # ====================
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

    # ====================
    # Initializations
    # ====================
    zoxide init fish --cmd cd | source
end
