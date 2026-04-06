function fish_prompt
    set -l userhost (set_color cyan)$USER@$hostname(set_color normal)
    set -l cwd (set_color blue)(prompt_pwd)(set_color normal)

    set -l gitinfo ""
    if functions -q fish_git_prompt
        set gitinfo (set_color magenta)(fish_git_prompt)(set_color normal)
    end

    # 1-я строка (инфо)
    printf "%s %s%s\n" $userhost $cwd $gitinfo
    # 2-я строка (ввод)
    printf "> "
end


