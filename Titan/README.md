# Register and create identity code

Register link (ref): https://test1.titannet.io/intiveRegister?code=rKCqBq

Invite code: rKCqBq

Guide: https://titannet.gitbook.io/titan-network-en/huygens-testnet/installation-and-earnings/bind-the-identity-code

# Install node

    cd $HOME && wget -O install_titan.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Titan/install.sh && chmod +x install_titan.sh && ./install_titan.sh
# Check token

Go to: https://test1.titannet.io/newoverview/activationcodemanagement and click on tab "Node Management"

# Issue + Fix

Check status of node by command

    systemctl status titand

If it not running, restart by command:

    systemctl restart titand

In case not see your node on board here: https://test1.titannet.io/newoverview/activationcodemanagement, need to bind identity code manual by command:

    titan-edge bind --hash=<identity code> https://api-test1.container1.titannet.io/api/v2/device/binding

Check node status

    titan-edge state

-----------------------------------------------------------

# Guide dev, install manual

If you don't want to run auto install, you can follow step by step:

Step 1：

mac installation:

    wget -c https://github.com/Titannet-dao/titan-node/releases/download/0.1.12/titan_v0.1.12_darwin_amd64.tar.gz -O- | sudo tar -xz -C /usr/local/bin --strip-components=1

Linux installation:

    wget -c https://github.com/Titannet-dao/titan-node/releases/download/0.1.12/titan_v0.1.12_linux_amd64.tar.gz -O- | sudo tar -xz -C /usr/local/bin --strip-components=1


Step 2：run the node

1. start the node 

start for the first time：

    titan-edge daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0

start since the second. time：

    titan-edge daemon start

2. connect the node

    titan-edge bind --hash=your-hash-here https://api-test1.container1.titannet.io/api/v2/device/binding

3. stop the node

    titan-edge daemon stop

# Free space

    cd $HOME && wget -O titan_free_space.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Titan/free_space.sh && chmod +x titan_free_space.sh && ./titan_free_space.sh && echo '01 */12 * * * /bin/bash -l -c '/root/titan_free_space.sh' >> /var/log/titan.log 2>&1'

