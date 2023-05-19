#!/usr/bin/env fish

set -gx script_dir (cd (dirname (status -f)); and pwd)

cd $script_dir

docker network inspect cluster ;or docker network create cluster
docker compose build workspace ;or exit 1

# https://fishshell.com/docs/current/cmds/history.html#customizing-the-name-of-the-history-file
set dirs .config/fish .local/share/fish .local/state .cache

for dir in $dirs
    mkdir --verbose --parents runtime/workspace/$dir
end

# set -gx UID (id -u)
# set -gx GID (id -u)

docker compose run workspace fish