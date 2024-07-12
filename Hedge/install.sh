#!/bin/bash
clear

if [[ ! -f "$HOME/.bash_profile" ]]; then
    touch "$HOME/.bash_profile"
fi

if [ -f "$HOME/.bash_profile" ]; then
    source $HOME/.bash_profile
fi

logo_nodesync(){

clear

 cat << "EOF"
=========================================================================
     _   _           _       ____
    | \ | |         | |     / ___|
    |  \| | ___   __| | ___| (__  _   _ ___    __   _____  ___  ___
    |     |/ _ \ / _  |/ __\\__ \| | | |  _ \ / _| |_   _|/ _ \|  _ \
    | |\  | (_) | (_) | /o_ ___) | |_| | | | | (_ _  | | | (_) | |_) |
    |_| \_|\___/ \____|\___|____/ \__  |_| |_|\__(_) |_|  \___/|  _ /
                                    _/ |                       | |
                                   |__/                        |_|

=========================================================================
             Developed by: NodeSync.Top
             Twitter: https://twitter.com/nodesync_top
             Telegram: https://t.me/nodesync_top
=========================================================================
EOF

}

logo_nodesync;



echo "===========Hedge Install Easy======= " && sleep 1

read -p "Do you want run node Hedge ? (y/n): " choice

if [ "$choice" == "y" ]; then

sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

#Install GO
ver="1.22.3"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

set -eux; \
  wget -O /lib/libwasmvm.x86_64.so https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so


cd $HOME
wget -O hedged https://github.com/hedgeblock/testnets/releases/download/v0.1.0/hedged_linux_amd64_v0.1.0 &&\
chmod +x hedged
sudo mv hedged /usr/local/bin
hedged version

hedged config chain-id berberis-1
hedged config keyring-backend file
hedged init MyNode --chain-id berberis-1

wget -O $HOME/.hedge/config/genesis.json "https://raw.githubusercontent.com/nodesynctop/Hedge/main/genesis.json"
curl -Ls https://snapshots.aknodes.net/snapshots/hedge/addrbook.json > $HOME/.hedge/config/addrbook.json

# Set Pruning, Enable Prometheus, Gas Prices, and Indexer
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sudo sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.hedge/config/app.toml

sudo sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.hedge/config/app.toml

sudo sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.hedge/config/app.toml

sudo sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.hedge/config/config.toml

sudo sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.hedge/config/config.toml

sudo sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uhedge\"/" $HOME/.hedge/config/app.toml

cd $HOME
PEERS=$(curl -s --max-time 3 --retry 2 --retry-connrefused "https://rpc-hedge-testnet.trusted-point.com/peers.txt")
if [ -z "$PEERS" ]; then
    echo "No peers were retrieved from the URL."
else
    echo -e "\nPEERS: "$PEERS""
    sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" "$HOME/.hedge/config/config.toml"
    echo -e "\nConfiguration file updated successfully.\n"
fi

source $HOME/.bash_profile
sudo tee /etc/systemd/system/hedged.service > /dev/null <<EOF
[Unit]
Description=hedged Daemon
After=network-online.target
[Service]
User=root
ExecStart=$(which hedged) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

curl http://188.245.45.171/snapshot-hedge.AKNodes.lz4 | lz4 -dc - | tar -xf - -C $HOME/.hedge

sudo systemctl daemon-reload
sudo systemctl enable hedged
sudo systemctl restart hedged && sudo journalctl -u hedged -f --no-hostname -o cat

echo "===================Install Success==================="

else

echo "Not installed"

fi
