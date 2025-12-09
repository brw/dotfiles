function fish_remove_path --description 'Remove an item from $fish_user_paths'
    fish_remove_list fish_user_paths $argv
end
