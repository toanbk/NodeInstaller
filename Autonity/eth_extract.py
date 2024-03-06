import sys
import json
from eth_account import Account

def extract_private_key(keystore_path, password):
    with open(keystore_path, 'r') as keyfile:
        encrypted_key = keyfile.read()
        key = json.loads(encrypted_key)
        private_key = Account.decrypt(key, password)
        return private_key.hex()

def main():
    if len(sys.argv) != 3:
        print("Usage: python extract.py <path/to/keystorefile.json> <password>")
        sys.exit(1)

    keystore_path = sys.argv[1]
    password = sys.argv[2]

    try:
        private_key = extract_private_key(keystore_path, password)
        if private_key.startswith('0x'):
            # Remove '0x' prefix
            private_key = private_key[2:]
            
        print(private_key)
    except Exception as e:
        print("An error occurred:", e)

if __name__ == "__main__":
    main()
