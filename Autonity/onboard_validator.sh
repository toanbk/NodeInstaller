#!/bin/bash

KEYSTORE_DIR="$HOME/piccadilly-keystore"
ETH_KEY_EXE="$HOME/autonity/build/bin/ethkey"
ETH_TOOL="$HOME/tools/eth_extract.py"
DATA_DIR="$HOME/autonity-client/autonity-chaindata"

read -r -p "Enter wallet password: " WALLET_PASSWORD

sudo apt install jq -y

echo -e "=============== Begin check node sync status ==================="

# Run the command and capture the output
sync_status=$(aut node info | jq -r '.eth_syncing')

# Check the sync status
if [ "$sync_status" = "true" ]; then
    echo -e "Your node is still not synced. Please wait before registering as a validator."
    echo -e "Command to check sync status: aut node info | jq .eth_syncing"
    exit 1  # Exit with a non-zero status to indicate failure
else
    echo -e "Your node is synced. You can proceed to register as a validator."
fi

echo -e "=============== Begin check wallet balance ==================="

# Run the command and capture the output
balance=$(aut account balance)

# Check if the balance is less than 1
if (( $(echo "$balance < 1" | bc -l) )); then
    echo -e "Your ATN balance is too low. Please faucet at least 1 ATN to register validator."
    exit 1
else
    echo -e "Your ATN balance $balance is sufficient. You can proceed to register as a validator."
fi

echo -e "=============== Begin download necessary tools ==================="

mkdir $HOME/tools && cd $HOME/tools
sudo rm -rf eth_extract.py
wget https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/eth_extract.py

if [ ! -f "$ETH_KEY_EXE" ]; then
    cd $HOME
    # build tool
    git clone git@github.com:autonity/autonity.git
    cd autonity
    make all
    cd $HOME
fi

echo -e "=============== Check Complete, Wait 1 min before begin register validator .... ==================="

# Define the new rpc_endpoint value
new_rpc_endpoint="http://0.0.0.0:8545/"
# Use sed to replace the rpc_endpoint value in the .autrc file
sed -i "s#^rpc_endpoint=.*#rpc_endpoint=$new_rpc_endpoint#" ~/.autrc
sudo systemctl restart autonityd.service
sleep 60

# get wallet address
WALLET_ADDRESS=$(aut account info | jq -r '.[0].account')

echo -e "=============== Step 1. Generate a cryptographic proof of node ownership ==============="
# create oracle key
echo -e "python3 $ETH_TOOL $KEYSTORE_DIR/wallet.key $WALLET_PASSWORD > $KEYSTORE_DIR/oracle.key"

python3 "$ETH_TOOL" "$KEYSTORE_DIR/wallet.key" "$WALLET_PASSWORD" > "$KEYSTORE_DIR/oracle.key"

echo "autonity genOwnershipProof --autonitykeys $DATA_DIR/autonity/autonitykeys --oraclekey $KEYSTORE_DIR/oracle.key $WALLET_ADDRESS"

# generate ownership
ownership_proof=$(autonity genOwnershipProof --autonitykeys "$DATA_DIR/autonity/autonitykeys" --oraclekey "$KEYSTORE_DIR/oracle.key" "$WALLET_ADDRESS")

echo -e "=============== genOwnershipProof ==================="
echo -e ''
echo -e "$ownership_proof"
echo -e ''
echo -e "=================================="

sleep 1

echo -e "=============== Step 2. Determine the validator enode and address ==============="

admin_enode=$(aut node info | jq -r '.admin_enode')

echo -e "=============== Admin Enode ==================="
echo -e ''
echo -e "$admin_enode"
echo -e ''
echo -e "==============================================="

validator_address=$(aut validator compute-address $admin_enode)

echo -e "=============== Validator Address ==================="
echo -e ''
echo -e "$validator_address"
echo -e ''
echo -e "====================================================="

sleep 1

echo -e "=============== Step 3. Determine the validator consensus public key ==============="

consensus_key=$(./"$ETH_KEY_EXE" autinspect "$DATA_DIR/autonity/autonitykeys" | awk '/Consensus Public Key:/ {print $4}')

echo -e "Comand: ./"$ETH_KEY_EXE" autinspect "$DATA_DIR/autonity/autonitykeys"

