//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const EncryptUtils = artifacts.require("EncryptUtils");

const BaseAicOrgansHolder = artifacts.require("BaseAicOrgansHolder");
const AicOrgansHolder = artifacts.require("AicOrgansHolder");
const AicOrgansHolderProxy = artifacts.require("AicOrgansHolderProxy");

const BaseBizLicOnChain = artifacts.require("BaseBizLicOnChain");
const BizLicOnChain = artifacts.require("BizLicOnChain");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.deploy(StringUtils);
  deployer.deploy(EncryptUtils);
  
  deployer.deploy(BaseAicOrgansHolder);
  deployer.link(BaseAicOrgansHolder, AicOrgansHolder);
  deployer.link(ArrayUtils, AicOrgansHolder);
  deployer.link(BaseAicOrgansHolder, AicOrgansHolderProxy);
  deployer.link(StringUtils, AicOrgansHolderProxy);
  deployer.link(ArrayUtils, AicOrgansHolderProxy);
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
  deployer.then(function() {
	  return AicOrgansHolder.deployed();
  }).then(function(instance){
	  organInstance = instance;
	  return AicOrgansHolderProxy.deployed();
  }).then(function(instance){
	  organProxy = instance;
	  organProxy.initialize(organInstance.address);
  });
  
};
