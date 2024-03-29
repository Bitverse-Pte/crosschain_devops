#!/bin/bash

#!/bin/bash

cd ../../

function update_env(){
  source env_var/base_variable.sh
}

function hardhat_deploy_base(){
  if [ "$1" = "LIGHT_CLIENT_GEN_VALHASH_ADDRESS" ]; then
    yarn hardhat deployLibraries --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "ACCESS_MANAGER_ADDRESS" ]; then
    yarn hardhat deployAcessManager --network $ARBITRUM_NETWORK_NAME --wallet $ARBITRUM_GNOSIS_SAFE_ADDRESS
  fi

  if [ "$1" = "CLIENT_MANAGER_ADDRESS" ]; then
    yarn hardhat deployClientManager --network $ARBITRUM_NETWORK_NAME --chain $ARBITRUM_CHAIN_NAME
  fi

  if [ "$1" = "TENDERMINT_CLIENT" ]; then
    yarn hardhat deployTendermint --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "TSS_CLIENT" ]; then
    yarn hardhat deployTssClient --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "ROUTING_ADDRESS" ]; then
    yarn hardhat deployRouting --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "PACKET_ADDRESS" ]; then
    yarn hardhat deployPacket --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "TRANSFER_ADDRESS" ]; then
    yarn hardhat deployTransfer --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "FT" ]; then
    yarn hardhat addRouting --module FT --address $TRANSFER_ADDRESS --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "RCC_ADDRESS" ]; then
    yarn hardhat deployRcc --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "CONTRACT" ]; then
    yarn hardhat addRouting --module CONTRACT --address $RCC_ADDRESS --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "MULTICALl_ADDRESS" ]; then
    yarn hardhat deployMultiCall --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "grantRole" ]; then
    yarn hardhat grantRole --role $ARBITRUM_MULTISEND_ROLE --to $MULTICALl_ADDRESS --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "PROXY_ADDRESS" ]; then
    yarn hardhat deployProxy --network $ARBITRUM_NETWORK_NAME
  fi

  if [ "$1" = "hasRole" ]; then
    yarn hardhat hasRole --role $ARBITRUM_MULTISEND_ROLE --to $MULTICALl_ADDRESS --network $ARBITRUM_NETWORK_NAME
  fi


#  yarn hardhat transferoOwnership --gnosissafe $GNOSIS_SAFE_ADDRESS --network $ARBITRUM_NETWORK_NAME
}

function tool_check() {
  temp=0
  while true; do
    temp=`expr $temp + 1`

    # loop 5 times, or break
    if [ "$temp" = "5" ]; then
      exit 0
    fi

    # deploy
    hardhat_deploy_base $1
    grep $1 env.txt
    if [ "$?" = "0" ]; then
      break
    fi

  done

  echo "deploy $1 success!"
  source env.txt
}

function deploy_base_on_arbitrum() {
    cd ../helper/qa/xibc-contracts/evm

    tool_check LIGHT_CLIENT_GEN_VALHASH_ADDRESS
    tool_check ACCESS_MANAGER_ADDRESS
    tool_check CLIENT_MANAGER_ADDRESS
    tool_check TENDERMINT_CLIENT

    tool_check TSS_CLIENT

    tool_check ROUTING_ADDRESS
    tool_check PACKET_ADDRESS
    tool_check TRANSFER_ADDRESS
    tool_check RCC_ADDRESS
    tool_check MULTICALl_ADDRESS
    tool_check PROXY_ADDRESS


    tool_check grantRole
    tool_check FT addRouting
    tool_check CONTRACT addRouting

    sleep 20
    tool_check hasRole
}

update_env

deploy_base_on_arbitrum

rm -rf ../../../../qa/env_arbitrum_base.txt
mv env.txt ../../../../qa/env_var/env_arbitrum_base.txt

# exit to pre path
cd  ../../../../qa/deployments/arbitrum