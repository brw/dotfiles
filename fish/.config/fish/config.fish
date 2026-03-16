set uname (uname -a)
set host (hostname)

if status is-login && not set -q SSH_CLIENT && not set -q TMUX
    exit
end

fish_add_path -P $HOME/.local/bin

if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -e /Volumes/T7/homebrew/bin/brew
    eval (/Volumes/T7/homebrew/bin/brew shellenv)
else if test -e $HOME/homebrew/bin/brew
    eval ($HOME/homebrew/bin/brew shellenv)
else if test -e /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

if command -q brew
    set brew_prefix (brew --prefix)
    set -agx PKG_CONFIG_PATH $brew_prefix/opt/*/lib/pkgconfig
    fish_add_path -P $brew_prefix/opt/glibc/{,s}bin
end

if string match -q -- "*microsoft*" (uname -a)
    ulimit -n 65535 # no idea how to set this permanently in WSL

    set -gx DBUS_SESSION_BUS_ADDRESS unix:path=/run/user/1000/bus
    set -gx DEBUGINFOD_URLS "https://debuginfod.archlinux.org"
    set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock

    if not ss -a | grep -q $SSH_AUTH_SOCK
        rm -f $SSH_AUTH_SOCK
        setsid --fork socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/$user/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
    end
else if string match -q -- "*codam.nl*" $host && string match -q -- "*Darwin*" $uname
    ulimit -n 10240

    #set -gx HOMEBREW_CORE_GIT_REMOTE "https://github.com/gromgit/homebrew-core-mojave"
    set -gx HOMEBREW_TEMP /Volumes/T7/homebrew/tmp

    fish_add_path -P /Applications/CLion.app/Contents/bin/gdb/mac/bin
end

type -q mise && mise activate fish | source
test -f $HOME/.local/mise && $HOME/.local/mise activate fish | source
type -q direnv && direnv hook fish | source
type -q zoxide && zoxide init fish | source
type -q imdl && imdl completions --shell fish | source
# type -q carapace && carapace _carapace | source
type -q starship && starship init fish | source
type -q atuin && atuin init fish --disable-up-arrow | source
type -q keylightctl && keylightctl completion fish | source

# why does this break autocomplete for the tmux command
# test ! -e "$HOME/.x-cmd.root/local/data/fish/rc.fish" || source "$HOME/.x-cmd.root/local/data/fish/rc.fish"

# functions -c fish_prompt __fish_prompt
# function fish_prompt
#     set _status $status
#     echo "check $(date +%s%3N) $did_tmux_restore" | systemd-cat
#     if set -q did_tmux_restore
#         # functions -e fish_prompt
#         # functions -c __fish_prompt fish_prompt
#         # functions -e __fish_prompt
#         # printf '\e[u'
#         return
#     else
#         # forwarding the original $status to the actual prompt
#         test $_status -eq 0
#         __fish_prompt
#         # printf '\e[s'
#     end
# end

if test -e $__fish_user_data_dir/plugins/plug.fish/conf.d/plugin_load.fish
    source $__fish_user_data_dir/plugins/plug.fish/conf.d/plugin_load.fish
else
    if not set -q plugins
        set -Ux plugins https://github.com/kidonng/plug.fish
    end
    curl -L https://github.com/kidonng/plug.fish/raw/v3/conf.d/plugin_load.fish | source
end

bind \er __select_from_last
bind \e, __commandline_token_search_backward

test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

set -gx GPG_TTY (tty)

set -q SSH_AUTH_SOCK || set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh

set -l editors nvim vim vi
for editor in $editors
    if command -q $editor
        set -Ux EDITOR $editor
        set -Ux SYSTEMD_EDITOR $editor
        break
    end
end

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

# TODO: fix empty line on suspending again
# bind -M insert \cz 'functions -c fish_job_summary _fish_job_summary; function fish_job_summary; end; fg 2>/dev/null; commandline -f repaint; functions -e fish_job_summary; functions -c _fish_job_summary fish_job_summary; functions -e _fish_job_summary'
bind -M insert \cz 'fg; commandline -f repaint'
