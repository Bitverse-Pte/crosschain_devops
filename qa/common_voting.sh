 #!/bin/bash

 export TELE_CHAIN_ID=teleport_7001-1
 export TELE_VOTING_PERIOD=180       # seconds
 export TELE_VOTING_VALIDATORS=11
 export TELE_TM_RPC=tcp://abd46ec6e28754f0ab2aae29deaa0c11-1510914274.ap-southeast-1.elb.amazonaws.com:26657

 function copyConfig(){
   sudo rm -rf ~/teleport_qa
   sudo cp -r helper/teleport_cluster ~/teleport_qa
 }

 function  voteProposal(){
   for ((i=0; i<$TELE_VOTING_VALIDATORS; i++))
   do
     sudo teleport tx gov vote $1 yes  \
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



 #transfer value test
 #sudo teleport tx bank send validator0 teleport1m86h02duuz0v9x7kvy33ap62jh7dmwp8asct3r 1000000atele \
 #--home ~/teleport_qa/validators/validator0/teleport \
 #--keyring-backend test --fees 1000000000000000atele \
 #--node tcp://abd46ec6e28754f0ab2aae29deaa0c11-1510914274.ap-southeast-1.elb.amazonaws.com:26657 \
 #--chain-id teleport_7001-1
