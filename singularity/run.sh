#!/bin/bash

set -x
binding=""
if [ -d "/nfshome" ] ; then
    binding=$binding" -B /nfshome"
fi
if [ -d "/etc/grid-security/letsencrypt" ] ; then
    binding=$binding" -B /etc/grid-security/letsencrypt"
fi
if [ -d "/data" ] ; then
    binding=$binding" -B /data"
fi
if [ -d "/bigdata" ] ; then
    binding=$binding" -B /bigdata"
fi
if [ -d "/imdata" ] ; then
    binding=$binding" -B /imdata"
fi
if [ -d "/mnt/hadoop" ] ; then
    binding=$binding" -B /mnt/hadoop"
fi
if [ -d "/storage" ] ; then
    binding=$binding" -B /storage"
fi
if [ -d "/cvmfs" ] ; then
    binding=$binding" -B /cvmfs"
fi

ex=""
img=/storage/af/group/gpu/software/singularity/ibanks/edge.simg
if [ ! -z $1 ] ; then
    if [ -r $1 ] ; then
	echo using $1 as image
	img=$1
	ex=$2
    else
	ex=$1
    fi
else
    ex=$1
fi

set -x 
## mount point need to be reviewed
if [ ! -z "$ex" ] ; then
    if [ "$ex" == "test" ] ; then
	XDG_RUNTIME_DIR="" JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity run $binding --nv $img
    else
	XDG_RUNTIME_DIR="" JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity exec $binding --nv $img $ex
    fi
else
    XDG_RUNTIME_DIR="" JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity shell $binding --nv $img
fi
