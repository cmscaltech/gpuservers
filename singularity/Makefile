all: images/tflow_keras_latest.simg images/pytorch.simg images/cupy.simg images/julia.simg

images:
	mkdir -f images

images/tflow_keras_latest.simg: tflow_keras_latest.singularity
	sudo singularity build $@ $<

images/pytorch.simg: pytorch.singularity
	sudo singularity build $@ $<

images/cupy.simg: cupy.singularity
	sudo singularity build $@ $<

images/cupy-cuda-91.simg: cupy-cuda-91.singularity
	sudo singularity build $@ $<

images/julia.simg: julia.singularity
	sudo singularity build $@ $<

images/rapids.simg: rapids.singularity
	sudo singularity build $@ $<

images/legacy.simg: ibanks_legacy.singularity
	sudo singularity build $@ $<

images/edge.simg: cutting_edge.singularity
	sudo singularity build $@ $<

deploy:
	cp -R images/*.simg /nfshome/singularity/images/
	chown -R root:gpu-users /nfshome/singularity/
