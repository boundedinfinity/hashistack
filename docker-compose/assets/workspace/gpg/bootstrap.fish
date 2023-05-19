#!/usr/bin/env fish

set UID (id -u)

mkdir --verbose --parent /run/user/$UID
chown $UID /run/user/$UID
