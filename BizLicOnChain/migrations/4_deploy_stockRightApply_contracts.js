const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
//const IntUtils = artifacts.require("IntUtils");

const AicOrgansHolderProxy = artifacts.require("AicOrgansHolderProxy");
const StockHolderOnChainProxy = artifacts.require("StockHolderOnChainProxy");

const BaseStockRightApplyOnChain = artifacts.require("BaseStockRightApplyOnChain");
const StockRightApplyOnChainStorage = artifacts.require("StockRightApplyOnChainStorage");
const StockRightApplyOnChain = artifacts.require("StockRightApplyOnChain");
const StockRightApplyOnChainProxy = artifacts.require("StockRightApplyOnChainProxy");

module.exports = function(deployer) {
	  //deployer.deploy(ArrayUtils);
	  //deployer.deploy(StringUtils);
	  //deployer.deploy(IntUtils);
	  
	  deployer.deploy(BaseStockRightApplyOnChain);
	  deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChainStorage);
	  deployer.link(ArrayUtils, StockRightApplyOnChainStorage);
	  deployer.deploy(StockRightApplyOnChainStorage);
	  
	  
	  deployer.link(AicOrgansHolderProxy, StockRightApplyOnChain);
	  deployer.link(ArrayUtils, StockRightApplyOnChain);
	  //deployer.link(IntUtils, StockRightApplyOnChain);
	  deployer.link(StringUtils, StockRightApplyOnChain);
	  deployer.deploy(StockRightApplyOnChain);
	  
	  //deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChainProxy);
	  deployer.link(StringUtils, StockRightApplyOnChainProxy);
	  deployer.link(StockHolderOnChainProxy, StockRightApplyOnChainProxy);
	  deployer.deploy(StockRightApplyOnChainProxy);
	  
	  let stockHolderProxy = null;
	  let stockRightApplyInstance = null;
	  let stockRightApplyProxy = null;
	  let stockRightApplyOnChainStorage = null;
	  deployer.then(function(){
		  return StockRightApplyOnChainStorage.deployed();
	  }).then(function(instance) {
		  stockRightApplyOnChainStorage = instance;
		  return StockRightApplyOnChainProxy.deployed();
	  }).then(function(instance){
		  stockRightApplyProxy = instance;
		  console.log('stockRightApplyProxy:'+stockRightApplyProxy.address);
		  return StockRightApplyOnChain.deployed();
	  }).then(function(instance){
		  stockRightApplyInstance = instance;
		  console.log('stockRightApplyInstance:'+stockRightApplyInstance.address);
		  return StockHolderOnChainProxy.deployed();
	  }).then(function(instance){
		  stockHolderProxy = instance;
		  console.log('stockRightApplyInstance:'+stockRightApplyInstance.address);
		  console.log('stockHolderProxy:'+stockHolderProxy.address);
		  var result = stockRightApplyProxy.initialize(stockRightApplyInstance.address,stockRightApplyOnChainStorage.address,stockHolderProxy.address);
//		  result.then(function(value){
//			  console.log('the init result is.'+value);
//		  });
		  console.log('stockRightApplyProxy inited.'+result);
		  stockRightApplyProxy.isInited().then(function(value){
			  console.log('is inited?'+value);
		  });
		  
	  })
	  
};