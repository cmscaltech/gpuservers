FROM caltechcms/singleuser_cuda8_cudnn6_devel
LABEL maintainer "Caltech HEP Group <ml@hep.caltech.edu>"


USER root

RUN apt-get update
RUN apt-get install -y pciutils
RUN apt-get install -y cmake
RUN apt-get install -y git

## python 2 and 3
RUN apt-get install -y python
RUN apt-get install -y python-pip
RUN pip install --upgrade pip
RUN pip install ipython

## python 2 setup with legacy version of keras
RUN conda install -p $CONDA_DIR/envs/python2 pygpu \
    keras==1.2.2 \
    theano==0.9.0 \
    pandas \
    h5py \
    tqdm

RUN pip2 install tensorflow-gpu==0.12.0 tables

RUN conda install pygpu \
    keras \
    tensorflow-gpu \
    theano \
    pandas \
    h5py \
    tqdm

RUN pip3 install tables

ADD theanorc ../.theanorc

RUN apt-get install -y ssh

ENV KERAS_BACKEND theano
USER $NB_USER
