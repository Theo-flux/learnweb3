#!/bin/bash
echo "loading environment variables..."
source .env
echo "forging your foundry app..."
# forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Token.sol:Token
# forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args 0xd2E56B20FC49B6a48bF3cf4A33745A423284399d --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Exchange.sol:Exchange