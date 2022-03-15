#!/bin/bash

docker rm tele0 eth0 bsc0

cd ../cluster-config

# start ethmocks private chain nodes
function startEth() {
  cd 1_eth_nodes
  sudo rm -r ~/chaindata/
  sudo cp -r ethtest/data ~/chaindata
  docker run -d --name eth0   --net host  -v ~/chaindata:/root/chaindata -v /usr/bin/geth:/usr/bin/geth \
            ubuntu:20.04 geth --networkid 3133789  --mine --miner.threads 1 \
              --datadir /root/chaindata --nodiscover --http --http.addr "0.0.0.0" --http.port 9545 \
              --http.api eth,txpool,personal,net,debug,web3  --rpc.allow-unprotected-txs --http.vhosts=*
  cd ..
}

function startBscmock(){
  cd 1_bscmock_nodes
  sudo rm -r ~/bsc_chaindata/
  sudo cp -r bsctest/data ~/bsc_chaindata

  docker run -d --name bsc0   --net host  -v ~/bsc_chaindata:/root/chaindata -v /usr/bin/geth:/usr/bin/geth \
            ubuntu:20.04 geth --networkid 3133788  --mine --miner.threads 1 \
              --datadir /root/chaindata --nodiscover --http --http.addr "0.0.0.0" --http.port 7545 \
              --port 30304 --http.api eth,txpool,personal,net,debug,web3  --rpc.allow-unprotected-txs --http.vhosts=*
  cd ..
}

# start tele node
function startTele() {
  cd 1_tele_nodes
  sudo rm -rf ~/teleport_testnet
  sudo cp -r teleport_testnet ~/
  docker run -itd  --net host   --name=tele0   -v ~/teleport_testnet/validators/validator0/teleport/:/root/teleport  \
    -v ~/go/bin/teleport:/usr/bin/teleport ubuntu:20.04  \
    teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
  cd ..
}

# start tss_db
function startDB() {
  docker run -itd --net host  --security-opt seccomp=unconfined --name mysql-bridge -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=tss mysql
}

startDB
startEth
startBscmock
startTele

# exit to pre path
cd ../deployments
