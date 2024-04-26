#!/bin/bash

read -r -p "Enter Node Name: " NODE_NAME

echo -e "\e[1m\e[32m1. Updating packages and dependencies--> \e[0m" && sleep 1

sudo apt update && apt upgrade -y
sudo apt install git curl wget -y && git config --global core.editor "vim" && sudo apt install make clang pkg-config libssl-dev build-essential -y 
sudo apt install tar wget clang pkg-config libssl-dev libleveldb-dev jq bsdmainutils git make ncdu htop lz4 screen bc fail2ban -y

IP_ADDRESS=$(curl eth0.me)

cd $HOME

curl -sSfL -O https://github.com/penumbra-zone/penumbra/releases/download/v0.73.0/pcli-x86_64-unknown-linux-gnu.tar.xz
unxz pcli-x86_64-unknown-linux-gnu.tar.xz
tar -xf pcli-x86_64-unknown-linux-gnu.tar
sudo mv pcli-x86_64-unknown-linux-gnu/pcli /usr/local/bin/

# confirm the pcli binary is installed by running:
pcli --version

curl -sSfL -O https://github.com/penumbra-zone/penumbra/releases/download/v0.73.0/pd-x86_64-unknown-linux-gnu.tar.xz
unxz pd-x86_64-unknown-linux-gnu.tar.xz
tar -xf pd-x86_64-unknown-linux-gnu.tar
sudo mv pd-x86_64-unknown-linux-gnu/pd /usr/local/bin/

# confirm the pd binary is installed by running:
pd --version

cd $HOME
mkdir cometbft_0.37.5
cd cometbft_0.37.5
wget https://github.com/cometbft/cometbft/releases/download/v0.37.5/cometbft_0.37.5_linux_amd64.tar.gz
sudo tar -xvzf cometbft_0.37.5_linux_amd64.tar.gz
mv cometbft /usr/local/bin/
chmod +x /usr/local/bin/cometbft
cometbft version

pd testnet unsafe-reset-all
pd testnet join --external-address ${IP_ADDRESS}:26656 --moniker ${NODE_NAME}

sleep 5

sudo tee /etc/systemd/system/penumbra.service > /dev/null << EOF
[Unit]
Description=Penumbra pd
Wants=cometbft.service

[Service]
# If both 1) running pd as non-root; and 2) using auto-https logic, then
# uncomment the capability declarations below to permit binding to 443/TCP for HTTPS.
# CapabilityBoundingSet=CAP_NET_BIND_SERVICE
# AmbientCapabilities=CAP_NET_BIND_SERVICE
ExecStart=/usr/local/bin/pd start
# Consider overriding the home directory, e.g.
# ExecStart=/usr/local/bin/pd start --home /var/www/.penumbra/testnet_data/node0/pd
Restart=no
User=$USER
# Raise filehandle limit for tower-abci.
LimitNOFILE=65536
# Consider configuring logrotate if using debug logs
# Environment=RUST_LOG=info,pd=debug,penumbra=debug,jmt=debug

[Install]
WantedBy=default.target
EOF

sudo tee /etc/systemd/system/cometbft.service > /dev/null << EOF
[Unit]
Description=CometBFT for Penumbra

[Service]
ExecStart=/usr/local/bin/cometbft start --home $HOME/.penumbra/testnet_data/node0/cometbft
Restart=no
User=$USER

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable penumbra.service && sudo systemctl enable cometbft.service
sudo systemctl restart penumbra cometbft

sudo journalctl -af -u penumbra -u cometbft
