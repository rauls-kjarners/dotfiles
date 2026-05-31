function switch_theme --description "Switch system themes between dark and light"
    set theme $argv[1]
    
    if not contains -- "$theme" dark light
        echo "Usage: switch_theme dark|light"
        return 1
    end

    # Skip if theme is already active (avoids redundant universal variable writes)
    # BUT always run if the Zellij config is missing (e.g., first run after setup)
    if test "$theme" = "$_switch_theme_active"; and test -f "$HOME/.config/zellij/config.kdl"
        return 0
    end

    # Use the global user gitconfig (not the tracked dotfile repo copy)
    set -l gitconfig "$HOME/.gitconfig"

    # Resolve lazygit config dir — macOS uses ~/Library/Application Support/lazygit,
    # Linux uses ~/.config/lazygit. Ask lazygit itself; fall back if not on PATH.
    set -l lazygit_dir (command -q lazygit; and lazygit --print-config-dir; or echo "$HOME/.config/lazygit")

    if test "$theme" = "dark"
        # bat
        set -gx BAT_THEME "Dracula"

        # Git Delta
        git config --file "$gitconfig" delta.features "dracula"
        git config --file "$gitconfig" delta.dark "true"
        
        # Fish syntax highlighting (Dracula Dark)
        set -U fish_color_normal F8F8F2
        set -U fish_color_command 8BE9FD
        set -U fish_color_keyword FF79C6
        set -U fish_color_quote F1FA8C
        set -U fish_color_redirection 8BE9FD
        set -U fish_color_end FF79C6
        set -U fish_color_error FF5555
        set -U fish_color_param BD93F9
        set -U fish_color_comment 6272A4
        set -U fish_color_match --background=brblue
        set -U fish_color_selection white --bold --background=brblack
        set -U fish_color_search_match bryellow --background=brblack
        set -U fish_color_history_current --bold
        set -U fish_color_operator 50FA7B
        set -U fish_color_escape FF79C6
        set -U fish_color_cwd 50FA7B
        set -U fish_color_cwd_root red
        set -U fish_color_valid_path --underline
        set -U fish_color_autosuggestion 6272A4
        set -U fish_color_user brgreen
        set -U fish_color_host normal
        set -U fish_color_cancel --reverse
        set -U fish_pager_color_prefix normal --bold --underline
        set -U fish_pager_color_progress brwhite --background=cyan
        set -U fish_pager_color_completion normal
        set -U fish_pager_color_description B3A06D --style=italic
        set -U fish_pager_color_selected_background --background=brblack
        
        # FZF and Hydro prompt colors (Dracula Dark)
        set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
        set -U hydro_color_pwd bd93f9 # Purple
        set -U hydro_color_git 50fa7b # Green
        set -U hydro_color_error ff5555 # Red
        set -U hydro_color_prompt ff79c6 # Pink
        set -U hydro_color_duration f1fa8c # Yellow
        
        # Lazygit Theme
        if test -f "$HOME/Projects/dotfiles/lazygit/config-base.yml"
            mkdir -p "$lazygit_dir"
            cat "$HOME/Projects/dotfiles/lazygit/config-base.yml" "$HOME/Projects/dotfiles/lazygit/theme-dark.yml" > "$lazygit_dir/config.yml"
        end

        # Zellij Theme (live hot-swap — Zellij reloads config.kdl automatically)
        if test -f "$HOME/.config/zellij/config.kdl"
            set -l _zj_cfg "$HOME/.config/zellij/config.kdl"
            set -l _zj_tmp (mktemp)
            string replace -r -- '^theme .*' 'theme "dracula"' < "$_zj_cfg" > "$_zj_tmp"
            mv "$_zj_tmp" "$_zj_cfg"
        end

        set -U _switch_theme_active dark
    else if test "$theme" = "light"
        # bat
        set -gx BAT_THEME "Alucard"

        # Git Delta
        git config --file "$gitconfig" delta.features "alucard"
        git config --file "$gitconfig" delta.dark "false"
        
        # Fish syntax highlighting (Alucard Light)
        set -U fish_color_normal 1F1F1F
        set -U fish_color_command 036A96
        set -U fish_color_keyword A3144D
        set -U fish_color_quote 846E15
        set -U fish_color_redirection 036A96
        set -U fish_color_end A3144D
        set -U fish_color_error CB3A2A
        set -U fish_color_param 644AC9
        set -U fish_color_comment 6C664B
        set -U fish_color_match --background=CFCFDE
        set -U fish_color_selection 1F1F1F --bold --background=CFCFDE
        set -U fish_color_search_match 846E15 --background=CFCFDE
        set -U fish_color_history_current --bold
        set -U fish_color_operator 14710A
        set -U fish_color_escape A3144D
        set -U fish_color_cwd 14710A
        set -U fish_color_cwd_root CB3A2A
        set -U fish_color_valid_path --underline
        set -U fish_color_autosuggestion 6C664B
        set -U fish_color_user 14710A
        set -U fish_color_host 1F1F1F
        set -U fish_color_cancel --reverse
        set -U fish_pager_color_prefix 1F1F1F --bold --underline
        set -U fish_pager_color_progress FFFBEB --background=036A96
        set -U fish_pager_color_completion 1F1F1F
        set -U fish_pager_color_description 846E15 --style=italic
        set -U fish_pager_color_selected_background --background=CFCFDE
        
        # FZF and Hydro prompt colors (Alucard Light)
        set -Ux FZF_DEFAULT_OPTS "--color=fg:#1f1f1f,bg:#fffbeb,hl:#644ac9 --color=fg+:#1f1f1f,bg+:#cfcfde,hl+:#644ac9 --color=info:#846e15,prompt:#14710a,pointer:#a3144d --color=marker:#a3144d,spinner:#846e15,header:#036a96"
        set -U hydro_color_pwd 644ac9 # Purple-ish
        set -U hydro_color_git 14710a # Green
        set -U hydro_color_error cb3a2a # Red
        set -U hydro_color_prompt a3144d # Pink/Red
        set -U hydro_color_duration 846e15 # Yellow
        
        # Lazygit Theme
        if test -f "$HOME/Projects/dotfiles/lazygit/config-base.yml"
            mkdir -p "$lazygit_dir"
            cat "$HOME/Projects/dotfiles/lazygit/config-base.yml" "$HOME/Projects/dotfiles/lazygit/theme-light.yml" > "$lazygit_dir/config.yml"
        end

        # Zellij Theme (live hot-swap — Zellij reloads config.kdl automatically)
        if test -f "$HOME/.config/zellij/config.kdl"
            set -l _zj_cfg "$HOME/.config/zellij/config.kdl"
            set -l _zj_tmp (mktemp)
            string replace -r -- '^theme .*' 'theme "alucard"' < "$_zj_cfg" > "$_zj_tmp"
            mv "$_zj_tmp" "$_zj_cfg"
        end

        set -U _switch_theme_active light
    end
end
