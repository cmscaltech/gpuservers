# iBanks NVIDIA powered GPU cluster

## Nodes and Access

The head node `ibanks.hep.caltech.edu` is running the nfs home and data server.
It has a public (regular network) and a private (10G) IP.

Worker nodes are a follows, in chronological order of creation
* `titans.hep.caltech.edu` is an MSI desktop with 2TB of local disk, and runs 2 NVidia GeForce GTX Titan X
* ~~`passed-pawn-klmx.hep.caltech.edu` is a cocolink server with 200G local disk, and runs 8  NVidia Titan X (Pascal)~~
* `culture-plate-sm.hep.caltech.edu` is a Supermicro server with 2T of local SSD, and runs 8 NVidia GeForce GTX 1080
* `imperium-sm.hep.caltech.edu` is a Supermicro server with 2T of local SSD, and runs 8 NVidia GeForce GTX 1080
* `flere-imsaho-sm.hep.caltech.edu` is a Supermicro server with 2T of local SSD, and runs 6 NVidia Titan Xp (Pasca)

All server have a public (regular network) and a private (10G) IP.
SSH key is the prefered authentication. Please let the admins know if you need help setting this up.

The linux password is not centralized yet, and you have to change it locally to secure access to jupyter notebooks.
 
## Credits

If you are a user of the cluster, we are happy to help make progress.
When producing publication or public presentation, please be so kind as to warn Prof. Spiropulu and Dr. Vlimant, just for accounting purpose.
Please include the following latex acknowledgement for support
```latex
Part of this work was conducted at  "\textit{iBanks}", the AI GPU cluster at Caltech. We acknowledge NVIDIA, SuperMicro  and the Kavli Foundation for their support of "\textit{iBanks}".
```

## Credentials

If you are not familiar on how to create an ssh key, from a remote client (your laptop) run the following command
<pre>
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
</pre>
and place the content of the public key in the .ssh/authorize_keys on the ibanks nfs home directory.

### Data Storage

The home directory should be used for software and although there is room, please prevent from putting too much data within your home directory.

The `/bigdata/` volume is mounted on all nodes. It is a 20TB raid array mounted over nfs. Please use the `/bigdata/shared/` directory and contact the admins if in the need for private directory.

The `/data/` volume is mounted on some nodes, not all on SSD. This is the prefered temporary location for data needed for intensive I/O.

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
It is recommended to have `export CUDA_CACHE_PATH` in your login file.

To use only a selected GPU, run `nvidia-smi` or `gpustat` to see GPU utilization, then set `export CUDA_VISIBLE_DEVICES=n` to a the index of the GPU you want to use.
In python one can either set the environment variable or use `import setGPU` (gets one device automatically).

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

One can add `base_compiledir=/tmp/$USER/theano_compile/` directly in the global section if need be.

### Tensorflow

Tensorflow is greedy in using GPUs and it is mandatory to use `export CUDA_VISIBLE_DEVICES=n` (where n is the index of a device, or coma separated index) to use only a selected device, if not explicitly controlled within the application.

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
The port that is assigned to you is defined in `/bigdata/shared/Software/jupyter/ports` if you are not in there, please contact an admin.

### MPI

mpi is installead on the cluster and will allow to run jobs across the cluster. For this, the main requirement is to have passwd-less access on all machines.
Setup your ssh key for authentication to the host
<pre>
mpi-ibanks
mpi-culture-plate-sm
mpi-imperium-sm
mpi-passed-pawn-klmx
mpi-titans
mpi-flere-imsaho-sm
</pre>
which run over the private IP.

Create the .openmpi directory and link the file `/bigdata/shared/Software/mpi/mca-params.conf` in it.

Run an mpi test with the command
<pre>
mpirun --hostfile /bigdata/shared/Software/mpi/hostfile -n 18 /bigdata/shared/Software/mpi/mpi4py-examples/03-scatter-gather

mpirun --hostfile /bigdata/shared/Software/mpi/hostfile -n 18 /bigdata/shared/Software/mpi/mpi4py-examples/08-matrix-matrix-product

mpirun --hostfile /bigdata/shared/Software/mpi/hostfile -n 10 /bigdata/shared/Software/mpi/keras_mnist.py
</pre>
which should both run. Contact the admin if it does not (the debugging options are `--mca odls_base_verbose 100 --mca btl_base_verbose 100`).

The default number of slots per node is the number of GPU (as this is the primary usage). One can override this limitation by running
<pre>
mpirun --map-by node --hostfile /bigdata/shared/Software/mpi/hostfile -n 100 /bigdata/shared/Software/mpi/mpi4py-examples/08-matrix-matrix-product
</pre>
