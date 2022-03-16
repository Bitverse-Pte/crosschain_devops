#!/bin/bash


cd ../../

function hardhat_deploy_token(){
  if [ "$1" = "BSCUSDT" ]; then
    yarn hardhat deployTestToken --name BSCUSDT --symbol USDT --decimals 18 --transfer $SUPER_ADMIN --network $BSC_NETWORK_NAME
  fi


  if [ "$1" = "BSCTELE" ]; then
    yarn hardhat deployTestToken --name BSCTELE --symbol TELE --decimals 18 --transfer $SUPER_ADMIN --network $BSC_NETWORK_NAME
  fi


  if [ "$1" = "TELEUSDT" ]; then
    yarn hardhat deployTestToken --name TELEUSDT --symbol USDT --decimals 18 --transfer $SUPER_ADMIN --network $TELE_NETWORK_NAME
  fi

  if [ "$1" = "TELEBSC" ]; then
    yarn hardhat deployTestToken --name TELEBSC --symbol BSC --decimals 18 --transfer $SUPER_ADMIN --network $TELE_NETWORK_NAME
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


function deploy_token_on_bsc() {
    cd helper/xibc-contracts/erc20

    hardhat_deploy_token BSCUSDT

    hardhat_deploy_token BSCTELE
}

function deploy_token_on_tele(){
    hardhat_deploy_token TELEUSDT

    hardhat_deploy_token TELEBSC
}

deploy_token_on_bsc
deploy_token_on_tele

rm -rf ../../../env_var/env_bsc_token.txt
mv env.txt ../../../env_var/env_bsc_token.txt


cd ../../../
source env_var/env_bsc_token.txt

cd deployments/bsc