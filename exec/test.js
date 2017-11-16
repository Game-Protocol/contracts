var GPToken = artifacts.require("./GPToken.sol");
var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");


module.exports = function (done) {
    GPTCrowdsale.deployed().then(function(instance) {
        console.log("GPTCrowdsale: " + GPTCrowdsale.address);
        return instance.getSteps.call();
    }).then(function(steps) {
        console.log(steps.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPToken.deployed().then(function(instance) {
        console.log("GPToken: " + GPToken.address);
        return instance.getCrowdFundAddress.call();
    }).then(function(address) {
        console.log("address: " + address);
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPToken.deployed().then(function(instance) {
        console.log("balance of: " + GPTCrowdsale.address);
        return instance.balanceOf.call(GPTCrowdsale.address);//accounts[0]);
    }).then(function(balance) {
        console.log("tokens: " + balance);
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });
};