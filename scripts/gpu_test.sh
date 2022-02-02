mkdir -p /tmp/$USER/cuda/
export CUDA_CACHE_PATH=/tmp/$USER/cuda/

python3 test_keras.py

python3 test_pytorch.py
 
