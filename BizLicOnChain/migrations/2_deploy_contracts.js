//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const EncryptUtils = artifacts.require("EncryptUtils");
const BaseBizLicOnChain = artifacts.require("BaseBizLicOnChain");
const BizLicOnChain = artifacts.require("BizLicOnChain");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.deploy(StringUtils);
  deployer.deploy(EncryptUtils);
  deployer.deploy(BaseBizLicOnChain);
  deployer.link(BaseBizLicOnChain, BizLicOnChain);
  deployer.link(BaseBizLicOnChain, BizLicOnChainProxy);
  deployer.link(ArrayUtils, BizLicOnChain);
  deployer.link(StringUtils, BizLicOnChain);
  deployer.link(EncryptUtils, BizLicOnChain);
  deployer.link(StringUtils, BizLicOnChainProxy);
  //deployer.deploy(MetaCoin);
  deployer.deploy(BizLicOnChain);
  deployer.deploy(BizLicOnChainProxy);
};
