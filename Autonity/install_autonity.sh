#!/bin/bash

AUT_VERSION="0.13.0"

NETWORK_NAME="piccadilly"
BINARY_NAME="autonityd"
KEYSTORE_DIR="$HOME/piccadilly-keystore"
DATA_DIR="$HOME/autonity-client/autonity-chaindata"
STATIC_NODE_URL="https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/static-nodes.json"

sudo mkdir -p $DATA_DIR

install_expect() {
    sudo apt install -y expect
}

# Function to create account using aut command
create_account() {
    local keyfile="$1"
    local password="$2"

    expect << EOF
    spawn aut account new --keyfile $keyfile
    expect "Password for new account:"
    send "$password\r"
    expect "Confirm account password:"
    send "$password\r"
    expect eof
EOF
}

read -r -p "Enter new wallet password: " WALLET_PASSWORD

echo -e "\e[1m\e[32m1. Updating packages and dependencies--> \e[0m" && sleep 1

sudo apt update && apt upgrade -y
sudo apt install git curl wget -y && git config --global core.editor "vim" && sudo apt install make clang pkg-config libssl-dev build-essential -y 
sudo apt install tar wget clang pkg-config libssl-dev libleveldb-dev jq bsdmainutils git make ncdu htop lz4 screen bc fail2ban -y

sudo apt install pipx -y

# Check if expect is installed, if not, install it
if ! command -v expect &>/dev/null; then
    echo "Expect is not installed. Installing..."
    install_expect
fi

pipx install --force git+https://github.com/autonity/aut.git
pipx ensurepath

if ! grep -qF 'export PATH="$PATH:/root/.local/bin"' ~/.bash_profile; then
    echo 'export PATH="$PATH:/root/.local/bin"' >> ~/.bash_profile
fi
source ~/.bash_profile

mkdir $KEYSTORE_DIR

create_account "$KEYSTORE_DIR/wallet.key" "$WALLET_PASSWORD"

sudo tee .autrc > /dev/null << EOF
[aut]
rpc_endpoint=https://rpc1.piccadilly.autonity.org/
keyfile=./piccadilly-keystore/wallet.key
EOF

echo -e "\e[1m\e[32m3. Downloading and building binaries--> \e[0m" && sleep 1

# Update the script with the new version number
cd $HOME/autonity-client && sudo wget https://github.com/autonity/autonity/releases/download/v$AUT_VERSION/autonity-linux-amd64-$AUT_VERSION.tar.gz  
sudo tar -xzf autonity-linux-amd64-$AUT_VERSION.tar.gz && sudo rm -rf autonity-linux-amd64-$AUT_VERSION.tar.gz  
sudo mv autonity /usr/local/bin/ && sudo chmod +x /usr/local/bin/autonity

cd $HOME

your_ip="$(curl eth0.me)"

sudo tee /etc/systemd/system/autonityd.service > /dev/null << EOF
[Unit]
Description=Autonityd Node
After=network-online.target
StartLimitIntervalSec=0
[Service]
User=$USER
Restart=always
RestartSec=3
LimitNOFILE=65535
ExecStart=autonity \
    --datadir ${DATA_DIR}  \
    --${NETWORK_NAME}  \
    --http  \
    --http.addr 0.0.0.0 \
    --http.api aut,eth,net,txpool,web3,admin  \
    --http.vhosts "*" \
    --ws  \
    --ws.addr 0.0.0.0 \
    --ws.api aut,eth,net,txpool,web3,admin  \
    --nat extip:$your_ip

[Install]
WantedBy=multi-user.target
EOF

curl -o "$DATA_DIR/static-nodes.json" $STATIC_NODE_URL

sudo systemctl daemon-reload 

sudo systemctl enable $BINARY_NAME 
sudo systemctl restart $BINARY_NAME

echo -e "=============== SETUP FINISHED ==================="
echo -e "Check logs:            ${CYAN}sudo journalctl -u $BINARY_NAME -f -o cat ${NC}"
