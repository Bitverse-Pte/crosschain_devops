#!/bin/bash

docker rm -f $(docker ps -aq)

sudo rm -rf ~/teleport_qa/

cp -r ../cluster-config/11_tele_nodes ~/teleport_qa

# remove existed network
docker network rm  teleport-br11

# create new network
docker network create --subnet=172.172.0.0/24 teleport-br11

# start container
# The teleport_testnet is clone from git@github.com:wbprivate/teleport_testnet.git
# It bigger the initial account money and disable the block


docker run -itd  --net teleport-br11  --ip 172.172.0.2 --name=peer0 -p 8545:8545 -p 8546:8546 -p 26656:26656 -p 26657:26657 -v ~/teleport_qa/validators/validator0/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.3 --name=peer1 -p 8555:8545 -p 8556:8546 -p 26666:26656 -p 26667:26657 -v ~/teleport_qa/validators/validator1/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.4 --name=peer2 -p 8565:8545 -p 8566:8546 -p 26676:26656 -p 26677:26657 -v ~/teleport_qa/validators/validator2/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.5 --name=peer3 -p 8575:8545 -p 8576:8546 -p 26686:26656 -p 26687:26657 -v ~/teleport_qa/validators/validator3/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.6 --name=peer4 -p 8585:8545 -p 8586:8546 -p 26696:26656 -p 26697:26657 -v ~/teleport_qa/validators/validator4/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.7 --name=peer5 -p 8595:8545 -p 8596:8546 -p 26706:26656 -p 26707:26657 -v ~/teleport_qa/validators/validator5/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.8 --name=peer6 -p 8605:8545 -p 8606:8546 -p 26716:26656 -p 26717:26657 -v ~/teleport_qa/validators/validator6/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.9 --name=peer7 -p 8615:8545 -p 8616:8546 -p 26726:26656 -p 26727:26657 -v ~/teleport_qa/validators/validator7/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.10 --name=peer8 -p 8625:8545 -p 8626:8546 -p 26736:26656 -p 26737:26657 -v ~/teleport_qa/validators/validator8/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.11 --name=peer9 -p 8635:8545 -p 8636:8546 -p 26746:26656 -p 26747:26657 -v ~/teleport_qa/validators/validator9/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
docker run -itd  --net teleport-br11  --ip 172.172.0.12 --name=peer10 -p 8645:8545 -p 8646:8546 -p 26756:26656 -p 26757:26657 -v ~/teleport_qa/validators/validator10/teleport/:/root/teleport  webbshi/teleport:v0.1.0-alpha2  teleport start --home /root/teleport --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3,miner
