# crosschain_devops


crosschain_devops为跨链合约自动部署项目，可以向QA、TESTNET所依赖环境上自动部署。包括：
- 基础的智能合约。
- Token
- 在teleport和所跨的链上创建客户端。

本文档主要为部署操作手册说明。下面步骤均已QA为例。

### 一、下载xibc-contracts，编译部署

在当前目录下执行
```shell
cd qa
source download-xibc-contracts.sh
```
`download-xibc-contracts` 将下载`xibc-contracts`并自动下载依赖，编译。

在部署过程中，需要在`evm/erc20 hardhat.config.ts`填充私钥。

### 二、修改环境变量

回到项目路径，执行
```shell
cd qa/env_var
```

修改`base_variable.sh`中基本的环境变量配置。其中各个函数参数的意义如下：
- ETH_NETWORK_NAME： `hardhat.config.ts` 中配置的`network`名称。
- ETH_CHAIN_NAME: 跨链中确认身份所需要的标识。
- ETH_CHAIN_URL： `evm`类型交易的RPC端口。
- ETH_GNOSIS_SAFE_ADDRESS： 多签账户的地址。

- TELE_CHAIN_ID: 测试链的ID，qa环境为teleport_8001-1。
- TELE_VOTING_PERIOD： teleport链的投票时间。在qa环境上为3分钟。
- TELE_VOTING_VALIDATORS： teleport链为proposal投票的validator个数。
- TELE_TM_RPC： teleport链RPC url，默认端口为26657
- TELE_9090： teleport链9090 url地址。

部署完成后，会在`env_var`同目录下生成链上智能合约的地址和token的地址。

### 三、确认部署的智能合约和token是否正确。
确认的过程中，以下函数需要请@kukoo，@corey review，补充，更改：

- 1_deploy_base_contract.sh hardhat_deploy_base（）
- 2_deploy_token.sh hardhat_deploy_token（）
- 3_bind_token.sh  bindToken
- 4_client_create  register_trace.sh

### 四、顺序执行相应的脚本。

由于涉及到在teleport上客户端的创建以及voting，当前依次部署顺序为：
- eth
- bsc
- arbitrum

脚本执行顺序如下：
```shell
source 1_deploy_base_contract.sh
source 2_deploy_token.sh
source 3_bind_token.sh
source 4_client_create.sh
```

### 五、后续需要对接其他非EVM链，可在`deployments`下创建和eth、bsc同级的文件夹。
