let instance = await BizlicOnChain.deployed()
let proxy = await BizLicOnChainProxy.deployed()
await proxy.initialize(instance.address)

await proxy.getAdmins.call()