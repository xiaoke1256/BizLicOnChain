//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const EncryptUtils = artifacts.require("EncryptUtils");

const BaseAicOrgansHolder = artifacts.require("BaseAicOrgansHolder");
const AicOrgansHolder = artifacts.require("AicOrgansHolder");
const AicOrgansHolderStorage = artifacts.require("AicOrgansHolderStorage");
const AicOrgansHolderProxy = artifacts.require("AicOrgansHolderProxy");


const BaseBizLicOnChain = artifacts.require("BaseBizLicOnChain");
const BizLicOnChain = artifacts.require("BizLicOnChain");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.deploy(StringUtils);
  deployer.deploy(EncryptUtils);
  
  //deployer.deploy(BaseAicOrgansHolder);
  //deployer.link(BaseAicOrgansHolder, AicOrgansHolder);
  deployer.link(StringUtils, ArrayUtils);
  
  deployer.link(BaseAicOrgansHolder,AicOrgansHolderStorage);
  deployer.link(ArrayUtils,AicOrgansHolderStorage);
  deployer.link(ArrayUtils, AicOrgansHolder);
 // deployer.link(BaseAicOrgansHolder, AicOrgansHolderProxy);
  deployer.link(StringUtils, AicOrgansHolderProxy);
  deployer.link(ArrayUtils, AicOrgansHolderProxy);
  
  deployer.deploy(AicOrgansHolderStorage);
  deployer.deploy(AicOrgansHolder);
  deployer.deploy(AicOrgansHolderProxy);
  
  deployer.deploy(BaseBizLicOnChain);
  deployer.link(BaseBizLicOnChain, BizLicOnChain);
  deployer.link(BaseBizLicOnChain, BizLicOnChainProxy);
  deployer.link(ArrayUtils, BizLicOnChain);
  deployer.link(StringUtils, BizLicOnChain);
  deployer.link(EncryptUtils, BizLicOnChain);
  deployer.link(StringUtils, BizLicOnChainProxy);
  deployer.link(AicOrgansHolderProxy, BizLicOnChainProxy);
  //deployer.deploy(MetaCoin);
  deployer.deploy(BizLicOnChain);
  deployer.deploy(BizLicOnChainProxy);
  
  //组装发证机关合约
  let organInstance = null;
  let organProxy = null;
  let bizlicInstance = null;
  let bizlicProxy = null;
  deployer.then(function() {
	  return AicOrgansHolder.deployed();
  }).then(function(instance){
	  organInstance = instance;
	  return AicOrgansHolderProxy.deployed();
  }).then(function(instance){
	  organProxy = instance;
	  organProxy.initialize(organInstance.address);
	  web3.eth.getAccounts().then(function(accounts){
		  organProxy.addAdmin(accounts[1]);
		  organProxy.regestOrgan("310000000","上海市市场监督局",accounts[1]);
		  organProxy.regestOrgan("310101000","上海市市场监督管理局黄浦分局",accounts[1]);
		  organProxy.regestOrgan("310104000","上海市市场监督管理局徐汇分局",accounts[1]);
		  organProxy.regestOrgan("310105000","上海市市场监督管理局长宁分局",accounts[1]);
		  organProxy.regestOrgan("310106000","上海市市场监督管理局静安分局",accounts[1]);
		  organProxy.regestOrgan("310107000","上海市市场监督管理局普陀分局",accounts[1]);
		  organProxy.regestOrgan("310108000","上海市市场监督管理局闸北分局",accounts[1]);
		  organProxy.regestOrgan("310109000","上海市市场监督管理局虹口分局",accounts[1]);
		  organProxy.regestOrgan("310110000","上海市市场监督管理局杨浦分局",accounts[1]);
		  organProxy.regestOrgan("310112000","上海市市场监督管理局闵行分局",accounts[1]);
		  organProxy.regestOrgan("310113000","上海市市场监督管理局宝山分局",accounts[1]);
		  organProxy.regestOrgan("310114000","上海市市场监督管理局嘉定分局",accounts[1]);
		  organProxy.regestOrgan("310115000","上海市市场监督管理局浦东分局",accounts[1]);
		  organProxy.regestOrgan("310116000","上海市市场监督管理局金山分局",accounts[1]);
		  organProxy.regestOrgan("310117000","上海市市场监督管理局松江分局",accounts[1]);
		  organProxy.regestOrgan("310118000","上海市市场监督管理局青浦分局",accounts[1]);
		  organProxy.regestOrgan("310120000","上海市市场监督管理局奉贤分局",accounts[1]);
		  organProxy.regestOrgan("310230000","上海市市场监督管理局崇明分局",accounts[1]);
	  });
  }).then(function(){
	  return BizLicOnChain.deployed();
  }).then(function(instance){
	  bizlicInstance = instance;
	  return BizLicOnChainProxy.deployed();
  }).then(function(instance){
	  bizlicProxy = instance;
	  bizlicProxy.initialize(bizlicInstance.address,organProxy.address)
  });
  
};
