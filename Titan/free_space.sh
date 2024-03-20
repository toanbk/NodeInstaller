#!/bin/bash

DATA_DIR="$HOME/.titanedge/storage/assets"

sudo rm -rf "$DATA_DIR"/*
sudo systemctl restart titand.service
