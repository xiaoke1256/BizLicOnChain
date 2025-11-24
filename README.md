[![License](https://img.shields.io/badge/license-anti996-green.svg)](https://github.com/wanlinus/Anti996-License/blob/master/LICENSE)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/xiaoke1256/BizLicOnChain/blob/master/LICENSE)、

BizLicOnChain
===
## 概述
&ensp;&ensp;&ensp;&ensp;
本项目的主要功能是把营业执照放在区块链（以太坊）上。在区块链上发放营业执照的好处是，不依赖于发证机关（市场监督管理局）就可以证明营业执照的合法性。营业执照的审批过程任然在市场监督管理局内部进行。

&ensp;&ensp;&ensp;&ensp;
另外一个功能是，在区块链上转让股权，这样在可以减少政府部门干预的情况下进行股权交易。

## 股权交易流程

&ensp;&ensp;&ensp;&ensp;
在区块链中股权转让的流程如下：
```mermaid
  flowchart  TD;
  发起转让-->董事会确认
  董事会确认--通过-->受让方付款
  受让方付款-->发证机关备案
  发证机关备案-->流程结束（成功）
  
```
```
  发起转让-->董事会确认--(通过)-->受让方付款-->发证机关备案-->流程结束（成功）
                |                   |            |
             （不通过）           （超时）     （不通过）
                |                   |            |
                v                   |            |
            流程结束(失败) <---------┴------------┘
```
&ensp;&ensp;&ensp;&ensp;
  各个步骤解释如下：
  1. 发起转让：
  
  &ensp;&ensp;&ensp;&ensp;
  由股权持有人发起，此时要提供要提供受让方的身份信息（身份信息需要加保护，提供零知证明来替代）、受让方账号、股权份额、转让价格（以太币）。
  
  2. 董事会确认：
  
  &ensp;&ensp;&ensp;&ensp;
  由公司董事会的账号完成，以确认是否同意此次股权转让。
  
  3. 受让方付款：
  
  &ensp;&ensp;&ensp;&ensp;
  受让方支付以太币。
  
  4. 发证机关备案：
  
  &ensp;&ensp;&ensp;&ensp;
  市场监督管理局检查手续、材料是否齐全，过程是否违法，然后再往市监局的数据库中备案。备案成功则将以太币支付给股权出让方，在区块链中正式将受让方记录为股东，把股权转让给他。
  
  5. 流程结束：
  
  &ensp;&ensp;&ensp;&ensp;
  如果发生任何异常的话，应将以太币退给受让方。

## 存储设计
&ensp;&ensp;&ensp;&ensp;
### 1、存储在区块链中的营业执照，结构如下：
 |属性名|解释|
 |-----|----|
 |organCode|发证机关代码|
 |licContent|证照内容(把企业名称，法定代表人等数据项拼成json串。)|
 |sign|发证机关的电子签章|
 
 &ensp;&ensp;&ensp;&ensp;
 其中证照内容的结构如下：
 |字段名|解释|
 |----|----|
 |uniScId|统一社会信用码,作为企业的唯一标识|
 |corpName|企业名称|
 |leadName|法定代表人姓名|
 |indsyCode|行业分类代码(GB/T 4754—2017)|
 |bizScope|经营范围(文字描述)|
 |regCpt|注册资金(元)|
 |provDate|核准时间(yyyy-MM-dd)|
 |limitTo|有效期至(yyyy-MM-dd)|
 |organCode|发证机关代码|
 |issueOrgan|发证机关(中文全称)|
 |otherInfo|其他信息|
 
 ### 2、存储在区块链中股权信息结构如下：
 |属性名|解释|
 |-----|----|
 |uniScId|所在企业的统一社会信用码|
 |investorName|股东姓名|
 |investorAccount|股东账号|
 |investorCetfHash|股东身份证件,有身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）和证件号码组成，由冒号(:)分隔。本字段需要加密，区块链中仅保存其Hash值。|
 |stockRightDetail|股权详情。json方式给出，描述出资方式和份额。举例如下：“[{invtType:'货币',amt:200000},{invtType:'知识产权',amt:100000}]”。|
 |merkel |股东姓名、股东账号、股东身份证件三者加起来的默克尔值|
 |cptAmt|出资额度（人民币元）|
 
 ## 如何运行本系统
 
 ### 1. 安装geth
  &ensp;&ensp;&ensp;&ensp;
  geth是GO语言写的以太坊节点，也可以把它当做一个客户端来用。在官网上下载安装文件（我下载的是“geth-windows-amd64-1.8.3-329ac18e.exe”），双击之，然后根据提示点击“下一步”，直至安装成功。默认安装位置是“C:\Program Files\Geth”。
  
 ### 2. 设置创世区块
 &ensp;&ensp;&ensp;&ensp;
 先编辑好创世区块配置文件“[genesis.json](https://github.com/xiaoke1256/BizLicOnChain/blob/master/genesis-config/genesis.json)”，放置在geth的安装路径下。启动CMD命令行，并切换到geth安装目录，然后在命令行中执行以下命令：
 ```
  geth init genesis.json --datadir data
 ```

 ### 3. 启动geth并进入控制台
 
 &ensp;&ensp;&ensp;&ensp;
 进入geth控制台的命令如下：
 ```
 geth --datadir "data" --networkid 123 --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi "eth,miner,net,personal,web3" -rpccorsdomain "*" --targetgaslimit 10500000 --nodiscover --ipcdisable --allow-insecure-unlock console 2>>geth.log
 ```
 其中“--targetgaslimit 10500000” 参数的目的是，在挖矿的过程中将gaslimit扩充到10500000。
 
 &ensp;&ensp;&ensp;&ensp;
 也可以以dev模式启动一个私有链，在这种模式下仅当有事务提交时才会进行挖矿。以下命令就是以dev模式启动私有链：
 ```
 geth --datadir "data1" --networkid 123 --dev --rpc --rpcapi "db,eth,net,web3,miner,personal" --targetgaslimit 10500000 --allow-insecure-unlock console 2>>log
 ```
 注意，dev模式会自动生成一个默认账号，不能使用原有的账号（或keystore文件），如果需要用多个账号就要用`personal.newAccount("******")`命令创建。如果将默认账号中的以太币转账至其他账号的话是不用输入密码的。
 
  ### 4. 同步区块
 
 &ensp;&ensp;&ensp;&ensp;
 进入控制台后，用以下命令查看当前节点信息：
 ```
 admin.nodeInfo
 ```
 其中enode属性就是这个节点的地址。然后到另外一台机器上去以上述方法安装并启动一个geth控制台，输入以下命令把同步节点添加上：
 ```
 admin.addPeer("enode://06de9b48518416d9b31e7baf209...db32c004a72ae5eaa79a8046e5@192.168.66.101:30303")
 ```
 用`admin.peers`命令就可以查远程节点列表。

### 5. 创建账户

 &ensp;&ensp;&ensp;&ensp;
 查看所有账户：
 ```
 > eth.accounts
 ```
 &ensp;&ensp;&ensp;&ensp;
 创建账户：
 ```
 > personal.newAccount("******")
 ```
 &ensp;&ensp;&ensp;&ensp;
 设置挖矿地址：
```
> miner.setEtherbase('用户地址')
```
 &ensp;&ensp;&ensp;&ensp;
 查看挖矿地址：
 ```
 > eth.coinbase
 ```

### 6. 开始挖矿

 &ensp;&ensp;&ensp;&ensp;
 查看挖矿状态：
 ```
 eth.mining
 ```
 &ensp;&ensp;&ensp;&ensp;
 键入以下命令，开始挖矿：
 ```
 miner.start(1)
 ```
注意，挖矿时可能会有较长时间的预热。

### 7. 转账测试

&ensp;&ensp;&ensp;&ensp;
先解除账户锁定：
```
> personal.unlockAccount(eth.accounts[0])
```
 &ensp;&ensp;&ensp;&ensp;
 转账命令如下：
```
> eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[2], value: amount})
```
### 8. 按装 truffle

&ensp;&ensp;&ensp;&ensp;
先安装node.js,确保控制台上输入`node -v`命令后可以打印出版本号。然后输入以下命令就可以安装truffle.
```
npm -g install truffle@5.1.22
```
如果安装过程种发生网络问题，请选用cnpm.如有必要安装一下Ethereum TestRPC:
```
npm install -g ethereumjs-testrpc
```
用以下命令创建一个空的职能合约项目（如果从git上下载现成的项目这一步可以省略）：
```
truffle init
```

&ensp;&ensp;&ensp;&ensp;
安装完毕后，把私有链矿机的地址注册到truffle的配置文件中。即在truffle-config.js文件中增加如下内容：
```
    MyNetwork: {
      host: "192.168.xx.100";
      port: 8545,             // Custom port
      network_id: 123,       // Custom network
      gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
      gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
      //from: <address>,        // Account to send txs from (default: accounts[0])
      // websockets: true        // Enable EventEmitter interface for web3 (default: false)
    },
```

### 9. 发布电子合约
&ensp;&ensp;&ensp;&ensp;
要确保contracts目录中放的是本项目的合约文件，migrations目录中存放的是发布合约的脚本（2_deploy_contracts.js）。
然后解锁账户 account[0],在geth客户端中执行以下命令：
```
> personal.unlockAccount(eth.accounts[0],"********", 100)
```
其中第一个参数是账户地址，第二个参数是密码，第三个账户是解锁周期。

&ensp;&ensp;&ensp;&ensp;
检查truffle初始化目录的migrations文件加下的js文件，看看是否有发布相关合约的脚本。保持私有链矿机挖矿状态。在命令行中输入以下命令：
```
truffle console --network MyNetwork
```
进入truffle控制台后（注意与geth不是同一个控制台），输入以下命令发布合约：
```
> migrate
```

### 10. 运行Web应用调用合约

&ensp;&ensp;&ensp;&ensp;
本项目源代码中有个工程叫BizLicOnChainCli，这是个用java写的Web工程。将这个工程编译后形成一个jar包，运行其中的“SpringbootApplication”类，以启动web应用。然后打开chrome浏览器，在地址栏里输入："http://127.0.0.1:8080/bizlic/" ，就会出现“欢迎访问链上市监局”的界面。然后就可以进行“注册企业”、“注销企业”、“注册股权”等操作。
