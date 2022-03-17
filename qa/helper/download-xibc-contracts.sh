#!/bin/bash

function compileErc20(){
  cd xibc-contracts/erc20 && yarn && yarn compile

  mv hardhat.config.ts hardhat.config.ts.bak
  cp -r ../../../hardhat-config/hardhat.config.erc20.ts hardhat.config.ts
}

function compileEvm(){
  cd ../evm && yarn && yarn compile

  mv hardhat.config.ts hardhat.config.ts.bak
  cp -r ../../../hardhat-config/hardhat.config.evm.ts hardhat.config.ts
}

rm -rf xibc-contracts
git clone git@github.com:teleport-network/xibc-contracts.git

compileErc20
compileEvm