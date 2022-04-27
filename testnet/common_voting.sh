 #!/bin/bash

 export TELE_CHAIN_ID=teleport_8001-2
 export TELE_VOTING_VALIDATORS=8
 export TELE_TM_RPC=https://rpc.testnet.teleport.network

 function copyConfig(){
   sudo rm -rf ~/teleport_testnet
   sudo cp -r helper/teleport_cluster ~/teleport_testnet
 }

 function  voteProposal(){
   for ((i=0; i<$TELE_VOTING_VALIDATORS; i++))
   do
     sudo teleport tx gov vote $1 yes  \
     --from validator$i --home ~/teleport_testnet/validators/validator$i/teleport \
     --keyring-backend test --keyring-dir  ~/teleport_testnet/validators/validator$i/teleport \
      --chain-id $TELE_CHAIN_ID  -b block --fees 25000000000000000000atele\
      --node $TELE_TM_RPC -y
   done
 }

 function voting() {
     # vote proposal-id 1
     voteProposal $1
 }

copyConfig

voting $1

