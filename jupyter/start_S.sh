#!/bin/bash

mkdir /tmp/$USER/ipython -p
if [ -L $HOME/.ipython ] ; then
    echo "ipython set properly"
else
    echo "making a symlink for ipython"
    rm -rf $HOME/.ipython
    ln -s /tmp/$USER/ipython $HOME/.ipython
fi

img=/storage/group/gpu/software/singularity/ibanks/edge.simg
if [ ! -z $1 ] ; then
    echo using $1 as image
    img=$1
fi

## mount point need to be reviewed
set -x 
/storage/group/gpu/software/singularity/run.sh $img /storage/group/gpu/software/gpuservers/jupyter/start.sh

