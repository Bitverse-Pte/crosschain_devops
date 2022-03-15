#!/bin/bash
cd ../../

source env_var/base_variable.sh
source env_var/env_eth_token.txt
source env_var/env_eth_base.txt

cd ../helper/local/xibc-contracts/evm

## bond tokens
yarn hardhat bindToken --transfer $TRANSFER_ADDRESS \
--address $ETHTELE --oritoken 0x0000000000000000000000000000000000000000 \
--orichain teleport --network $ETH_NETWORK_NAME

# exit to pre
cd ../../../../local


cd deployments/eth