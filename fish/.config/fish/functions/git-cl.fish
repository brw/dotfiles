function git-cl --wraps 'git clone' --description 'git clone and cd'
    git clone $argv && cd (string replace -r '.*/' '' $argv[-1])
end
