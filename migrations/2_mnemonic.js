var Mnemonic = artifacts.require("./MnemonicVault.sol");

module.exports = function(deployer) {
  deployer.deploy(Mnemonic);
};
