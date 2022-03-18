# crosschain_devops


crosschain_devops为跨链合约自动部署项目，可以向QA、TESTNET所依赖环境上自动部署。包括：
- 基础的智能合约。
- Token
- 在teleport和所跨的链上创建客户端。

本文档主要为部署操作手册说明。下面步骤均已QA为例。

### 一、下载xibc-contracts，编译部署并在evm/erc20 hardhat.config.ts填充私钥

在当前目录下执行
```shell
cd qa
source download-xibc-contracts.sh
```

### 二、修改环境变量

回到项目路径，执行
```shell
cd qa/env_var
```

修改`base_variable.sh`中基本的环境变量配置。其中各个函数参数的意义如下。


### 三、检查部署的基本合约和Token是否于最新版本的xibc-contracts匹配，是否遗漏最新修改之处。


### 四、顺序执行相应的脚本。

由于涉及到轻客户端的创建以及proposal id，当前部署顺序为：
- eth
- bsc
- arbitrum

脚本执行顺序如下：
```shell
source 1_deploy_base_contract.sh
source 2_deploy_token.sh
source 3_bind_token.sh
source 4_client_create.sh
source 5_voting.sh
```