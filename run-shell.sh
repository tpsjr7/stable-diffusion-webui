#!/bin/bash

cd "$(dirname $0)"

sudo docker run -it --rm --gpus all \
  -v $(pwd):/app \
  -v automatic-sdwui-root-profile:/root \
  -v automatic-sdwui-conda:/opt/conda/envs \
  -p 7860:7860 \
  automatic-stable-diffusion-web-ui bash
