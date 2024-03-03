#!/bin/bash

read -r -p "Enter RPC username: " NODE_NAME
read -r -p "Enter RPC password: " NODE_PASSWORD

mkdir $HOME/chavinci && cd $HOME/chavinci
wget https://github.com/chavinci-chain/chavinci-releases/releases/download/1.0.3/chavinci-linux.zip && unzip chavinci-linux.zip
rm -rf $HOME/.chachain
mkdir $HOME/.chachain && cd $HOME/.chachain

tee chachain.conf > /dev/null << EOF
rpcuser=${NODE_NAME}
rpcpassword=${NODE_PASSWORD}
daemon=1
testnet=1
staking=1
EOF

cd $HOME/chavinci
chmod +x chad cha-cli

sleep 1
echo -e "=============== Server starting, wait 10 seconds ... ==================="

./chad

sleep 10

./cha-cli getblockchaininfo

./cha-cli addnode 157.245.19.145:22833 add
./cha-cli addnode 146.190.207.106:22833 add
./cha-cli addnode 139.59.207.170:22833 add

sleep 5

./cha-cli getblockchaininfo

echo -e "=============== SETUP FINISHED ==================="
echo -e "Check info:            ${CYAN} cd $HOME/chavinci && ./cha-cli getblockchaininfo ${NC}"
