const TokenSwap = artifacts.require('TokenSwap');
 
module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(TokenSwap);
};