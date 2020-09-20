mkdir -p /tmp/$USER/cuda/
export CUDA_CACHE_PATH=/tmp/$USER/cuda/

python2 mnist_cnn_k1.py
python3 mnist_cnn_k2.py

python2 test_pytorch.py
python3 test_pytorch.py
 
