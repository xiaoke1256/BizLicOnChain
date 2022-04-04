const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const IntUtils = artifacts.require("IntUtils");

const AicOrgansHolderProxy = artifacts.require("AicOrgansHolderProxy");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

const StockHolderOnChain = artifacts.require("StockHolderOnChain");
const StockHolderOnChainProxy = artifacts.require("StockHolderOnChainProxy");
const BaseStockHolderOnChain = artifacts.require("BaseStockHolderOnChain");

module.exports = function(deployer) {
	  deployer.deploy(AicOrgansHolderProxy, {overwrite: false});
	  deployer.deploy(ArrayUtils, {overwrite: false});
	  deployer.deploy(StringUtils, {overwrite: false});
	  deployer.deploy(IntUtils, {overwrite: false});
	  deployer.deploy(BizLicOnChainProxy, {overwrite: false});
	  
	  deployer.deploy(BaseStockHolderOnChain, {overwrite: false});//overwrite= false 表示不要重新部署
	  deployer.link(BaseStockHolderOnChain, StockHolderOnChain);
	  deployer.link(AicOrgansHolderProxy, StockHolderOnChain);
	  deployer.link(ArrayUtils, StockHolderOnChain);
	  deployer.link(IntUtils, StockHolderOnChain);
	  deployer.link(StringUtils, StockHolderOnChain);
	  deployer.deploy(StockHolderOnChain);
	  deployer.link(BaseStockHolderOnChain, StockHolderOnChainProxy);
	  deployer.link(BizLicOnChainProxy, StockHolderOnChainProxy);
	  deployer.deploy(StockHolderOnChainProxy);
	  
	  let bizlicProxy = null;
	  let stockHolderInstance = null;
	  let stockHolderProxy = null;
 	  deployer.then(function() {
		  return BizLicOnChainProxy.deployed();
	  }).then(function(instance) {
		  bizlicProxy = instance;
		  return StockHolderOnChain.deployed();
	  }).then(function(instance) {
		  stockHolderInstance = instance;
		  return StockHolderOnChainProxy.deployed();
	  }).then(function(instance){
		  stockHolderProxy = instance;
		  //stockHolderProxy.changeCurrentVersion(stockHolderInstance.address);
		  stockHolderProxy.initialize(stockHolderInstance.address,bizlicProxy.address);
	  });
};