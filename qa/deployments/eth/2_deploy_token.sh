#!/bin/bash

#!/bin/bash

cd ../../


source env_var/base_variable.sh

function hardhat_deploy_token(){
  if [ "$1" = "ETHUSDT" ]; then
    yarn hardhat deployTestToken --name ETHUSDT --symbol USDT --decimals 18 --transfer $ETH_SUPER_ADMIN --network $ETH_NETWORK_NAME
  fi

  if [ "$1" = "ETHTELE" ]; then
    yarn hardhat deployTestToken --name ETHTELE --symbol TELE --decimals 18 --transfer $ETH_SUPER_ADMIN --network $ETH_NETWORK_NAME
  fi

  if [ "$1" = "TELEUSDT" ]; then
    yarn hardhat deployTestToken --name TELEUSDT --symbol USDT --decimals 18 --transfer $ETH_SUPER_ADMIN --network $TELE_NETWORK_NAME
  fi

  if [ "$1" = "TELEETH" ]; then
    yarn hardhat deployTestToken --name TELEETH --symbol ETH --decimals 18 --transfer $ETH_SUPER_ADMIN --network $TELE_NETWORK_NAME
  fi
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
    hardhat_deploy_token $1
    grep $1 env.txt
    if [ "$?" = "0" ]; then
      break
    fi

  done

  echo "deploy $1 success!"
  source env.txt
}


function deploy_token_on_eth() {
    cd helper/xibc-contracts/erc20

    hardhat_deploy_token ETHUSDT

    hardhat_deploy_token ETHTELE
}

function deploy_token_on_tele(){
    hardhat_deploy_token TELEUSDT
hardhat.config.erc20.ts
hardhat.config.evm.ts
    hardhat_deploy_token TELEETH
}

deploy_token_on_eth
deploy_token_on_tele

rm -rf ../../../env_var/env_eth_token.txt
mv env.txt ../../../env_var/env_eth_token.txt


cd ../../../
source env_var/env_eth_token.txt

cd deployments/eth