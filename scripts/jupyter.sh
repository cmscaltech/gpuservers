#!/bin/bash

if [ $1 == "-h" ]; then
    echo "jupyter wrapper. Usage:"
    echo "  $ jupyter.sh /path/to/singularity/image.simg"
    exit 0
fi

#Choose singularity image
SINGULARITY_IMAGE=$1
if [ -z $SINGULARITY_IMAGE ]; then
    SINGULARITY_IMAGE=/nfshome/singularity/images/tflow_keras_latest.simg
fi
echo "Using singularity image $SINGULARITY_IMAGE"

JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity exec -B /data --nv $SINGULARITY_IMAGE jupyter notebook --ip 0.0.0.0
