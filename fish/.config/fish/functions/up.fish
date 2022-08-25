function up --description='upgrade everything'
  sudo apt update && sudo apt full-upgrade && sudo apt autoremove && brew upgrade --fetch-head && latest $argv; 
end
