#!/bin/bash

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
server=cernbox.cern.ch 
ping=2

while [ 1 ]; do
    cat ~/.cernbox.pass | cernboxcmd --user $cern_user $dest_dir $server &> /dev/null
    sleep $ping
done
