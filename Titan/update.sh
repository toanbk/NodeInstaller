#!/bin/bash

# Variables
VERSION="0.1.15"
BINARY_NAME="titand"

echo -e "\e[1m\e[32m2. Update Node --> \e[0m" && sleep 1

# Detect platform and save to variable
if [[ $(uname -m) == "aarch64" ]]; then
    platform="arm64"
elif [[ $(uname -m) == "x86_64" ]]; then
    platform="amd64"
else
    platform="unknown"
fi

FILE_NAME="titan_v${VERSION}_linux_${platform}"

sudo systemctl stop "$BINARY_NAME"

sudo wget https://github.com/Titannet-dao/titan-node/releases/download/v${VERSION}/${FILE_NAME}.tar.gz
sudo tar -xvzf ${FILE_NAME}.tar.gz && rm -rf ${FILE_NAME}.tar.gz
sudo chmod +x ${FILE_NAME}/*
sudo cp -rf ${FILE_NAME}/* /usr/local/bin/
sudo rm -rf ${FILE_NAME}

sudo systemctl restart "$BINARY_NAME"

echo -e "\n=============== UPDATE FINISHED ===================\n"
