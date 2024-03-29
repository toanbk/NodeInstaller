#!/bin/bash

# Variables
VERSION="0.1.15"
BINARY_NAME="titand"

echo -e "\e[1m\e[32m2. Install Node --> \e[0m" && sleep 1

sudo systemctl stop "$BINARY_NAME"

sudo wget https://github.com/Titannet-dao/titan-node/releases/download/${VERSION}/titan_v${VERSION}_linux_amd64.tar.gz
sudo tar -xvzf titan_v${VERSION}_linux_amd64.tar.gz && rm -rf titan_v${VERSION}_linux_amd64.tar.gz
sudo chmod +x titan_v${VERSION}_linux_amd64/*
sudo cp -rf titan_v${VERSION}_linux_amd64/* /usr/local/bin/
sudo rm -rf titan_v${VERSION}_linux_amd64

sudo systemctl restart "$BINARY_NAME"

echo -e "\n=============== UPDATE FINISHED ===================\n"
