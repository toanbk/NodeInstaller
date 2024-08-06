# Network3
Network3 builds an AI Layer2 helping AI developers worldwide inference train or validate models widely quickly, conveniently, and efficiently

Website: [https://network3.ai](https://account.network3.ai/register_page?rc=5dd0d548)

Discord: https://discord.com/invite/q4cHgxZUCH

Telegram: https://t.me/network3official

X: https://x.com/network3_ai

# Register account

https://account.network3.ai/register_page?rc=9dd232ea

# Installation Guide for Ubuntu

### 1. Server preparation

```
sudo apt update
sudo apt install wget curl make clang net-tools pkg-config libssl-dev build-essential jq lz4 gcc unzip snapd -y
```


### 2. Download and Extract the tar file
```
cd $HOME
wget https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Network3/ubuntu-node-v2.0.tar && \
tar -xf ubuntu-node-v2.0.tar && \
rm -rf ubuntu-node-v2.0.tar && \
cd ubuntu-node
```
### 3. Start node
```
sudo bash manager.sh up
```
### 4. Provides node access to your account (2 ways)

##### 4.1 If the Ubuntu system has a desktop environment

 You can access the dashboard directly through Firefox at: https://account.network3.ai/main , It will auto access.
 
##### 4.2  From another machine

Open a browser `Firefox` on the other machine and visit: https://account.network3.ai/main?o=xx.xx.xx.xx:8080

`With: IP address of the Ubuntu machine is xx.xx.xx.xx`

`Port 8080`

<img src="https://raw.githubusercontent.com/nodesynctop/Network3/main/network3.PNG">
Then you could click the '+' button on the top-right of the panel of current node in the dashboard. 
And input the private key of the node in the dialog to bind. You may get the private key by this command:

```
sudo bash manager.sh key
```
### 5. Stop node
```
sudo bash manager.sh down
```
