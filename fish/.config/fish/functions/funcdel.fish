function funcdel --argument func
    functions -e $func
    if test -e ~/.config/fish/functions/$func.fish
        rm ~/.config/fish/functions/$func.fish
        echo "Deleted function '$func'"
    else
        echo "Couldn't find function '$func'"
    end
end
