#!/bin/bash


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
if [ -d "/t2data" ] ; then
    binding=$binding" -B /t2data"
fi
if [ -d "/mnt/hadoop" ] ; then
    binding=$binding" -B /mnt/hadoop"
fi
# Do not bind /storage as we need it to unmount and mount it back. One way is to kill all locks on /storage or make sure no one is mounting it. Once puppet is happy on gpu machines this can be re-enabled. See details here: https://github.com/cmscaltech/puppet-centos7/issues/603
# TODO: 2019-08-08 put it back next week (I hope no one is running workflows for a week)
#if [ -d "/storage" ] ; then
#    binding=$binding" -B /storage"
#fi

ex=""
img=/bigdata/shared/Software/singularity/ibanks/edge.simg
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
    XDG_RUNTIME_DIR="" JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity exec $binding --nv $img $ex
else
    XDG_RUNTIME_DIR="" JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity shell $binding --nv $img
fi
