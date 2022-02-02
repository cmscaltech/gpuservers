mkdir -p /tmp/$USER/cuda/
export CUDA_CACHE_PATH=/tmp/$USER/cuda/

python3 mnist_cnn_k2.py

python3 test_pytorch.py
 
