all: images/tflow_keras_latest.simg images/pytorch.simg

images:
	mkdir -f images

images/tflow_keras_latest.simg: tflow_keras_latest.singularity
	sudo singularity build $@ $<

images/pytorch.simg: pytorch.singularity
	sudo singularity build $@ $<

images/cupy.simg: cupy.singularity
	sudo singularity build $@ $<


deploy:
	cp -R images /nfshome/singularity/
	chown -R root:gpu-users /nfshome/singularity/
