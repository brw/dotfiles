function latest --description 'Update asdf managed tools to their latest version'
    isatty || read -az stdin && set -a argv $stdin

    if test -n "$argv"
        set plugins $argv

        for plugin in $plugins
            if asdf plugin list | grep -q $plugin
                asdf plugin update $plugin
            else
                asdf plugin add $plugin
            end
        end
    else
        set plugins (asdf plugin list)
        asdf plugin update --all
    end

    for plugin in $plugins
        if test $plugin = python
            set latest2 (asdf list all python | grep \^2 | grep -Ev 'dev|b' | tail -n1)
            set latest3 (asdf latest python)

            asdf install python $latest3
            asdf install python $latest2
            asdf global python $latest3 $latest2
        else if test $plugin = java
            set latest (asdf list all java | grep temurin | grep -v jre | tail -n1)

            asdf install java $latest
            asdf global java $latest
        else if test $plugin = neovim
            asdf install neovim nightly
            asdf global neovim nightly
        else if test $plugin = perl
            set latest (asdf list all perl | grep -v RC | tail -n1)

            asdf install perl $latest
            asdf global perl $latest
        else
            set latest (asdf latest $plugin)

            asdf install $plugin $latest
            asdf global $plugin $latest
        end
    end
end
