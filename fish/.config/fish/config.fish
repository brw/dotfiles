test -e $HOME/.homebrew/bin/brew && eval ($HOME/.homebrew/bin/brew shellenv)
test -e /home/linuxbrew/.linuxbrew/bin/brew && eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
source (command -sq brew && test -d (brew --prefix asdf) && echo -n (brew --prefix asdf)"/libexec" || echo /opt/asdf-vm)/asdf.fish # source from brew if exists, otherwise use system-installed
command -sq starship && starship init fish | source
command -sq direnv && direnv hook fish | source
command -sq zoxide && zoxide init fish | source

bind \er __select_from_last
bind \e, __commandline_token_search_backward

if string match -q -- "*microsoft*" (uname -a)
  ulimit -n 65535 # no idea how to set this permanently in WSL

  set -gx DBUS_SESSION_BUS_ADDRESS unix:path=/run/user/1000/bus

  set -gx DEBUGINFOD_URLS "https://debuginfod.archlinux.org"

  set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock
  if not ss -a | grep -q $SSH_AUTH_SOCK
    rm -f $SSH_AUTH_SOCK
    setsid --fork socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/Bas/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
  end
else if string match -q -- "*codam.nl*" (hostname)
  ulimit -n 10240

  #set -gx HOMEBREW_CORE_GIT_REMOTE "https://github.com/gromgit/homebrew-core-mojave"
end

test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

set -gx plug_path $HOME/.local/share/fish/plug
fish_add_path -g $HOME/.homebrew/bin $HOME/bin

set -gx GPG_TTY (tty)
