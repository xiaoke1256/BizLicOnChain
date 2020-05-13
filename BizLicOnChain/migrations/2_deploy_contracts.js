//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const ArrayUtils = artifacts.require("ArrayUtils");
const BizlicOnChain = artifacts.require("BizlicOnChain");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.link(ArrayUtils, BizlicOnChain);
  //deployer.deploy(MetaCoin);
  deployer.deploy(BizlicOnChain);
  deployer.deploy(BizLicOnChainProxy);
};
