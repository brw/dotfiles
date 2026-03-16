# TODO: prompt to update/add existing files/directories

function dotfiles_add --description 'Move directory to the dotfiles repo and stow it'
    if not test -d ~/dotfiles
        echo "~/dotfiles does not exist."
        return 1
    end

    if count $argv >/dev/null && test $argv[1] != -h && test $argv[1] != --help
        set source $argv[1]
    else
        echo "Usage: dotfiles_add <directory>"
        return 1
    end

    if test -d $source
        set package (path basename $source)
        set target ~/dotfiles/$package/$(realpath -s --relative-to=$HOME $source)

        if test -d $target
            echo "Directory $target already exists."
            return 1
        end
    else
        echo "$source does not exist."
        return 1
    end

    echo "Moving $source to $target"
    mv $source $target
    stow $package
end
