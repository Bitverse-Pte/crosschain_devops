#!/bin/bash

function compileErc20(){
  cd xibc-contracts/erc20 && yarn && yarn compile
}

function compileEvm(){
  cd ../evm && yarn && yarn compile
}

rm -rf xibc-contracts
git clone git@github.com:teleport-network/xibc-contracts.git

compileErc20
compileEvm