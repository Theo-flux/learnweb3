#!/bin/bash
echo "loading environment variables..."
source .env
echo "forging your foundry app..."
# forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args 10 --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Whitelist.sol:Whitelist
forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args 0x09f13597C57719CE078eCF3b3b5dff6586Ac96Db --etherscan-api-key $ETHERSCAN_API_KEY --verify src/CryptoDevs.sol:CryptoDevs