FROM continuumio/miniconda3:4.12.0

SHELL ["/bin/bash", "-ceuxo", "pipefail"]
RUN mkdir /app
WORKDIR /app
RUN apt-get update && \
    apt install -y \
    fonts-dejavu-core \
    rsync \
    vim \
    git \
    && apt-get clean

