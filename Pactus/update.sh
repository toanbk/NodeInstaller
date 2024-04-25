#!/bin/bash

# Variables
VERSION="1.1.3"

echo -e "\e[1m\e[32m2. Update Node --> \e[0m" && sleep 1

# Detect platform and save to variable
if [[ $(uname -m) == "aarch64" ]]; then
    platform="arm64"
elif [[ $(uname -m) == "x86_64" ]]; then
    platform="amd64"
else
    platform="unknown"
fi

DIRECTORY_NAME="pactus-cli_${VERSION}"
FILE_NAME="pactus-cli_${VERSION}_linux_${platform}"

sudo wget https://github.com/pactus-project/pactus/releases/download/v${VERSION}/${FILE_NAME}.tar.gz
sudo tar -xvzf ${FILE_NAME}.tar.gz && rm -rf ${FILE_NAME}.tar.gz
sudo chmod +x ${DIRECTORY_NAME}/*
sudo cp -rf ${DIRECTORY_NAME}/* node_pactus/
sudo rm -rf ${DIRECTORY_NAME}

echo -e "\n=============== UPDATE FINISHED ===================\n"
