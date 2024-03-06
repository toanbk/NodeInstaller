#!/bin/bash

KEYSTORE_DIR="$HOME/piccadilly-keystore"
ETH_KEY_EXE="$HOME/autonity/build/bin/ethkey"
ETH_TOOL="$HOME/tools/eth_extract.py"
DATA_DIR="$HOME/autonity-client/autonity-chaindata"

read -r -p "Enter wallet password: " WALLET_PASSWORD

echo -e "\n=============== Begin install package ===================\n"

sudo apt install jq -y
sudo apt install python3-pip -y
pip install eth-account

echo -e "\n=============== Begin check node sync status ===================\n"

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

echo -e "\n=============== Begin check wallet balance ===================\n"

# Run the command and capture the output
balance=$(aut account balance)

# Check if the balance is less than 1
if (( $(echo "$balance < 1" | bc -l) )); then
    echo -e "Your ATN balance is too low. Please faucet at least 1 ATN to register validator."
    exit 1
else
    echo -e "Your ATN balance $balance is sufficient. You can proceed to register as a validator."
fi

echo -e "\n=============== Begin download necessary tools ===================\n"

mkdir -p $HOME/tools
sudo rm -rf $HOME/tools/eth_extract.py
curl -o $HOME/tools/eth_extract.py https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/eth_extract.py

if [ ! -f "$ETH_KEY_EXE" ]; then
    cd $HOME
    rm -rf $HOME/autonity
    # build tool
    git clone https://github.com/autonity/autonity.git
    cd $HOME/autonity
    make all
    cd $HOME
fi

echo -e "\n=============== Check Complete, Wait 1 min before begin register validator .... ===================\n\n\n"

# Define the new rpc_endpoint value
new_rpc_endpoint="http://0.0.0.0:8545/"
# Use sed to replace the rpc_endpoint value in the .autrc file
sed -i "s#^rpc_endpoint=.*#rpc_endpoint=$new_rpc_endpoint#" ~/.autrc
sudo systemctl restart autonityd.service
sleep 60

# get wallet address
WALLET_ADDRESS=$(aut account info | jq -r '.[0].account')

echo -e "\n=============== Step 1. Generate a cryptographic proof of node ownership ===============\n"
# create oracle key
echo -e "python3 $ETH_TOOL $KEYSTORE_DIR/wallet.key $WALLET_PASSWORD > $KEYSTORE_DIR/oracle.key"

python3 "$ETH_TOOL" "$KEYSTORE_DIR/wallet.key" "$WALLET_PASSWORD" > "$KEYSTORE_DIR/oracle.key"

echo "autonity genOwnershipProof --autonitykeys $DATA_DIR/autonity/autonitykeys --oraclekey $KEYSTORE_DIR/oracle.key $WALLET_ADDRESS"

# generate ownership
ownership_proof=$(autonity genOwnershipProof --autonitykeys "$DATA_DIR/autonity/autonitykeys" --oraclekey "$KEYSTORE_DIR/oracle.key" "$WALLET_ADDRESS")

echo -e "\n=============== genOwnershipProof ===================\n"
echo -e "\e[1m\e[32m$ownership_proof \e[0m"
echo -e "\n==================================\n"

sleep 1

echo -e "\n=============== Step 2. Determine the validator enode and address ===============\n"

admin_enode=$(aut node info | jq -r '.admin_enode')

echo -e "\n=============== Admin Enode ===================\n"
echo -e "\e[1m\e[32m$admin_enode \e[0m"
echo -e "\n===============================================\n"

validator_address=$(aut validator compute-address $admin_enode)

echo -e "\n=============== Validator Address ===================\n"
echo -e "\e[1m\e[32m$validator_address \e[0m"
echo -e "\n=====================================================\n"

sleep 1

echo -e "\n=============== Step 3. Determine the validator consensus public key ===============\n"

consensus_key=$("$ETH_KEY_EXE" autinspect "$DATA_DIR/autonity/autonitykeys" | awk '/Consensus Public Key:/ {print $4}')

echo -e "Comand: $ETH_KEY_EXE autinspect $DATA_DIR/autonity/autonitykeys | awk '/Consensus Public Key:/ {print $4}'"

echo -e "\n=============== Consensus Key ===================\n"
echo -e "\e[1m\e[32m$consensus_key \e[0m"
echo -e "\n=====================================================\n"

sleep 1

echo -e "\n=============== Step 4. Submit the registration transaction ===============\n"

echo -e "Command to submit register validator:"
echo -e "aut validator register <ENODE> <ORACLE> <CONSENSUS_KEY> <PROOF> | aut tx sign --password <wallet_password> - | aut tx send -"

last_command="aut validator register $admin_enode $WALLET_ADDRESS $consensus_key $ownership_proof | aut tx sign --password $WALLET_PASSWORD - | aut tx send -"

echo -e "\n============ Register Validator Command =============\n"
echo -e "\e[1m\e[32m$last_command \e[0m"
echo -e "\n=====================================================\n"

aut validator register $admin_enode $WALLET_ADDRESS $consensus_key $ownership_proof | aut tx sign --password $WALLET_PASSWORD - | aut tx send -

echo -e "Waiting for register validator ..."
sleep 10

# update aut file
echo "validator=$validator_address" >> ~/.autrc

echo -e "\n=============== Step 5. Check result ===============\n"

echo -e "\n Validator info: \n"

aut validator info
