var GPToken = artifacts.require("./GPToken.sol");
var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");

contract('GPToken', function(accounts) {
  it("get wallet balance", function() {
    return GPToken.deployed().then(function(instance) {
      console.log("balance of: " + GPTCrowdsale.address);
      return instance.balanceOf.call(GPTCrowdsale.address);//accounts[0]);
    }).then(function(balance) {
      console.log("tokens: " + balance);
    });
  });
});

contract('GPToken', function(accounts) {
  it("crowdFundAddress", function() {
    return GPToken.deployed().then(function(instance) {
      return instance.getCrowdFundAddress.call();
    }).then(function(address) {
      console.log("address: " + address);
    });
  });
});