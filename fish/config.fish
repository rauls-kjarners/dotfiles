# Homebrew on Linux
if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Add ~/.local/bin to PATH for external tools (php-lsp, etc)
fish_add_path -gP ~/.local/bin
fish_add_path -gP ~/.local/share/nvim/mason/bin

# Add Homebrew's keg-only libpq to PATH (for psql / vim-dadbod)
if test -d /opt/homebrew/opt/libpq/bin
    fish_add_path -gP -a /opt/homebrew/opt/libpq/bin
else if test -d /usr/local/opt/libpq/bin
    fish_add_path -gP -a /usr/local/opt/libpq/bin
else if test -d /home/linuxbrew/.linuxbrew/opt/libpq/bin
    fish_add_path -gP -a /home/linuxbrew/.linuxbrew/opt/libpq/bin
end

set -gx HOMEBREW_NO_AUTO_UPDATE 1

if type -q mise
    mise activate fish | source
end

# Force truecolor support inside Zellij for lipgloss apps
set -gx COLORTERM truecolor

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
        set -gx BAT_THEME gruvbox-light
    else
        set -gx BAT_THEME gruvbox-dark
    end

    # Apply theme matching current OS dark/light mode.
    # The OS-level daemon (launchd/systemd) live-switches open shells when appearance changes,
    # but new shell instances need to check the OS state on startup to match.
    set -l _desired_theme light
    
    if test (uname) = Darwin
        if defaults read -g AppleInterfaceStyle >/dev/null 2>&1
            set _desired_theme dark
        end
    else if test (uname) = Linux
        # Query Freedesktop portal for color-scheme (1=Dark, 2=Light, 0=Default)
        set -l _os_theme (gdbus call --session --dest=org.freedesktop.portal.Desktop --object-path=/org/freedesktop/portal/desktop --method=org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme 2>/dev/null | awk -F'uint32 ' '{print $2}' | tr -d '>,)')
        if test "$_os_theme" = "1"
            set _desired_theme dark
        end
    end

    # Always call switch_theme; it has its own fast-bailout check to ensure
    # configs haven't been overwritten by `just link` / `just setup`.
    switch_theme "$_desired_theme"

    # ====================
    # Aliases
    # ====================
    alias cat="bat"

    alias box="distrobox"
    alias update="topgrade"

    alias ls="eza --color=always --icons=always"
    alias ll="eza --color=always --long --git --icons=always"
    alias la="eza --color=always --long --git --icons=always --all"

    alias lzg="lazygit"
    alias lzd="lazydocker"
    alias lzs="lazysql"
    alias dark="switch_theme dark"
    alias light="switch_theme light"

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
    
    if type -q atuin
        atuin init fish | source
    end

    if type -q direnv
        direnv hook fish | source
    end

end

# ====================
# Local Untracked Config
# ====================
# Create ~/.config/fish/local.fish on the local machine for private env vars/aliases
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
