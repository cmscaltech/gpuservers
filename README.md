# iBanks NVIDIA powered GPU cluster

## Nodes and Access

The head node <pre>ibanks.hep.caltech.edu</pre> is running the nfs home and data server.
It has a public (regular network) and a private (10G) IP.

Worker nodes are a follows, in chronological order.
* <pre>titans.hep.caltech.edu</pre>is an MSI desktop with 2TB of local disk, and runs 2 NVidia GeForce GTX Titan X
* <pre>passed-pawn-klmx.hep.caltech.edu</pre> is a cocolink server with 200G local disk, and runs 8  NVidia Titan X (Pascal)
* <pre>culture-plate-sm.hep.caltech.edu</pre> is a Supermicro server with 2T of local SSD, and runs 8 NVidia GeForce GTX 1080
* <pre>imperium-sm.hep.caltech.edu</pre> is a Supermicro server with 2T of local SSD, and runs 8 NVidia GeForce GTX 1080
* <pre>flere-imsaho-sm.hep.caltech.edu</pre> is a Supermicro server, and runs 6 NVidia Titan Z (Pascal) *to be commissioned*

All server have a public (regular network) and a private (10G) IP.
SSH key is the prefered authentication. Please let the admins know if you need help setting this up.

### Data Storage

The home directory should be used for software and although there is room, please prevent from putting too much data within your home directory.

The <pre>/bigdata/</pre> volume is mounted on all nodes. It is a 20TB raid array mounted over nfs. Please use the <pre>/bigdata/shared/</pre> directory and contact the admins if in the need for private directory.

The <pre>/data/</pre> volume is mounted on some nodes, not all on SSD. This is the prefered temporary location for data needed for intensive I/O.

The 

### Setup

It is important to note that I/O on the nfs mounted volume is not as efficient as with local disk, so please use care and monitor performance of your applications.

For ipython, the following directory better be local
<pre>
mkdir /tmp/$USER/ipython -p
ln -s /tmp/$USER/ipython .ipython
</pre>

For cuda, the same applies to
<pre>
mkdir -p /tmp/$USER/cuda/
export CUDA_CACHE_PATH=/tmp/$USER/cuda/      
</pre>
It is recommended to have <pre>export CUDA_CACHE_PATH</pre> in your login file.

To use only a selected GPU, run <pre>nvidia-smi</pre> or <pre>gpustat</pre> to see GPU utilization, then set <pre>export CUDA_VISIBLE_DEVICES=n</pre> to a the index of the GPU you want to use.
In python one can either set the environment variable or use <pre>import setGPU</pre> (gets one device automatically).

## Software

### Theano

The compilation directory might be better off being a local directory, like in /tmp
<pre>
mkdir -p /tmp/$USER/theano_compile
rm -r ~/.theano
ln -s /tmp/$USER/theano_compile ~/.theano
</pre>

The theano rc file should look like
<pre>
[nvcc]
[global]
device=cuda
</pre>

One can add <pre>base_compiledir=/tmp/$USER/theano_compile/</pre> directly in the global section if need be.

### Tensorflow

Tensorflow is greedy in using GPUs and it is mandatory to use <pre>export CUDA_VISIBLE_DEVICES=n</pre> (where n is the index of a device, or coma separated index) to use only a selected device, if not explicitly controlled within the application.

### Jupyter Hub

We are building some docker images that are posted on dockerhub: https://hub.docker.com/u/caltechcms/

### Jupyter Notebook

The users can start a jupyter notebook server on each machine using the command

<pre>
source /bigdata/shared/Software/jupyter/restart.sh
</pre>

This will provide back a url to which you can connect.
The password is the linux password.
If you are connecting using ssh key, as recommended, please contact an admin to get a password.
The port that is assigned to you is defined in <pre>/bigdata/shared/Software/jupyter/ports</pre> if you are not in there, please contact an admin.


