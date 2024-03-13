# Register and create identity code

Guide: https://titannet.gitbook.io/titan-network-en/huygens-testnet/installation-and-earnings/bind-the-identity-code

# Check logs

    journalctl -u autonityd -f -o cat

# Tool sign message when on board validator

    cd $HOME && wget -O sign_onboard.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/sign/validator.sh && chmod +x sign_onboard.sh && ./sign_onboard.sh
