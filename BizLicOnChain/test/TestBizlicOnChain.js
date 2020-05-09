let instance = await BizlicOnChain.deployed()
let proxy = await BizLicOnChainProxy.deployed()
let storage = await BizLicOnChainStorage.deployed()
await proxy.initialize(instance.address,storage.address)

await proxy.getAdmins()