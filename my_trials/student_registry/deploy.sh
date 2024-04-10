echo "loading enviroment variables..."
source .env
sleep 2
echo "📁 enviroment variables loaded."
sleep 2
echo "🔥forging your app in the furnace🔥"
sleep 2
forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --verify src/StudentRegistry.sol:StudentRegistry
