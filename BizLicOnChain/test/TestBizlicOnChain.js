let instance = await BizLicOnChain.deployed()
let proxy = await BizLicOnChainProxy.deployed()
await proxy.initialize(instance.address)

await proxy.getAdmins.call()

proxy.addAdmin(accounts[1])


proxy.regestOrgan("310000000","上海市市场监督局",accounts[1])
proxy.getOrgan.call('310000000')
proxy.removeOrgan("310000000")
proxy.getOrgan.call('310000000')

//签名
web3.eth.sign('上海市市场监督局',accounts[1])
