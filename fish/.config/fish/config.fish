test -e $HOME/.homebrew/bin/brew && eval ($HOME/.homebrew/bin/brew shellenv)
source (command -sq brew && brew --prefix asdf || echo /opt/asdf-vm)/asdf.fish # source from brew if exists, otherwise use system-installed
command -sq starship && starship init fish | source
command -sq direnv && direnv hook fish | source
command -sq zoxide && zoxide init fish | source

bind \er __select_from_last
bind \e, __commandline_token_search_backward

if string match -q -- "*microsoft*" (uname -a)
  ulimit -n 65536 # no idea how to set this permanently in WSL

  set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock
  if not ss -a | grep -q $SSH_AUTH_SOCK
    rm -f $SSH_AUTH_SOCK
    setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/Bas/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",fork
  end
end

test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish
