const ArrayUtils = artifacts.require("ArrayUtils");
//const StringUtils = artifacts.require("StringUtils");
//const IntUtils = artifacts.require("IntUtils");

const AicOrgansHolderProxy = artifacts.require("AicOrgansHolderProxy");
const StockHolderOnChainProxy = artifacts.require("StockHolderOnChainProxy");

const BaseStockRightApplyOnChain = artifacts.require("BaseStockRightApplyOnChain");
const StockRightApplyOnChain = artifacts.require("StockRightApplyOnChain");
const StockRightApplyOnChainProxy = artifacts.require("StockRightApplyOnChainProxy");

module.exports = function(deployer) {
	  //deployer.deploy(ArrayUtils);
	  //deployer.deploy(StringUtils);
	  //deployer.deploy(IntUtils);
	  
	  deployer.deploy(BaseStockRightApplyOnChain);
	  deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChain);
	  deployer.link(AicOrgansHolderProxy, StockRightApplyOnChain);
	  deployer.link(ArrayUtils, StockRightApplyOnChain);
	  //deployer.link(IntUtils, StockHolderOnChain);
	 // deployer.link(StringUtils, StockHolderOnChain);
	  deployer.deploy(StockRightApplyOnChain);
	  deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChainProxy);
	  deployer.link(StockHolderOnChainProxy, StockRightApplyOnChainProxy);
	  deployer.deploy(StockRightApplyOnChainProxy);
	  
	  
	  let stockHolderProxy = null;
	  let stockRightApplyInstance = null;
	  let stockRightApplyProxy = null;
	  deployer.then(function() {
		  return StockRightApplyOnChainProxy.deployed();
	  }).then(function(instance){
		  stockRightApplyProxy = instance;
		  return StockRightApplyOnChain.deployed();
	  }).then(function(instance){
		  stockRightApplyInstance = instance;
		  return StockHolderOnChainProxy.deployed();
	  }).then(function(instance){
		  stockHolderProxy = instance;
		  stockRightApplyProxy.initialize(stockRightApplyInstance.address,stockHolderProxy.address);
	  });
	  
};