FROM tensorflow/tensorflow:latest-gpu-py3-jupyter

COPY . /AdamNet/

RUN pip install pandas
RUN pip install keras

WORKDIR /AdamNet/

ENTRYPOINT jupyter notebook


