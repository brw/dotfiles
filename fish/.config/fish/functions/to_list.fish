function to_list --wraps=tr\ \'\ \'\ \\n\ \|\ nl --description alias\ to_list\ tr\ \'\ \'\ \\n\ \|\ nl
  tr ' ' \n | nl $argv; 
end
