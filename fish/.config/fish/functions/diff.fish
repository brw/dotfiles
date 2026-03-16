function diff --description 'alias diff diff --width=(tput cols)'
    command diff --width=(tput cols) --color $argv
end
