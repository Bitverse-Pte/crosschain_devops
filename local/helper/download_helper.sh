#!/bin/bash

# clone helper xibc-contracts

# download helper
function download_xibc() {
  cd ../helper
  if [ ! -d "xibc-contracts/" ];then
    echo "文件夹不存在"
    git clone git@github.com:teleport-network/xibc-contracts.git
    cd xibc-contracts
    git checkout $XIBC_CONTRACTS_BRANCH
    cd evm && yarn && yarn compile
    mv  hardhat.config.ts hardhat.config.bak.ts
    cd ../erc20 && yarn && yarn compile
    mv  hardhat.config.ts hardhat.config.bak.ts

    # exit to pre path
    cd ../../../  &&  echo $PWD

    # replace config
    cp -r local/hardhat-config/hardhat.config.erc20.ts helper/xibc-contracts/erc20/hardhat.config.ts \
    && cp -r local/hardhat-config/hardhat.config.evm.ts helper/xibc-contracts/evm/hardhat.config.ts

    # recompile for build error
    cd helper/xibc-contracts/evm && yarn compile
    cd ../erc20 && yarn compile
    cd ../../
  else
    echo "文件夹存在"
    cd ../../local
  fi
}

function download_tss_bridge(){

  if [ ! -d "tss-bridge/" ];then
    cd ../helper
    echo "文件夹不存在"
    git clone git@github.com:teleport-network/tss-bridge.git
    cd tss-bridge
    git reset --hard $TSS_BRIDGE_BRANCH

    rm -rf ../../local/db_config.db.sql
    cp -r db/table_create.sql ../../local/db_config
  else
    echo "文件夹存在"
    cd ../../local
  fi
}


download_xibc

download_tss_bridge
