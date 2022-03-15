#!/bin/bash
cd ../../

function change_relayer_config() {
  rm -rf tss_config/bridge_api_config.toml
  rm -rf tss_config/relayd_config.toml


  a='"'${PACKET_ADDRESS}'"'
  b='"'${TSS_CLIENT}'"'

  cp -r tss_config/bridge_api_config_template.toml tss_config/bridge_api_config.toml
  cp -r tss_config/relayd_config_template.toml tss_config/relayd_config.toml
  if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "sed variable for macos"
    else
      sed -i  's/tss_client_address = "0x41076536D9A5b58c9Da94C2b341Ea5258B9De0C1"/tss_client_address = '$b'/g' tss_config/bridge_api_config.toml
      sed -i  's/tss_client_address = "0x41076536D9A5b58c9Da94C2b341Ea5258B9De0C1"/tss_client_address = '$b'/g' tss_config/relayd_config.toml
  fi
}

function modify_node_pubkey(){
  rm -rf tss_config/tss_clientState.json
  cp -r tss_config/tss_clientState_template.json tss_config/tss_clientState.json

  address=(`cat ~/tss_node_data/node0/PubKeyData.json | jq .groupEthAddress | sed 's/\"//g'`)
  export groupEthAddress=0x$address

  teleAddress=(`cat ~/tss_node_data/node0/PubKeyData.json | jq .groupBench32Address | sed 's/\"//g'`)
  export teleAddress=$teleAddress

  rawPubKey=(`cat ~/tss_node_data/node0/PubKeyData.json | jq .groupRawPubKey | sed 's/\"//g'`)
  export groupRawPubKey=0x$rawPubKey

  pubkey=(`cat ~/tss_node_data/node0/PubKeyData.json | jq .groupBase64PubKey | sed 's/\"//g'`)
  export groupPubKey=$pubkey

  if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "sed variable for macos"
      else
        sed -i  's/teleport1lq3wchp6g9p0kv7nu84mewva65xpumg7uuvpzu/'$teleAddress'/g' tss_config/tss_clientState.json
        sed -i  's!zgMnK87ZBJsf5g3H9OkKlLeUnxPtcI/hUPuNrxvHW9Si/k2MZx4gBz1y6aUxSP2S+LinSkjhXuO6+da/ITMX/w==!'$pubkey'!g' tss_config/tss_clientState.json
    fi
}

function startTssBridgeNode(){
  rm -rf ~/tssconfig
  cp -r tss_config ~/tssconfig

  docker run -itd --net host --name=tssbridge -v ~/tssconfig/:/root/tssconfig -v ~/go/bin/bridge-api:/usr/bin/bridge-api ubuntu:20.04 bridge-api --config /root/tssconfig/bridge_api_config.toml

  docker run -itd --net host --name=tssrelayd -v ~/tssconfig/:/root/tssconfig -v ~/go/bin/relayd:/usr/bin/relayd ubuntu:20.04 relayd --config /root/tssconfig/relayd_config.toml
}

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


function create_client_on_eth(){
  cd ../helper/local/xibc-contracts/evm

#   format
#   yarn hardhat createTssCLient --chain teleport  \
#   --client 0x7f5ae538c4f187c0987345c948d6133449d2b549   \
#   --pubkey 0xbfeae69c005221660bb8e20c11cc7bd3b4b8f3e85ef0356ed51905eaa172fcdd5480020eecb7fe85cd2aec618d2165f90e8b6480340f7273332206bf7d34d2f3  \
#   --partpubkeys [0xd4967590eb024589dfb6b9e48a576eb49ebc19d764b0d1d67dc21975e7258e97,0x0000000000000000000000000000000000000000000000000000000000000001,0x0000000000000000000000000000000000000000000000000000000000000002,0x0000000000000000000000000000000000000000000000000000000000000003,0x065e0be95fb43db528a20ba65c0e575e33cd4a9e1ca089dba4efff24596e8553] \
#   --pooladdress 0x64f8fc6b26ec81762673ebb4e32e48b72821294f  --network $ETH_NETWORK_NAME

  # part-pubkey doesn't need to change
   yarn hardhat createTssCLient --chain teleport  \
   --client $TSS_CLIENT   \
   --pubkey 0x$rawPubKey  \
   --partpubkeys [0x42417732b0e10b29aa8c5284c58136ac6726cbc1b5afc8ace6d6c4b03274cd01310b958a6dc5b27f2c1ad5c6595bffeac951c8407947d05166e687724d3890f7,0xa926c961ab71a72466faa6abef8074e6530f4c56087c43087ab92da441cbb1e9d24dfc12a5e0b4a686897e50ffa9977b3c3eb13870dcd44335287c0777c71489,0xc17413bbdf839a3732af84f61993c9a09d71f33a68f6fbf05ce53b66b0954929943184d65d8d02c11b7a70904805bcca6e3f3749d95e6438b168f2ed55768310,0x28b5ba326397f2c0f689908bcf4fe198d842739441471fa96e43d4cdd495d9c9f138fed315b3744300fa1dd5599a9e21d12264f97b094f3a5f4b84be120a1c6a] \
   --pooladdress $address  --network $ETH_NETWORK_NAME
}

