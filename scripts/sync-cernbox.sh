#!/bin/bash

set -x 

if [ ! -r ~/.cernbox.pass ] ; then
    rm ~/.cernbox.pass
    echo password for cernbox
    read -s pass
    echo $pass > ~/.cernbox.pass
    chmod 600 ~/.cernbox.pass
fi

dest_dir=/storage/user/$USER/cernbox
mkdir -p $dest_dir
cern_user=$USER
cern_i=${cern_user:0:1}
#server=cernbox.cern.ch 
server=https://cernbox.cern.ch/cernbox/desktop/remote.php/webdav/eos/user/$cern_i/$cern_user
ping=2

while [ 1 ]; do
    cat ~/.cernbox.pass | cernboxcmd --user $cern_user $dest_dir $server &> /dev/null
    sleep $ping
done
