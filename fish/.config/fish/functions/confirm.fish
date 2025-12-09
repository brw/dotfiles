function confirm
    set message (string escape $argv)

    if test -z $message
        set message "Continue?"
    end

    if read -p "printf '%s [Y/n] ' $message" | grep -Eqv '^[yY](es?)?$'
        return 1
    end
end
