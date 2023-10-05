function bastion365 --wraps='docker-compose -f /home/bas/dev/DBX.WebApp/docker-compose.yml' --description 'alias bastion365 docker-compose -f /home/bas/dev/DBX.WebApp/docker-compose.yml'
    docker-compose -f /home/bas/dev/DBX.WebApp/docker-compose.yml $argv
end
