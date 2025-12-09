function fastboot --wraps=fastboot.exe --description 'alias fastboot=fastboot.exe'
    if command -v fastboot >/dev/null
        command fastboot $argv
    else if command -v fastboot.exe >/dev/null
        fastboot.exe $argv
    else
        echo "fastboot not found"
    end
end
