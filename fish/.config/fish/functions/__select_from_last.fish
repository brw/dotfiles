function __select_from_last
   set -l FZF_OUT (eval $history[1] | fzf --select-1 --exit-0)
   set -l POS (commandline -C)
   if test -n "$FZF_OUT"
     commandline -a $FZF_OUT
     commandline -C (math ""(string length $FZF_OUT)" + $POS")
   end
end
