function paco --wraps=/Volumes/T7/francinette/tester.sh --description 'alias paco /Volumes/T7/francinette/tester.sh'
    if test -e /Volumes/T7/francinette/tester.sh
        /Volumes/T7/francinette/tester.sh $argv
    else
        $HOME/francinette/tester.sh $argv
    end
end
