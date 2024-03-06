#!/bin/bash

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

echo -e "=============== Begin check necessary tools ==================="

