if status is-login
    exit
end

set uname (uname -a)
set host (hostname)

fish_add_path -g $HOME/.local/bin

if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -e /Volumes/T7/homebrew/bin/brew
    eval (/Volumes/T7/homebrew/bin/brew shellenv)
else if test -e $HOME/homebrew/bin/brew
    eval ($HOME/homebrew/bin/brew shellenv)
end

if command -q brew
    set brew_prefix (brew --prefix)
    set -agx PKG_CONFIG_PATH $brew_prefix/opt/*/lib/pkgconfig
    fish_add_path -g $brew_prefix/opt/glibc/{,s}bin
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
    else # linux
    end
end

type -q mise && mise activate fish | source && mise completion fish | source
type -q starship && starship init fish | source
type -q direnv && direnv hook fish | source
type -q zoxide && zoxide init fish | source

if test -e $__fish_user_data_dir/plugins/plug.fish/conf.d/plugin_load.fish
    source $__fish_user_data_dir/plugins/plug.fish/conf.d/plugin_load.fish
else
    curl -L https://l0c.cc/plug.fish | source
end

bind \er __select_from_last
bind \e, __commandline_token_search_backward

test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

set -gx GPG_TTY (tty)

set -q SSH_AUTH_SOCK || set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh
