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
	  
	  //deployer.deploy(BaseStockRightApplyOnChain);
	 // deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChain);
	  deployer.link(AicOrgansHolderProxy, StockRightApplyOnChain);
	  deployer.link(ArrayUtils, StockRightApplyOnChain);
	  //deployer.link(IntUtils, StockHolderOnChain);
	  // deployer.link(StringUtils, StockHolderOnChain);
	  
	  //deployer.link(BaseStockRightApplyOnChain, StockRightApplyOnChainProxy);
	  deployer.link(StockHolderOnChainProxy, StockRightApplyOnChainProxy);
	  
	  let stockHolderProxy = null;
	  let stockRightApplyInstance = null;
	  let stockRightApplyProxy = null;
	  deployer.deploy(StockRightApplyOnChain).then(function(){
		  return deployer.deploy(StockRightApplyOnChainProxy);
	  }).then(function() {
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
		  var result = stockRightApplyProxy.initialize(stockRightApplyInstance.address,stockHolderProxy.address);
		  result.then(function(value){
			  console.log('the init result is.'+value);
		  });
		  console.log('stockRightApplyProxy inited.'+result);
		  stockRightApplyProxy.isInited().then(function(value){
			  console.log('is inited?'+value);
		  });
		  
	  })
	  
};