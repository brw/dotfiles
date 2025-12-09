function adb
    if command -v adb >/dev/null
        command adb $argv
    else if command -v adb.exe >/dev/null
        adb.exe $argv
    else
        echo "adb not found"
    end
end
