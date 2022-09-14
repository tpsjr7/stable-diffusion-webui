#!/bin/bash

docker build -t automatic-stable-diffusion-web-ui .
sudo docker volume create automatic-sdwui-root-profile
sudo docker volume create automatic-sdwui-conda