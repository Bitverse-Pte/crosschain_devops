#!/bin/bash

cd ../../

function  voteProposal(){
  for ((i=0; i<=0; i++))
  do
    teleport tx gov vote $1 yes  \
    --from validator$i --home ~/teleport_testnet/validators/validator$i/teleport \
    --keyring-backend test --keyring-dir  ~/teleport_testnet/validators/validator$i/teleport \
     --chain-id $TELE_CHAIN_ID  -b block --fees 25000000000000000000atele\
     --node $TELE_TM_RPC -y
  done
}

function voting() {
    # vote proposal-id 1
    voteProposal $1

    sleep $VOTING_PERIOD
    echo "waiting voting-period"
}

function crate_client_on_tele() {
    #!/bin/bash
    rm -rf ~/.teleport-relayer/
    ## generate files
    relayer init
    relayer genFiles $BSC_RELAYER_TYPE bscmock $BSC_CHAIN_ID $BSC_CHAIN_URL --packet $PACKET_ADDRESS
    # generate tendemrint client state
    relayer genFiles tendermint teleport $TELE_CHAIN_ID $TELE_9090 $TELE_RELAYER_START_HEIGHT


    ### client-create
    teleport tx gov submit-proposal client-create \
    bscmock ~/.teleport-relayer/bscmock_clientState.json ~/.teleport-relayer/bscmock_consensusState.json \
    --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
    --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID --deposit 2000000000000000000000atele \
      -y -b block --title "test" --description "test"  \
      --gas auto --fees 25000000000000000000atele --node $TELE_TM_RPC

    voting 1

    teleport tx gov submit-proposal relayer-register bscmock \
     $RELAYER1_BASE64ADDRESS  \
     --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
     --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport  \
     --chain-id $TELE_CHAIN_ID --deposit  200000000000000000000atele  \
     -y -b block --title "test" --description "test"    \
     --node $TELE_TM_RPC \
     --gas auto  --fees 250000000000000000atele

    voting 2

    ### register-trace  0x1000...3
    teleport tx gov submit-proposal \
    register-trace $BSCTELE 0x0000000000000000000000000000000000000000 bscmock  \
      --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
     --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID  --deposit  2000000000000000000000atele \
      -y -b block --title "test" --description "test"   \
       --node $TELE_TM_RPC --gas auto  --fees 2500000000000000000atele

    ### vote for this proposal
    voting 3
}

function create_client_on_bsc(){
  cd helper/xibc-contracts/evm
  yarn hardhat createClientFromFile  --chain teleport --client $TENDERMINT_CLIENT \
    --clientstate  ~/.teleport-relayer/tendermint_clientState.txt \
    --consensusstate ~/.teleport-relayer/tendermint_consensusState.txt \
    --network $BSC_NETWORK_NAME

  yarn hardhat registerRelayer  --chain teleport  --relayer  $SUPER_ADMIN  \
   --network $BSC_NETWORK_NAME
}

crate_client_on_tele
create_client_on_bsc

# exit to pre path
cd ../../../deployments/bsc