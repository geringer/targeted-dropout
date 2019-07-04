FROM tensorflow/tensorflow:latest-gpu-py3-jupyter

COPY . /AdamNet/

WORKDIR /AdamNet/

ENTRYPOINT jupyter notebook


