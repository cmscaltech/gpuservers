FROM caltechcms/singleuser_cuda8_cudnn6_devel

USER root

RUN apt-get update
RUN apt-get install -y pciutils
RUN apt-get install -y cmake

## python 2 and 3
RUN apt-get install -y python
RUN apt-get install -y python-pip

## python 2 setup with legacy version of keras
RUN pip2 install keras==1.2.2
RUN pip2 install theano==0.9.0
#RUN apt-get install cython=0.25
RUN pip2 install Cython==0.25.2
RUN git clone https://github.com/Theano/libgpuarray.git && \
     	cd libgpuarray && \					
    	mkdir Build && \				
	cd Build && \				
	cmake .. -DCMAKE_BUILD_TYPE=Release && \
	make && \
	make install && \
	cd ../ && \
	python setup.py build && \
    	python setup.py install && \
    	cd ../ && \
    	rm -rf libgpuarray
RUN pip2 install tensorflow-gpu==0.12.0
RUN pip2 install pandas
RUN pip2 install tables
RUN pip2 install h5py

RUN apt-get install -y python3
RUN apt-get install -y python3-pip

## python 3 setup with  new version
RUN pip3 install --upgrade pip
RUN pip3 install keras
RUN pip3 install tensorflow-gpu
RUN pip3 install theano
#RUN conda install python=3.5 pygpu
RUN pip3 install pandas
RUN pip3 install tables
RUN pip3 install h5py

ADD theanorc ../.theanorc

RUN apt-get install -y ssh
RUN git clone https://github.com/HEPTrkX/heptrkx-dshep17.git

ENV KERAS_BACKEND theano
USER $NB_USER
