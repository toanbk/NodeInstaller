# Register and create identity code

Register link (ref): https://test1.titannet.io/intiveRegister?code=rKCqBq
Invite code: rKCqBq

Guide: https://titannet.gitbook.io/titan-network-en/huygens-testnet/installation-and-earnings/bind-the-identity-code

# Install node

    cd $HOME && wget -O install_titan.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Titan/install.sh && chmod +x install_titan.sh && ./install_titan.sh
# Check token

Go to: https://test1.titannet.io/newoverview/activationcodemanagement
Click on tab "Node Management"

# Issue + Fix

1. Check status of node by command
    systemctl status titand

If it not running, restart by:
    systemctl restart titand

2./ in case not see your node on board here: https://test1.titannet.io/newoverview/activationcodemanagement
need to bind identity code manual by command:
    titan-edge bind --hash=<identity code> https://api-test1.container1.titannet.io/api/v2/device/binding