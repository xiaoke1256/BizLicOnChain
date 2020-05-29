let instance = await BizLicOnChain.deployed()
let proxy = await BizLicOnChainProxy.deployed()
await proxy.initialize(instance.address)

await proxy.getAdmins.call()

proxy.addAdmin(accounts[1])


proxy.regestOrgan("310000000","上海市市场监督局",accounts[1])
proxy.getOrgan.call('310000000')
proxy.removeOrgan("310000000")
proxy.getOrgan.call('310000000')

////签名 测试
//web3.eth.sign('上海市市场监督局',accounts[1])
//let sign = web3.eth.accounts.sign('上海市市场监督局','c620a4325cf94591cecd800d0e890cd8fe3adfaf7b93a870ebdcf96132b409ac');// 'c620...'，要替换成自己的私钥。
//sign.signature
//提交营业执照。
let licContent = "{corpName:'某某股份有限公司'}";
let sign = web3.eth.accounts.sign(licContent,accounts[1]);
sign;
proxy.putLic("123100008654367537","310000000",licContent,sign.signature);