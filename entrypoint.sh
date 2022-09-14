#!/bin/bash

cd /app


if ! conda env list | grep automatic ; then
    conda env create -f environment-wsl2.yaml
    echo "conda activate automatic" >> /root/.bashrc
    source /root/.bashrc

    mkdir -p ./embeddings
    mkdir -p repositories
    git clone https://github.com/CompVis/stable-diffusion.git repositories/stable-diffusion
    git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers
    git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer
    git clone https://github.com/salesforce/BLIP.git repositories/BLIP

    pip install opencv-python-headless==:4.1.2.30
    # install requirements of Stable Diffusion
    pip install transformers==4.19.2 diffusers invisible-watermark --prefer-binary

    # install k-diffusion
    pip install git+https://github.com/crowsonkb/k-diffusion.git --prefer-binary

    # (optional) install GFPGAN (face resoration)
    pip install git+https://github.com/TencentARC/GFPGAN.git --prefer-binary

    # (optional) install requirements for CodeFormer (face resoration)
    pip install -r repositories/CodeFormer/requirements.txt --prefer-binary

    # install requirements of web ui
    pip install -r requirements.txt  --prefer-binary

    # update numpy to latest version
    pip install -U numpy  --prefer-binary

else
    source /root/.bashrc
fi

function validateDownloadModel() {
    local file=$1
    local path=$2
    local url=$3
    local hash=$4

    echo "checking ${file}..."
    sha256sum --check --status <<< "${hash} ${path}/${file}"
    if [[ $? == "1" ]]; then
        echo "Downloading: ${url} please wait..."
        mkdir -p ${path}
        wget --output-document=${path}/${file} --no-verbose --show-progress --progress=dot:giga ${url}
        echo "saved ${file}"
    else
        echo "${file} is valid!"
    fi
}

validateDownloadModel model.ckpt ./ https://www.googleapis.com/storage/v1/b/aai-blog-files/o/sd-v1-4.ckpt?alt=media fe4efff1e174c627256e44ec2991ba279b3816e364b49f9be2abc0b3ff3f8556
validateDownloadModel GFPGANv1.3.pth ./ https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth c953a88f2727c85c3d9ae72e2bd4846bbaf59fe6972ad94130e23e7017524a70

python webui.py --listen