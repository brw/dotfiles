function spicetify
    if string match -q -- "*microsoft*" (uname -a)
        spicetify.exe $argv
    else
        command spicetify $argv
    end
end
