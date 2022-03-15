#!/bin/bash

cd ../../

function change_relayer_config() {
  rm -rf tss_config/node0_config.toml
  rm -rf tss_config/node1_config.toml
  rm -rf tss_config/node2_config.toml
  rm -rf tss_config/node3_config.toml

  cp -r tss_config/node0_config_template.toml tss_config/node0_config.toml
  cp -r tss_config/node1_config_template.toml tss_config/node1_config.toml
  cp -r tss_config/node2_config_template.toml tss_config/node2_config.toml
  cp -r tss_config/node3_config_template.toml tss_config/node3_config.toml

  a='"'${PACKET_ADDRESS}'"'
  b='"'${TSS_CLIENT}'"'

  if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "sed variable for macos"
    else
      sed -i  's/dst_chain_contract = "0xba8174c2163bbd2cb08407c954dd14a1b7c1f0c5"/dst_chain_contract = '$a'/g' tss_config/node0_config.toml
      sed -i  's/dst_chain_contract = "0xba8174c2163bbd2cb08407c954dd14a1b7c1f0c5"/dst_chain_contract = '$a'/g' tss_config/node1_config.toml
      sed -i  's/dst_chain_contract = "0xba8174c2163bbd2cb08407c954dd14a1b7c1f0c5"/dst_chain_contract = '$a'/g' tss_config/node2_config.toml
      sed -i  's/dst_chain_contract = "0xba8174c2163bbd2cb08407c954dd14a1b7c1f0c5"/dst_chain_contract = '$a'/g' tss_config/node3_config.toml
  fi
}


function startTssNode(){
  rm -rf ~/tssconfig
  cp -r tss_config ~/tssconfig

  sudo rm -rf ~/tss_node_data/
  cp -r tss_node_data ~/tss_node_data/

  docker rm -f tssnode0 tssnode1 tssnode2 tssnode3 tssbridge tssrelayd

  docker run -itd  --net host  --name=tssnode0  -v ~/tssconfig/:/root/tssconfig -v ~/tss_node_data/node0/:/root/.tssnode -v ~/go/bin/tssnode:/usr/bin/tssnode  ubuntu:20.04  tssnode start -c /root/tssconfig/node0_config.toml -p 8080

  docker run -itd  --net host  --name=tssnode1  -v ~/tssconfig/:/root/tssconfig -v ~/tss_node_data/node1/:/root/.tssnode -v ~/go/bin/tssnode:/usr/bin/tssnode  ubuntu:20.04  tssnode start -c /root/tssconfig/node1_config.toml -p 8081

  docker run -itd  --net host  --name=tssnode2  -v ~/tssconfig/:/root/tssconfig -v ~/tss_node_data/node2/:/root/.tssnode -v ~/go/bin/tssnode:/usr/bin/tssnode  ubuntu:20.04  tssnode start -c /root/tssconfig/node2_config.toml -p 8082

  docker run -itd  --net host  --name=tssnode3  -v ~/tssconfig/:/root/tssconfig -v ~/tss_node_data/node3/:/root/.tssnode -v ~/go/bin/tssnode:/usr/bin/tssnode  ubuntu:20.04  tssnode start -c /root/tssconfig/node3_config.toml -p 8083

}


function queryPubkey(){
  #!/bin/bash
  nohup curl -X POST -H "Content-Type: application/json" \
  -d '{"party_pub_keys":["0342417732b0e10b29aa8c5284c58136ac6726cbc1b5afc8ace6d6c4b03274cd01", "03a926c961ab71a72466faa6abef8074e6530f4c56087c43087ab92da441cbb1e9","02c17413bbdf839a3732af84f61993c9a09d71f33a68f6fbf05ce53b66b0954929","0228b5ba326397f2c0f689908bcf4fe198d842739441471fa96e43d4cdd495d9c9"],"chain":"ethmocks","threshold":2}' \
  http://127.0.0.1:8080/gen-key &

  nohup curl -X POST -H "Content-Type: application/json" \
  -d '{"party_pub_keys":["0342417732b0e10b29aa8c5284c58136ac6726cbc1b5afc8ace6d6c4b03274cd01", "03a926c961ab71a72466faa6abef8074e6530f4c56087c43087ab92da441cbb1e9","02c17413bbdf839a3732af84f61993c9a09d71f33a68f6fbf05ce53b66b0954929","0228b5ba326397f2c0f689908bcf4fe198d842739441471fa96e43d4cdd495d9c9"],"chain":"ethmocks","threshold":2}' \
  http://127.0.0.1:8081/gen-key &

  nohup curl -X POST -H "Content-Type: application/json" \
  -d '{"party_pub_keys":["0342417732b0e10b29aa8c5284c58136ac6726cbc1b5afc8ace6d6c4b03274cd01", "03a926c961ab71a72466faa6abef8074e6530f4c56087c43087ab92da441cbb1e9","02c17413bbdf839a3732af84f61993c9a09d71f33a68f6fbf05ce53b66b0954929","0228b5ba326397f2c0f689908bcf4fe198d842739441471fa96e43d4cdd495d9c9"],"chain":"ethmocks","threshold":2}' \
  http://127.0.0.1:8082/gen-key &

  nohup curl -X POST -H "Content-Type: application/json" \
  -d '{"party_pub_keys":["0342417732b0e10b29aa8c5284c58136ac6726cbc1b5afc8ace6d6c4b03274cd01", "03a926c961ab71a72466faa6abef8074e6530f4c56087c43087ab92da441cbb1e9","02c17413bbdf839a3732af84f61993c9a09d71f33a68f6fbf05ce53b66b0954929","0228b5ba326397f2c0f689908bcf4fe198d842739441471fa96e43d4cdd495d9c9"],"chain":"ethmocks","threshold":2}' \
  http://127.0.0.1:8083/gen-key &
}


change_relayer_config
startTssNode

sleep 30

queryPubkey

cd deployments/eth