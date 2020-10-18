const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const IntUtils = artifacts.require("IntUtils");

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
	  //deployer.link(AicOrgansHolderProxy, StockHolderOnChain);
	  //deployer.link(ArrayUtils, StockHolderOnChain);
	  //deployer.link(IntUtils, StockHolderOnChain);
	 // deployer.link(StringUtils, StockHolderOnChain);
	  deployer.deploy(StockRightApplyOnChain);
	  deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChainProxy);
	  deployer.link(StockHolderOnChainProxy, StockRightApplyOnChainProxy);
	  deployer.deploy(StockRightApplyOnChainProxy);
	  
	  /*
	  let bizlicProxy = null;
	  let stockHolderInstance = null;
	  let stockHolderProxy = null;
	  deployer.then(function() {
		  return BizLicOnChainProxy.deployed();
	  }).then(function(instance){
		  bizlicProxy = instance;
		  return StockHolderOnChain.deployed();
	  }).then(function(instance){
		  stockHolderInstance = instance;
		  return StockHolderOnChainProxy.deployed();
	  }).then(function(instance){
		  stockHolderProxy = instance;
		  stockHolderProxy.initialize(stockHolderInstance.address,bizlicProxy.address);
	  });
	  */
};