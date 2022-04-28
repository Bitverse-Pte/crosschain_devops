#!/bin/bash

function copyConfig(){
  rm -rf ~/teleport_qa
  cp -r ../../helper/teleport_cluster ~/$TELE_CLUSTER_DIR
}


function  voteProposal(){
  for ((i=0; i<$TELE_VOTING_VALIDATORS; i++))
  do
    teleport tx gov vote $1 yes  \
    --from validator$i --home ~/teleport_qa/validators/validator$i/teleport \
    --keyring-backend test --keyring-dir  ~/teleport_qa/validators/validator$i/teleport \
     --chain-id $TELE_CHAIN_ID  -b block --fees 25000000000000000000atele\
     --node $TELE_TM_RPC -y
  done
}

function voting() {
    # vote proposal-id 1
    voteProposal $1
    sleep $TELE_VOTING_PERIOD
}

copyConfig

voting $1