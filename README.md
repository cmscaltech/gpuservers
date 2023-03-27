# iBanks NVIDIA powered GPU cluster

## Nodes and Access

The head nodes `login-[1,2,3].hep.caltech.edu` are only used for submitting job in batch.

Worker nodes are a follows, in chronological order of creation
* `culture-plate-sm.hep.caltech.edu` is a Supermicro server with 2T of local SSD, and runs 8 NVidia GeForce GTX 1080
* `imperium-sm.hep.caltech.edu` is a Supermicro server with 2T of local SSD, and runs 8 NVidia GeForce GTX 1080
* `flere-imsaho-sm.hep.caltech.edu` is a Supermicro server with 2T of local SSD, and runs 6 NVidia Titan Xp
* `mawhrin-skel-sm.hep.caltech.edu` is a Supermicro server with 2T of local NVME running 2 NVidia GeForce GTX Titan X

All server have a public (regular network) and a private (10G) IP.
SSH key is the only authentication, with double factor authentication. Please let the admins (t2admin AT hep.caltech.edu) in case of issues.
 
## Credits

If you are a user of the cluster, we are happy to help make progress.
When producing publication or public presentation, please be so kind as to warn Prof. Spiropulu and Dr. Vlimant, just for accounting purpose.
Please include the following latex acknowledgement for support
```latex
Part of this work was conducted at  "\textit{iBanks}", the AI GPU cluster at Caltech. We acknowledge NVIDIA, SuperMicro  and the Kavli Foundation for their support of "\textit{iBanks}".
```

## Credentials

