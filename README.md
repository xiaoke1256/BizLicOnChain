BizLicOnChain
===
## 概述
&ensp;&ensp;&ensp;&ensp;
本应用的主要功能是把营业执照放在区块链（以太坊）上。在区块链上发放营业执照的作用是，不依赖于发证机关（市场监督管理局）就可以证明营业执照的合法性。我们做了如下设计：1.只有指定账户（address）才可以提交营业执照；2.营业执照上有发证机关的数字签名。

## 存储设计
&ensp;&ensp;&ensp;&ensp;
存储在区块链中的营业执照，结构如下：
 |属性名|解释|
 |-----|----|
 |organCode|发证机关代码|
 |licContent|证照内容(把企业名称，法定代表人等数据项拼成json串。)|
 |sign|电子签章|
 
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
 |issueOrgan|发证机关(中文全称)|
 |otherInfo|其他信息|
 
 ## 如何运行本系统
 
 ### 1. 安装geth
 ### 2. 设置创世区块
 &ensp;&ensp;&ensp;&ensp;
 先编辑好创世区块配置文件“[genesis.json](https://github.com/xiaoke1256/BizLicOnChain/blob/master/genesis-config/genesis.json)”。然后在命令行中执行以下命令：
 ```
  geth init genesis.json --datadir data
 ```
 
 ### 3. 同步区块
 
 &ensp;&ensp;&ensp;&ensp;
 进入geth控制台的命令如下：
 ```
 geth --datadir "data" --networkid 123 --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi "eth,miner,net,personal,web3" -rpccorsdomain "*" --targetgaslimit 14500000 --nodiscover --ipcdisable console 2>>geth.log
 ```
 其中“--targetgaslimit 14500000” 参数的目的是，在挖矿的过程中将gaslimit扩充到14500000。
 
 &ensp;&ensp;&ensp;&ensp;
 也可以使用以下命令来以dev模式（仅当有事务时才进行挖矿）启动一个私有链：
 ```
 geth --datadir "data1" --networkid 123 --dev --rpc --rpcapi "db,eth,net,web3,miner,personal" console 2>>log
 ```
 注意，dev模式会自动生成一个账号，不能用原有的账号（或keystore文件），如果需要用多个账号就要用`personal.newAccount("123456")`命令创建。
 
 &ensp;&ensp;&ensp;&ensp;
 进入控制台后，用以下命令查看当前节点信息：
 ```
 admin.nodeInfo
 ```
 其中enode属性就是这个节点的地址。然后到另外一台机器上去启动geth控制台，输入以下命令把同步节点添加上：
 ```
 admin.addPeer("enode://06de9b48518416d9b31e7baf209...db32c004a72ae5eaa79a8046e5@192.168.66.101:30303")
 ```

### 4. 创建账户

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

### 5. 开始挖矿

 &ensp;&ensp;&ensp;&ensp;
 键入以下地址，开始挖矿：
 ```
 miner.start(1)
 ```


### 6. 转账测试

&ensp;&ensp;&ensp;&ensp;
先解除账户锁定：
```
> personal.unlockAccount(acc0)
```
 &ensp;&ensp;&ensp;&ensp;
 转账命令如下：
```
> eth.sendTransaction({from: acc0, to: acc1, value: amount})
```
### 7. 按装 truffle
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

### 8. 发布电子合约
&ensp;&ensp;&ensp;&ensp;
先解锁账户 account[0],在geth客户端中执行以下命令：
```
> personal.unlockAccount(eth.accounts[0],"********", 100)
```
其中第一个参数是账户地址，第二个参数是密码，第三个账户是解锁周期。

&ensp;&ensp;&ensp;&ensp;
检查truffle初始化目录的migrations文件加下的js文件，看看是否有发布相关合约的脚本。保持私有链矿机挖矿状态。在命令行中输入以下命令：
```
truffle console --network MyNetwork
```
进入控制台后，输入以下命令发布合约：
```
> migrate
```
然后输入以下命令初始化合约：
```
> let instance = await BizLicOnChain.deployed()
> let proxy = await BizLicOnChainProxy.deployed()
> await proxy.initialize(instance.address)
```
### 9. 运行Web应用调用合约
