#!/bin/bash

DATA_DIR="$HOME/.titanedge/storage/assets"

echo -e "Remove Titan storage data on $DATA_DIR/ ... "


sudo rm -rf "$DATA_DIR"/*
sudo systemctl restart titand.service

echo -e "Removed and restart service success !"
