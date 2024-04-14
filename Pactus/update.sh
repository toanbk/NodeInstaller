#!/bin/bash

# Variables
VERSION="1.1.0"

echo -e "\e[1m\e[32m2. Update Node --> \e[0m" && sleep 1

# Detect platform and save to variable
if [[ $(uname -m) == "aarch64" ]]; then
    platform="arm64"
elif [[ $(uname -m) == "x86_64" ]]; then
    platform="amd64"
else
    platform="unknown"
fi

FILE_NAME="pactus-cli_${VERSION}_linux_${platform}"

sudo wget https://github.com/pactus-project/pactus/releases/download/v${VERSION}/${FILE_NAME}.tar.gz
sudo tar -xvzf ${FILE_NAME}.tar.gz && rm -rf ${FILE_NAME}.tar.gz
sudo chmod +x ${FILE_NAME}/*
sudo cp -rf ${FILE_NAME}/* node_pactus/
sudo rm -rf pactus-cli_${VERSION}*

echo -e "\n=============== UPDATE FINISHED ===================\n"
