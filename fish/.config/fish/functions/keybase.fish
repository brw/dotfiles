function keybase --wraps=keybase.exe --description 'alias keybase keybase.exe'
    if command -v keybase >/dev/null
        command keybase $argv
    else if command -v keybase.exe >/dev/null
        keybase.exe $argv
    else
        return 1
    end
end
