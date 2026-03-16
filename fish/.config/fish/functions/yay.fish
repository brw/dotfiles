function yay
    # if type -q paru
    #     paru $argv
    #     return $status
    # end

    if not command -q yay
        fish_command_not_found yay
        return 1
    end

    if command -q mise && mise deactivate 2>/dev/null
        function __yay_reactivate_mise --on-event fish_prompt
            functions -e __yay_reactivate_mise
            mise activate | source
        end
    end

    command yay $argv

    # if test -f $HOME/.config/pacman/pacman.conf
    #     command yay --config $HOME/.config/pacman/pacman.conf $argv
    # else
    #     command yay $argv
    # end
end
