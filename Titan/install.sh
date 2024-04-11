#!/bin/bash

# Variables
VERSION="0.1.16"
BINARY_NAME="titand"
RPC_URL="https://test-locator.titannet.io:5000/rpc/v0"
BINDING_URL="https://api-test1.container1.titannet.io/api/v2/device/binding"


read -r -p "Enter identity code: " ID_CODE

echo -e "\e[1m\e[32m1. Updating packages and dependencies--> \e[0m" && sleep 1
sudo apt install git curl wget tar zip unzip -y

echo -e "\e[1m\e[32m2. Install Node --> \e[0m" && sleep 1

sudo wget https://github.com/Titannet-dao/titan-node/releases/download/v${VERSION}/titan_v${VERSION}_linux_amd64.tar.gz
sudo tar -xvzf titan_v${VERSION}_linux_amd64.tar.gz && rm -rf titan_v${VERSION}_linux_amd64.tar.gz
sudo chmod +x titan_v${VERSION}_linux_amd64/*
sudo cp -rf titan_v${VERSION}_linux_amd64/* /usr/local/bin/
sudo rm -rf titan_v${VERSION}_linux_amd64

sudo titan-edge daemon start --init --url "$RPC_URL" > /dev/null 2>&1 &

# Wait for 10 seconds
sleep 10

# Kill the titan-edge daemon
pkill -9 titan-edge

sleep 5

sudo tee /etc/systemd/system/titand.service > /dev/null << EOF
[Unit]
Description=Titan Node
After=network-online.target
StartLimitIntervalSec=0
[Service]
User=$USER
Restart=always
RestartSec=3
LimitNOFILE=65535
ExecStart=titan-edge daemon start

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload 
sudo systemctl enable "$BINARY_NAME"
sudo systemctl restart "$BINARY_NAME"

sleep 10

# connect the node
# titan-edge bind --hash="$ID_CODE" "$BINDING_URL" &

bind_command="titan-edge bind --hash=$ID_CODE $BINDING_URL"

echo -e "\n=============== PLEASE COPY AND RUN THIS COMMAND: ===================\n"
echo -e "\e[1m\e[32m$bind_command \e[0m"
echo -e "\n=====================================================\n"

echo -e "\n=============== SETUP FINISHED ===================\n"
