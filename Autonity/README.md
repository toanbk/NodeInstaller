# Auto Install Autonity And Oracle Node

Open port: 
- TCP, UDP 30303
- TCP 20203

Install command:

    wget -O install_autonity.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/install_node.sh && chmod +x install_autonity.sh && ./install_autonity.sh

# Setting Oracle server

Config oracle, register all site and get key api:

    https://currencyfreaks.com
    https://openexchangerates.org
    https://currencylayer.com
    https://www.exchangerate-api.com

Edit API key on file plugins-conf.yml

    vi ${HOME}/autonity-oracle/plugins-conf.yml

After edit done, save file and restart oracle service

    sudo systemctl restart autoracled

# Before Create Autonity validator
- If you already have wallet before, please update wallet.key on ~/piccadilly-keystore/wallet.key and restart autonity service
- Make sure have at least 1 ATN token on wallet before register validator

# Create Autonity validator

Follow this link: https://docs.autonity.org/validators/register-vali/

    cd $HOME && wget -O onboard_validator.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/onboard_validator.sh && chmod +x onboard_validator.sh && ./onboard_validator.sh

# Check logs

    journalctl -u autonityd -f -o cat

    journalctl -u autoracled -f -o cat

# Tool sign message when on board validator

    cd $HOME && wget -O sign_onboard.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/sign/validator.sh && chmod +x sign_onboard.sh && ./sign_onboard.sh
