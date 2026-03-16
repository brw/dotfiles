# from https://gist.github.com/NotTheDr01ds/6357e48b511735c42b94c4cc081ac5dc
# from https://stackoverflow.com/a/70491301/5082094
function fish_load_sudo_alias
    function sudo
        if functions -q -- "$argv[1]"
            # Create a string which quotes each of the original arguments
            # so that they can be safely passed into the new fish
            # instance that is called by sudo.
            set cmdline (
                for arg in $argv
                    printf "\"%s\" " $arg
                end
            )
            # We need to pass the function source to another fish instance.
            # Since it is multi-line, any attempt to store the function in a
            # variable results in an array, which also can't be passed to
            # another fish instance.
            #
            # So first we escape the existing function (mostly in case it
            # has '\n' literals in it, then we join it on "\n".
            #
            # After passing it into fish, the new shell splits it,
            # unescapes it, and passes the function declaration to
            # `source`, which loads it into memory in the new shell.
            set -x function_src (string join "\n" (string escape --style=var (functions "$argv[1]")))
            set argv fish -c 'string unescape --style=var (string split "\n" $function_src) | source; '$cmdline
            command sudo -E $argv
        else
            command sudo $argv
        end
    end
end
