#!/bin/bash
clear

sudo systemctl stop wardend.service

# set swap ram
sudo swapoff -a
sudo fallocate -l 24G /swapfile 
sudo chmod 600 /swapfile 
sudo mkswap /swapfile 
sudo swapon /swapfile 
free -mh

sudo sysctl vm.swappiness=10


# Download binary
rm -rf download && mkdir download
cd download && wget https://github.com/warden-protocol/wardenprotocol/releases/download/v0.3.2/wardend_Linux_x86_64.zip
unzip wardend_Linux_x86_64.zip
rm -rf wardend_Linux_x86_64.zip
chmod +x wardend
sudo mv wardend $(which wardend)

cd $HOME

# Set node CLI configuration
wardend config set client chain-id buenavista-1

# Initialize the node backup
wardend init "MyNode" --chain-id buenavista-1 --home $HOME/.wd

#backup old validator key
mv $HOME/.warden/config/priv_validator_key.json $HOME/.warden/config/priv_validator_key.json.bak

# copy new one
cp -rf $HOME/.wd/config/priv_validator_key.json $HOME/.warden/config/

# remove tmp dir
rm -rf $HOME/.wd

# Download genesis and addrbook files
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/warden/genesis.json --inet4-only
mv genesis.json ~/.warden/config

wget -O addrbook.json https://snapshots.polkachu.com/testnet-addrbook/warden/addrbook.json --inet4-only
mv addrbook.json ~/.warden/config

# set seeds and peers
SEEDS=""
PEERS="92ba004ac4bcd5afbd46bc494ec906579d1f5c1d@52.30.124.80:26656,ed5781ea586d802b580fdc3515d75026262f4b9d@54.171.21.98:26656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.warden/config/config.toml

# Set minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0025uward"|' $HOME/.warden/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.warden/config/app.toml

wardend tendermint unsafe-reset-all --home $HOME/.warden

# Download latest chain data snapshot
curl https://server-4.itrocket.net/testnet/warden/warden_2024-08-06_1575684_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden

# Create a service
sudo tee /etc/systemd/system/wardend.service > /dev/null << EOF
[Unit]
Description=Warden Protocol node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which wardend) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable wardend.service

# Start the service and check the logs
sudo systemctl start wardend.service
sudo journalctl -u wardend.service -f --no-hostname -o cat
