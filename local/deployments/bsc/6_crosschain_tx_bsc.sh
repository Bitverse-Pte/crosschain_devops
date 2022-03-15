#!/bin/bash

cd ../../../local

source env_var/base_variable.sh

cd ../helper/local/xibc-contracts/evm

yarn hardhat transferBase  --transfer 0x0000000000000000000000000000000010000003 \
--receiver $SUPER_ADMIN --destchain $BSC_CHAIN_NAME --relaychain "" --amount 20 --network $TELE_NETWORK_NAME

cd ../../../../local/deployments/bsc