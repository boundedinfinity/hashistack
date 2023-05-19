#!/usr/bin/env fish

set -gx script_dir (cd (dirname (status -f)); and pwd)

cd $script_dir

docker network inspect cluster ;and docker network rm cluster
sudo rm -rf $script_dir/runtime