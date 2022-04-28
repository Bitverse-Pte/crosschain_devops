#!/bin/bash

cd ../../

function change_relayer_config() {
    #!/bin/bash
    cd relayer_template

    rm -rf config-bsc.toml
    cp config-bsc-template.toml config-bsc.toml

  if [[ "$OSTYPE" == "darwin"* ]]; then
      packet_address='"'${PACKET_ADDRESS}'"'
      client_address='"'${CLIENT_MANAGER_ADDRESS}'"'
      tele_9090='"'${TELE_9090}'"'


      sed -i '' 's/chain_id = 4/chain_id = 3133788/g' ./config-bsc.toml
      sed -i '' 's/start_height = 10138845/start_height = 70/g' ./config-bsc.toml
      sed -i '' 's/start_height = 7070/start_height = 50/g' ./config-bsc.toml
      sed -i '' 's/chain_name = "rinkeby"/chain_name = "bscmock"/g' ./config-bsc.toml
      sed -i '' 's/Opt_priv_key = "2C47DAD44BE377EF09C50CCFB5C1EC9389D337CA7F68F056D0629A8EA622F142"/Opt_priv_key = "6395a7c842a08515961888d21d72f409b61fbce96af1e520384e375f301a8297"/g' ./config-bsc.toml

      sed -i '' 's/Addr = "0xba8174c2163bbd2cb08407c954dd14a1b7c1f0c5"/Addr = '$packet_address'/g' ./config-bsc.toml
      sed -i '' 's/Addr = "0xe6941a40723dd08bf4ce55c64c837a58ae62a623"/Addr = '$client_address'/g' ./config-bsc.toml
      sed -i '' 's/grpc_addr = "10.41.20.10:9090"/grpc_addr = '$tele_9090'/g' ./config-bsc.toml
    else
      packet_address='"'${PACKET_ADDRESS}'"'
      client_address='"'${CLIENT_MANAGER_ADDRESS}'"'
      tele_9090='"'${TELE_9090}'"'

      sed -i  's/chain_id = 4/chain_id = 3133788/g' ./config-bsc.toml
      sed -i  's/start_height = 10138845/start_height = 70/g' ./config-bsc.toml
      sed -i  's/start_height = 7070/start_height = 50/g' ./config-bsc.toml
      sed -i  's/chain_name = "rinkeby"/chain_name = "bscmock"/g' ./config-bsc.toml
      sed -i  's/Opt_priv_key = "2C47DAD44BE377EF09C50CCFB5C1EC9389D337CA7F68F056D0629A8EA622F142"/Opt_priv_key = "6395a7c842a08515961888d21d72f409b61fbce96af1e520384e375f301a8297"/g' ./config-bsc.toml

      sed -i  's/Addr = "0xba8174c2163bbd2cb08407c954dd14a1b7c1f0c5"/Addr = '$packet_address'/g' ./config-bsc.toml
      sed -i  's/Addr = "0xe6941a40723dd08bf4ce55c64c837a58ae62a623"/Addr = '$client_address'/g' ./config-bsc.toml
      sed -i  's/grpc_addr = "10.41.20.10:9090"/grpc_addr = '$tele_9090'/g' ./config-bsc.toml
  fi
}

function start_relayer() {
  cd ..
  rm -rf ~/relayer_template
  cp -r relayer_template ~/

  docker run -itd  --net host  --name=relayer0 -v ~/relayer_template/:/root/relayer_template \
      -v ~/go/bin/relayer:/usr/bin/relayer --restart=on-failure:10 ubuntu:20.04  \
      relayer start -c /root/relayer_template/config-bsc.toml
}

change_relayer_config
start_relayer

cd deployments/bsc

