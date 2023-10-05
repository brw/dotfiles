set uname (uname -a)
set host (hostname)

if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -e /Volumes/T7/homebrew/bin/brew
    eval (/Volumes/T7/homebrew/bin/brew shellenv)
else if test -e $HOME/homebrew/bin/brew
    eval ($HOME/homebrew/bin/brew shellenv)
end

if string match -q -- "*microsoft*" (uname -a)
    ulimit -n 65535 # no idea how to set this permanently in WSL

    set -gx DBUS_SESSION_BUS_ADDRESS unix:path=/run/user/1000/bus
    set -gx DEBUGINFOD_URLS "https://debuginfod.archlinux.org"
    set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock

    if not ss -a | grep -q $SSH_AUTH_SOCK
        rm -f $SSH_AUTH_SOCK

        if string match -iq -- bamibal $host
            set -gx user Bas # I don't remember what this is for but it's here now
        end

        setsid --fork socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/$user/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
    end
else if string match -q -- "*codam.nl*" $host
    if string match -q -- "*Darwin*" $uname
        ulimit -n 10240

        #set -gx HOMEBREW_CORE_GIT_REMOTE "https://github.com/gromgit/homebrew-core-mojave"
        set -gx HOMEBREW_TEMP /Volumes/T7/homebrew/tmp

        fish_add_path -g /Applications/CLion.app/Contents/bin/gdb/mac/bin
    else
        fish_add_path -g $HOME/.local/bin

        # the horror that is compiling python using rtx/pyenv on Linux with homebrew libs
        set -gx PKG_CONFIG_PATH \
            (brew --prefix readline)/lib/pkgconfig \
            (brew --prefix openssl)/lib/pkgconfig \
            (brew --prefix sqlite3)/lib/pkgconfig \
            (brew --prefix tcl-tk)/lib/pkgconfig \
            (brew --prefix zlib)/lib/pkgconfig \
            (brew --prefix bzip2)/lib/pkgconfig
    end
end

command -sq rtx && rtx activate fish | source && rtx completion fish | source
command -sq starship && starship init fish | source
command -sq direnv && direnv hook fish | source
command -sq zoxide && zoxide init fish | source

bind \er __select_from_last
bind \e, __commandline_token_search_backward

test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

set -gx plug_path $HOME/.local/share/fish/plug
set -gx GPG_TTY (tty)
