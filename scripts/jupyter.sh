#!/bin/bash

if [ $# -eq 0 ] || [ "$1" == "-h" ]; then
    echo "jupyter wrapper. Usage:"
    echo "  $ jupyter.sh /path/to/singularity/image.simg port"
    echo "for example:"
    echo "  $ jupyter.sh /nfshome/singularity/images/tflow_keras_latest.simg 8180"
    exit 0
fi

#Choose singularity image
SINGULARITY_IMAGE=$1
if [ -z $SINGULARITY_IMAGE ]; then
    echo "singularity image must be specified, check the help (-h)"
    exit 1
fi
echo "Using singularity image $SINGULARITY_IMAGE"

PORT=$2
if [ -z $PORT ]; then
    echo "Port must be specified, check the help (-h)"
    exit 1
fi
echo "Using port $PORT"

JUPYTER_DATA_DIR=/tmp/$USER/jupyter LC_ALL=C singularity exec -B /data -B /nvmedata --nv $SINGULARITY_IMAGE jupyter notebook --certfile $HOME/mycert.pem --keyfile $HOME/mykey.key --ip 0.0.0.0 --port $PORT
