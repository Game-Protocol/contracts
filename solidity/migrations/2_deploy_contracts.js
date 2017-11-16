var GPToken = artifacts.require("./GPToken.sol");
var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");

module.exports = function(deployer) {
  var team = "0xcd47f61fb04fb390ded7e97e2aeec7f9e4f9b1f4";
  var advisors = "0x39d607eb1a18578304b3eb553de09ca05667b979";
  var marketing = "0xa2f6e8604ccdb690f7b0d1fe889cc4a690ad7813";
  var beneficiary = "0x5ffdad3b2de0ee3163ba5227978d376366dbaa7f";
  deployer.deploy(GPTCrowdsale, beneficiary, 30, 1000, 4, 20).then(function () {
    return deployer.deploy(GPToken, GPTCrowdsale.address, advisors, marketing, team, 30).then(function() {
      GPTCrowdsale.deployed().then(function (instance) {
        return instance.setToken(GPToken.address);
      });
    });
  });
};
