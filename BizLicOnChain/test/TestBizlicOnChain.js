let instance = await BizLicOnChain.deployed()
let proxy = await BizLicOnChainProxy.deployed()
await proxy.initialize(instance.address)

await proxy.getAdmins.call()

proxy.addAdmin(accounts[1])


proxy.regestOrgan('320000000','上海市市场监督局','0x0000000000000000000000000000000000000000000000000000000000000001')

proxy.getOrgan('320000000')