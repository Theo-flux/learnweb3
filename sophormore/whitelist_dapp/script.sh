#!/bin/bash
echo "loading environment variables..."
source .env
echo "forging your foundry app..."
# forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args 10 --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Whitelist.sol:Whitelist
forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args 0x2701BdBA4045ef5F3243Fe300531155eB5f94712 --etherscan-api-key $ETHERSCAN_API_KEY --verify src/CryptoDevs.sol:CryptoDevs