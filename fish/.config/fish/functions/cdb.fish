function cdb --description 'cd to the base directory of a file'
    isatty || read -az stdin && set -a argv $stdin
    cd (dirname $argv)
end
