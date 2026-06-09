# Homebrew on Linux
if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Add ~/.local/bin to PATH for external tools (phpantom, php-lsp, etc)
fish_add_path -g ~/.local/bin

if type -q mise
    mise activate fish | source
end

# Point Docker-compatible tools (lazydocker, k9s) to the Podman socket on Linux
if test (uname) = Linux; and type -q podman
    set -gx DOCKER_HOST "unix:///run/user/(id -u)/podman/podman.sock"
end

if status is-interactive
    # ====================
    # Environment & Themes
    # ====================
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    # bat theme fallback for Linux / before first switch_theme call.
    # On macOS, switch_theme (below) overwrites this as a universal var (-Ux),
    # so it propagates live to open shells without a terminal restart.
    if test "$_switch_theme_active" = light
        set -gx BAT_THEME Alucard
    else
        set -gx BAT_THEME Dracula
    end

    # Apply theme matching current macOS dark/light mode (no-op on Linux).
    # The dark-mode-notify launchd daemon is the live-switch driver — it calls
    # switch_theme whenever the OS appearance changes, so open shells update
    # automatically. This block is only needed for new shell instances that
    # open before/after a theme flip that the daemon already dispatched.
    if test (uname) = Darwin
        # Skip the defaults read + switch_theme call if the theme is already
        # current to avoid the subprocess overhead on every pane/tab open.
        set -l _desired_theme light
        if defaults read -g AppleInterfaceStyle >/dev/null 2>&1
            set _desired_theme dark
        end
        if test "$_switch_theme_active" != "$_desired_theme"
            switch_theme "$_desired_theme"
        end
    end

    # ====================
    # Aliases
    # ====================
    alias cat="bat"

    alias ls="eza --color=always --icons=always"
    alias ll="eza --color=always --long --git --icons=always"
    alias la="eza --color=always --long --git --icons=always --all"

    alias lzg="lazygit"
    alias lzd="lazydocker"
    alias lzs="lazysql"
    alias jt1="jiratui ui -j 1 --search-on-startup"
    alias jt2="jiratui ui -j 2 --search-on-startup"
    alias jt3="jiratui ui -j 3 --search-on-startup"

    function y --description "Launch yazi and cd into the last directory on exit"
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file=$tmp
        if set cwd (command cat -- $tmp); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        command rm -f -- "$tmp"
    end

    alias zj="zellij attach -c main"

    function zjc --description "Attach to main Zellij session or create it in compact mode"
        if zellij list-sessions 2>/dev/null | string match -qr '^main \['
            zellij attach main
        else
            zellij --session main --layout compact
        end
    end

    alias agya="agy --dangerously-skip-permissions"

    # ====================
    # Initializations
    # ====================
    if type -q zoxide
        zoxide init fish --cmd cd | source
    end

    # Only show the system info banner in a bare terminal, not in every Zellij pane/split.
    if type -q fastfetch; and not set -q ZELLIJ
        fastfetch
    end
end
