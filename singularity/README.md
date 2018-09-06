## Usage

The image file needs to be built as root:

~~~
sudo singularity build tflow_keras.simg tflow_keras.singularity
~~~

With the image file at hand, the notebook can be started with

~~~
JUPYTER_RUNTIME_DIR=/home/jpata/jupyter-runtime singularity exec --nv tflow_keras.simg jupyter notebook
~~~
