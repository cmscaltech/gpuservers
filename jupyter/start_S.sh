#!/bin/bash

mkdir /tmp/$USER/ipython -p
if [ -L $HOME/.ipython ] ; then
    echo "ipython set properly"
else
    echo "making a symlink for ipython"
    rm -rf $HOME/.ipython
    ln -s /tmp/$USER/ipython $HOME/.ipython
fi

img=/bigdata/shared/Software/singularity/ibanks/edge.simg
if [ ! -z $1 ] ; then
    echo using $1 as image
    img=$1
fi

## mount point need to be reviewed
set -x 
singularity/run.sh $img jupyter/start.sh

