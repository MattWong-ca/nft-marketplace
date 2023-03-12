// const ConvertLib = artifacts.require("ConvertLib");
// const MetaCoin = artifacts.require("MetaCoin");

const KryptoBird = artifacts.require("KryptoBird");

module.exports = function(deployer) {
  deployer.deploy(KryptoBird);
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);
};