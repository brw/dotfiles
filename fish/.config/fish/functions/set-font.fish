function set-font
    gsettings set org.gnome.desktop.interface font-name $argv
    gsettings set org.gnome.desktop.interface document-font-name $argv
end
