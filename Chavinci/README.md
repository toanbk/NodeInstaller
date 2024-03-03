# Chavinci Installer


    wget -O install_chavinci.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Chavinci/install.sh && chmod +x install_chavinci.sh && ./install_chavinci.sh

Link dev: https://docs.cha.network/developer/node/manually-setup/

Check sync:

    cd $HOME/chavinci && ./cha-cli getblockchaininfo

After sync done, run this command to get wallet address:

    ./cha-cli getnewaddress