function crate_tss_client_on_tele() {
    #!/bin/bash
    rm -rf ~/.teleport-relayer/
    ## generate files
    relayer init
    # copy tss file
    cp -r tss_config/tss_clientState.json ~/.teleport-relayer/
    cp -r tss_config/tss_consensusState.json ~/.teleport-relayer/

    ### client-create
    teleport tx gov submit-proposal client-create \
    ethmock ~/.teleport-relayer/tss_clientState.json ~/.teleport-relayer/tss_consensusState.json \
    --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
    --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID --deposit 2000000000000000000000atele \
      -y -b block --title "test" --description "test"  \
      --gas auto --fees 25000000000000000000atele --node $TELE_TM_RPC

    voting 1

    ### register-trace  0x1000...3
    teleport tx gov submit-proposal \
    register-trace $ETHTELE 0x0000000000000000000000000000000000000000 ethmock  \
      --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
     --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID  --deposit  2000000000000000000000atele \
      -y -b block --title "test" --description "test"   \
       --node $TELE_TM_RPC --gas auto  --fees 2500000000000000000atele

    ### vote for this proposal
    voting 2
}


function create_client_on_tele() {
    #!/bin/bash
    rm -rf ~/.teleport-relayer/
    ## generate files
    relayer init
    relayer genFiles eth ethmock $ETH_CHAIN_ID $ETH_CHAIN_URL --packet $PACKET_ADDRESS
    # generate tendemrint client state
    relayer genFiles tendermint teleport $TELE_CHAIN_ID $TELE_9090 $TELE_RELAYER_START_HEIGHT


    ### client-create
    teleport tx gov submit-proposal client-create \
    ethmock ~/.teleport-relayer/ethmock_clientState.json ~/.teleport-relayer/ethmock_consensusState.json \
    --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
    --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID --deposit 2000000000000000000000atele \
      -y -b block --title "test" --description "test"  \
      --gas auto --fees 25000000000000000000atele --node $TELE_TM_RPC

    voting 1

#    we use relayer to register

    teleport tx gov submit-proposal relayer-register ethmock \
     teleport1e595uvylhp2av396vnjlk0wrm5y0zwghlrxq7f  \
     --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
     --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport  \
     --chain-id $TELE_CHAIN_ID --deposit  200000000000000000000atele  \
     -y -b block --title "test" --description "test"    \
     --node $TELE_TM_RPC \
     --gas auto  --fees 250000000000000000atele

    voting 2

    ### register-trace  0x1000...3
    teleport tx gov submit-proposal \
    register-trace $ETHTELE 0x0000000000000000000000000000000000000000 ethmock  \
      --from validator0 --home ~/teleport_testnet/validators/validator0/teleport \
     --keyring-backend test --keyring-dir ~/teleport_testnet/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID  --deposit  2000000000000000000000atele \
      -y -b block --title "test" --description "test"   \
       --node $TELE_TM_RPC --gas auto  --fees 2500000000000000000atele

    ### vote for this proposal
    voting 3
}


# use tss client
# crate_tss_client_on_tele

create_client_on_tele


modify_node_pubkey
change_relayer_config
startTssBridgeNode

create_client_on_eth

# exit to pre path
 cd ../../../../local


cd deployments/eth