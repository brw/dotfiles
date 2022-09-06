function winget --wraps='cmd.exe /c winget.exe' --description 'alias winget=cmd.exe /c winget.exe'
  cd /mnt/c
  cmd.exe /c winget.exe $argv 
  cd -
end
