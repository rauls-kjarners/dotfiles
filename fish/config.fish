if status is-interactive
    # ====================
    # Environment & Themes
    # ====================
    set -gx BAT_THEME "Dracula"
    set -gx FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
    
    set -g hydro_color_pwd (set_color bd93f9) # Purple
    set -g hydro_color_git (set_color 50fa7b) # Green
    set -g hydro_color_error (set_color ff5555) # Red
    set -g hydro_color_prompt (set_color ff79c6) # Pink
    set -g hydro_color_duration (set_color f1fa8c) # Yellow

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
