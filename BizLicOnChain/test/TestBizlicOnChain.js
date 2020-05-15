let instance = await BizLicOnChain.deployed()
let proxy = await BizLicOnChainProxy.deployed()
await proxy.initialize(instance.address)

await proxy.getAdmins.call()

proxy.addAdmin(accounts[1])


proxy.regestOrgan({organCode:'320000000',organName:'上海市市场监督局'})

proxy.getAllOrgans()