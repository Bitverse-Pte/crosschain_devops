#!/bin/bash

cd ../../

function create_client_on_eth(){
  cd helper/xibc-contracts/evm

#   format
#   yarn hardhat createTssCLient --chain teleport_cluster  \
#   --client 0x7f5ae538c4f187c0987345c948d6133449d2b549   \
#   --pubkey 0xbfeae69c005221660bb8e20c11cc7bd3b4b8f3e85ef0356ed51905eaa172fcdd5480020eecb7fe85cd2aec618d2165f90e8b6480340f7273332206bf7d34d2f3  \
#   --partpubkeys [0xd4967590eb024589dfb6b9e48a576eb49ebc19d764b0d1d67dc21975e7258e97,0x0000000000000000000000000000000000000000000000000000000000000001,0x0000000000000000000000000000000000000000000000000000000000000002,0x0000000000000000000000000000000000000000000000000000000000000003,0x065e0be95fb43db528a20ba65c0e575e33cd4a9e1ca089dba4efff24596e8553] \
#   --pooladdress 0x64f8fc6b26ec81762673ebb4e32e48b72821294f  --network $ETH_NETWORK_NAME

  # part-pubkey doesn't need to change
   yarn hardhat createTssCLient --chain teleport  \
   --client $TSS_CLIENT   \
   --pubkey 0xbfeae69c005221660bb8e20c11cc7bd3b4b8f3e85ef0356ed51905eaa172fcdd5480020eecb7fe85cd2aec618d2165f90e8b6480340f7273332206bf7d34d2f3  \
   --partpubkeys [0x42417732b0e10b29aa8c5284c58136ac6726cbc1b5afc8ace6d6c4b03274cd01310b958a6dc5b27f2c1ad5c6595bffeac951c8407947d05166e687724d3890f7,0xa926c961ab71a72466faa6abef8074e6530f4c56087c43087ab92da441cbb1e9d24dfc12a5e0b4a686897e50ffa9977b3c3eb13870dcd44335287c0777c71489,0xc17413bbdf839a3732af84f61993c9a09d71f33a68f6fbf05ce53b66b0954929943184d65d8d02c11b7a70904805bcca6e3f3749d95e6438b168f2ed55768310,0x28b5ba326397f2c0f689908bcf4fe198d842739441471fa96e43d4cdd495d9c9f138fed315b3744300fa1dd5599a9e21d12264f97b094f3a5f4b84be120a1c6a] \
   --pooladdress 0x64f8fc6b26ec81762673ebb4e32e48b72821294f  --network $ETH_NETWORK_NAME
}

function create_tss_client_on_tele() {
    #!/bin/bash
    rm -rf ~/.teleport-relayer/
    ## generate files
    relayer init
    # copy tss file
    cp -r tss_config/tss_clientState.json ~/.teleport-relayer/
    cp -r tss_config/tss_consensusState.json ~/.teleport-relayer/

    ### client-create
    teleport tx gov submit-proposal client-create \
    $ETH_CHAIN_NAME ~/.teleport-relayer/tss_clientState.json ~/.teleport-relayer/tss_consensusState.json \
    --from validator0 --home ~/teleport_qa/validators/validator0/teleport \
    --keyring-backend test --keyring-dir ~/teleport_qa/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID --deposit 2000000000000000000000atele \
      -y -b block --title "test" --description "test"  \
      --gas auto --fees 25000000000000000000atele --node $TELE_TM_RPC

    source 5_voting.sh 1

    ### register-trace  0x1000...3
    teleport tx gov submit-proposal \
    register-trace $ETHTELE 0x0000000000000000000000000000000000000000 $ETH_CHAIN_NAME  \
      --from validator0 --home ~/teleport_qa/validators/validator0/teleport \
     --keyring-backend test --keyring-dir ~/teleport_qa/validators/validator0/teleport \
     --chain-id $TELE_CHAIN_ID  --deposit  2000000000000000000000atele \
      -y -b block --title "test" --description "test"   \
       --node $TELE_TM_RPC --gas auto  --fees 2500000000000000000atele

    ### vote for this proposal
    source 5_voting.sh 2
}

create_client_on_eth

cd ../../../deployments/eth

create_tss_client_on_tele
