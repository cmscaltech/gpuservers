all: images/tflow_keras_latest.simg images/pytorch.simg images/cupy.simg images/julia.simg

images:
	mkdir -f images

images/tflow_keras_latest.simg: tflow_keras_latest.singularity
	./build $@ $<

images/pytorch.simg: pytorch.singularity
	./build $@ $<

images/cupy.simg: cupy.singularity
	./build $@ $<

images/cupy-cuda-91.simg: cupy-cuda-91.singularity
	./build $@ $<

images/julia.simg: julia.singularity
	./build $@ $<

images/rapids.simg: rapids.singularity
	./build $@ $<

images/legacy.simg: ibanks_legacy.singularity
	./build $@ $<

images/trackml.simg: trackml.singularity
	./build $@ $<

images/edge.simg: cutting_edge.singularity
	./build $@ $<

deploy:
	cp -R images/*.simg /bigdata/shared/Software/singularity/ibanks/
	chown -R root:gpu-users /bigdata/shared/Software/singularity/ibanks/
