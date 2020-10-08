const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const IntUtils = artifacts.require("IntUtils");

const AicOrgansHolderProxy = artifacts.require("AicOrgansHolderProxy");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

const BaseStockHolderOnChain = artifacts.require("BaseStockHolderOnChain");
const StockHolderOnChain = artifacts.require("StockHolderOnChain");
const StockHolderOnChainProxy = artifacts.require("StockHolderOnChainProxy");

module.exports = function(deployer) {
	  //deployer.deploy(ArrayUtils);
	  //deployer.deploy(StringUtils);
	  deployer.deploy(IntUtils);
	  
	  deployer.deploy(BaseStockHolderOnChain);
	  deployer.link(BaseStockHolderOnChain, StockHolderOnChain);
	  deployer.link(AicOrgansHolderProxy, StockHolderOnChain);
	  deployer.link(ArrayUtils, StockHolderOnChain);
	  deployer.link(IntUtils, StockHolderOnChain);
	  deployer.link(StringUtils, StockHolderOnChain);
	  deployer.deploy(StockHolderOnChain);
	  deployer.link(BaseStockHolderOnChain, StockHolderOnChainProxy);
	  deployer.link(BizLicOnChainProxy, StockHolderOnChainProxy);
	  deployer.deploy(StockHolderOnChainProxy);
};