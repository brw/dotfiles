function pacman
    if test -f /home/bas/.config/pacman/pacman.conf
        command pacman --config /home/bas/.config/pacman/pacman.conf $argv
    else
        command pacman $argv
    end
end
