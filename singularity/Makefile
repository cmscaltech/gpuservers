all: images/tflow_keras_latest.simg

images:
	mkdir -f images

images/tflow_keras_latest.simg: images tflow_keras_latest.singularity
	sudo singularity build $@ $<
