var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");

contract('GPTCrowdsale', function(accounts) {
    it("timeSteps test", function() {
        return GPTCrowdsale.deployed().then(function(instance) {
            return instance.getSteps.call();
        }).then(function(steps) {
            console.log(steps.valueOf());
        });
    });
});

contract('GPTCrowdsale', function(accounts) {
    it("getPrices test", function() {
        return GPTCrowdsale.deployed().then(function(instance) {
            return instance.getPrices.call();
        }).then(function(prices) {
            console.log(prices.valueOf());
        });
    });
});

contract('GPTCrowdsale', function(accounts) {
    it("getStep test", function() {
        return GPTCrowdsale.deployed().then(function(instance) {
            return instance.getStep.call();
        }).then(function(step) {
            console.log("Step: " + step.valueOf());
        });
    });
});

contract('GPTCrowdsale', function(accounts) {
    it("getTokenFromEther test", function() {
        return GPTCrowdsale.deployed().then(function(instance) {
            return instance.getTokenFromEther.call(10000000000000000);
        }).then(function(coins) {
            console.log("Got Coins: " + coins.valueOf());
        });
    });
});