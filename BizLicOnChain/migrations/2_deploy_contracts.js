//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const ArrayUtils = artifacts.require("ArrayUtils");
const BizlicOnchain = artifacts.require("BizlicOnchain");
const BizLicOnChainProxy = artifacts.require("BizLicOnChainProxy");
const BizLicOnChainStorage = artifacts.require("BizLicOnChainStorage");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.link(ArrayUtils, BizlicOnchain);
  //deployer.deploy(MetaCoin);
  deployer.deploy(BizlicOnchain);
  deployer.deploy(BizLicOnChainProxy);
  deployer.deploy(BizLicOnChainStorage);
};
