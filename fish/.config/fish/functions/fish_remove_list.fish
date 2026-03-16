function fish_remove_list --description 'Remove an item from a list'
    set list_name $argv[1]
    set list $$list_name

    set target (printf %s\n $list | fzf -1 -q "$argv[2]")
    test -n "$target" || return 1

    if not set index (contains -i "$target" $list)
        echo "'$target' was not found in $list_name"
        return 1
    end

    if confirm "Remove '$target' from $list_name?"
        set -e $list_name[1][$index] && echo -e "\033[2KRemoved '$target' from \$$list_name"
    end
end
