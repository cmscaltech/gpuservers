## Usage

The recipe to build the singularity image is in tflow_keras_latest.singularity. Use `make` to build the image.

## Running the image

The jupyter notebook can be run with:
~~~
JUPYTER_RUNTIME_DIR=/tmp/$USER/jupyter-runtime singularity exec --nv images/tflow_keras_latest.simg jupyter notebook --port 8888 --ip 0.0.0.0
~~~