Follow the instructions for [Tier 2 access](https://tier2.hep.caltech.edu/?page_id=11) to get access to ibanks nodes.

### Data Storage

The home directory `/storage/af/user/<user name>` should be used for software and although there is room, please prevent from putting too much data within your home directory.

The `/data/` volume is mounted on some nodes, not all on SSD. This is the prefered temporary location for data needed for intensive I/O. **There is a 60-days-since-last-access retention policy on this directory**

The `/imdata/` volume is a ramdisk of 40G with very high throughput, but utilizing the RAM of the machine. Please use this in case of need of very high i/o, but clean the space tightly, as this will use the node memory. **There is a 2-days-since-last-access retention policy on this directory**.

The `/mnt/hadoop/` path is the readonly access to the full caltech Tier2 storage.

The `/storage/af/group/gpu/shared` path is a 120TB CEPH volume that can be used similarly to bigdata.
The old content of `/bigdata/shared` is now available under `/storage/af/group/gpu/bigdata`.

#### CERNbox

You can synchronize your cernbox with local directory `/storage/af/user/$USER/cernbox` by launching
```
/storage/af/group/gpu/software/gpuservers/scripts/sync-cernbox.sh
```
at least once interactively to setup the password. Then it can be run in the background, **on one node only**, using 
```
screen -S cernbox -d -m /storage/af/group/gpu/software/gpuservers/scripts/sync-cernbox.sh
```

### Setup

It is important to note that I/O on the nfs mounted volume is not as efficient as with local disk, so please use care and monitor performance of your applications.

For ipython, the following directory has to be local
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

### CVMFS

cvmfs is mounted on the nodes and can be used accordingly.

### Singularity

All the software is provided with singularity images located in `/storage/af/group/gpu/software/singularity/ibanks/`
Configuration of the images is located at https://github.com/cmscaltech/gpuservers/tree/master/singularity and in `/storage/af/group/gpu/software/singularity/`

| image | description |
|-------|-------------|
| legacy.simg | A fixed image with the software already installed on ibanks nodes |
| edge.simg | An image with many of the useful libraries, with the latest versions | 

Let admins know of any missing library that can be put in the image. A build service will be setup later.


To start a shell in an cutting edge image
<pre>
/storage/af/group/gpu/software/gpuservers/singularity/run.sh
</pre>
or to start with a given image
<pre>
/storage/af/group/gpu/software/gpuservers/singularity/run.sh /storage/af/group/gpu/software/singularity/ibanks/legacy.simg 
</pre>

#### Building an image
To build an image, first make sure that there are not an existing image that is usable, or extendable for your purpose. There are example of image specifications under the [singularity directory](https://github.com/cmscaltech/gpuservers/tree/master/singularity), to create your `specification.singularity` file
To build the image `myimage.simg` from the spec
<pre>
/storage/af/group/gpu/software/gpuservers/singularity/build myimage.simg specification.singularity
</pre>
if you make changes to existing image, please provide suggestion via a pull request modifying the specification file.

If you are building on top of an existing image, you can use that image as base and the build time will be greatly reduced. See an example with [building on top the edge image](https://github.com/cmscaltech/gpuservers/blob/master/singularity/over_edge.singularity).

##### Sandbox 
It might be practical to try live a singularity recipe instead of building it with test/fail. In this case, you need to create a sandbox and run it in writable mode and execute build commands that you can later copy back in the recipe

<pre>
singularity build --sandbox SANDBOXTOBECREATED/ existin.simg
singularity shell --writable SANDBOXTOBECREATED/
</pre>

an singularity image can be created back from the sandbox
<pre>
singularity build final.simg SANDBOXTOBECREATED/
</pre>

### Tensorflow

Tensorflow is greedy in using GPUs and it is mandatory to use `export CUDA_VISIBLE_DEVICES=n` (where n is the index of a device, or coma separated index) to use only a selected device, if not explicitly controlled within the application.
In python, please use `import setGPU` that selects automatically the next available GPU.

### Jupyter Hub

Work in progress to set this up properly on the cluster.

### Jupyter Notebook

The users can start a jupyter notebook server on each machine using either

<pre>
/storage/af/group/gpu/software/gpuservers/jupyter/start_S.sh
</pre>
 
 to start a notebook with the latest singularity image. Or 

<pre>
/storage/af/group/gpu/software/gpuservers/jupyter/start_S.sh /storage/af/group/gpu/software/singularity/ibanks/legacy.simg
</pre>
in a given image.

To start the notebook in screen directly:
<pre>
screen -S jupyter -d -m /storage/af/group/gpu/software/gpuservers/jupyter/start_S.sh
</pre>

This will provide back a url to which you can connect, including an authentication token, that changes each time you restart the jupyter server. You should keep this token private, but can also share momentarily to let other people edit your notebooks ; beware anyone with the token is "you".

To list the jupyter notebook already running on the machine, and the url to be used, one can run
<pre>
/storage/af/group/gpu/software/singularity/run.sh "jupyter notebook list"
</pre>

The port that is assigned to you is your user id, it should be opened automatically, let an admin know if it's not the case.

### MPI

mpi is available within nodes and accross nodes (as long as you have public-key pass-less ssh between nodes). 
To run a program with mpi
<pre>
mpirun --prefix /opt/openmpi-3.1.0 -np 3 nvidia-smi
</pre>

To run a program using singularity with mpi
<pre>
mpirun --prefix /opt/openmpi-3.1.0 -np 3 singularity exec -B /storage --nv /storage/af/group/gpu/software/singularity/ibanks/edge.simg python3 /storage/af/group/gpu/software/gpuservers/mpi/mpi4py-examples/03-scatter-gather
</pre>

To run accross nodes, first copy `/storage/af/group/gpu/software/gpuservers/mpi/mca-params.conf` into the `$HOME/.openmpi/` directory

<pre>
mpirun  --prefix /opt/openmpi-3.1.0 --hostfile /storage/af/group/gpu/software/gpuservers/mpi/hostfile -np 10 singularity exec -B /storage --nv /storage/af/group/gpu/software/singularity/ibanks/edge.simg python3 /storage/af/group/gpu/software/gpuservers/mpi/mpi4py-examples/03-scatter-gather
</pre>
