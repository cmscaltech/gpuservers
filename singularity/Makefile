all: images/pytorch.simg images/cupy.simg images/julia.simg images/legacy.simg images/edge.simg

images:
	mkdir -f images

images/cuda.simg: cuda.singularity
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
	cp -R images/*.simg /storage/af/group/gpu/software/singularity/ibanks/
	chown -R root:gpuusers /storage/af/group/gpu/software/singularity/ibanks/
