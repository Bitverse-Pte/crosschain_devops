#!/bin/bash


cd ../../

source env_var/base_variable.sh
source env_var/env_bsc_token.txt
source env_var/env_bsc_base.txt

cd helper/xibc-contracts/evm

## bond tokens
yarn hardhat bindToken --transfer $TRANSFER_ADDRESS \
--address $BSCTELE --oritoken 0x0000000000000000000000000000000000000000 \
--orichain teleport --network $BSC_NETWORK_NAME

# exit to pre
cd ../../../deployments/bsc