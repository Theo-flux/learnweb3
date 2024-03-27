#!/bin/bash
echo "loading environment variables..."
source .env
echo "forging your foundry app..."
forge create --rpc-url $QUICKNODE_RPC_URL --private-key $PRIVATE_KEY --constructor-args 10 --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Whitelist.sol:Whitelist

