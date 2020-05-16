//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const ArrayUtils = artifacts.require("ArrayUtils");
const StringUtils = artifacts.require("StringUtils");
const BizLicOnChain = artifacts.require("BizLicOnChain");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.deploy(StringUtils);
  deployer.link(ArrayUtils, BizLicOnChain);
  deployer.link(StringUtils, BizLicOnChain);
  deployer.link(StringUtils, BizLicOnChainProxy);
  //deployer.deploy(MetaCoin);
  deployer.deploy(BizLicOnChain);
  deployer.deploy(BizLicOnChainProxy);
};
