#!/bin/bash
#check for any already existing server
existing=`ps -f -u $USER | grep jupyter | grep  notebook | grep config | grep -v grep | wc -l `
echo $existing
if [ $existing -eq "0" ] ; then
    jupyter notebook --config   /storage/group/gpu/software/gpuservers/jupyter/jupyter_notebook_config_S.py
else
    echo "user $USER has existing notebooks running already"
    ps -f -u $USER | grep jupyter
    ## should this be killed by default?
fi
