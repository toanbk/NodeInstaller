# Auto Install Autonity And Oracle Node

    wget -O install_autonity.sh https://raw.githubusercontent.com/toanbk/NodeInstaller/main/Autonity/install_node.sh && chmod +x install_autonity.sh && ./install_autonity.sh

# Setting Oracle server
    Config oracle, register all site and get key api:

    https://currencyfreaks.com
    https://openexchangerates.org
    https://currencylayer.com
    https://www.exchangerate-api.com

    Edit API key on file plugins-conf.yml

    ``` vi ${HOME}/autonity-oracle/plugins-conf.yml ```

    After edit done, save file and restart oracle service:

    ``` sudo systemctl restart autoracled ```

# Create Autonity validator
    https://docs.autonity.org/validators/register-vali/
    