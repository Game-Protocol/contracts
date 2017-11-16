var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");
var GPToken = artifacts.require("./GPToken.sol");


module.exports = function (done) {
    GPToken.deployed().then(function(instance) {
        console.log("getTime: [" + GPToken.address + "]");
        return instance.getTime.call();
    }).then(function(time) {
        console.log("Deadline T " + time);
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPTCrowdsale.deployed().then(function(instance) {
        console.log("getTokenFromEther (0.1 eth): [" + GPTCrowdsale.address + "]");
        return instance.getTokenFromEther.call(100000000000000000); // 0.1 eth
    }).then(function(amount) {
        console.log("Amount: " + amount.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPToken.deployed().then(function(instance) {
        console.log("releaseTeamTokens: [" + GPToken.address + "]");
        return instance.releaseTeamTokens();
    }).then(function(success) {
        console.log("Team released: " + success.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPToken.deployed().then(function(instance) {
        console.log("releaseAdvisorTokens: [" + GPToken.address + "]");
        return instance.releaseAdvisorTokens();
    }).then(function(success) {
        console.log("Advisor released: " + success.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPToken.deployed().then(function(instance) {
        console.log("retrieveUnsoldTokens: [" + GPToken.address + "]");
        return instance.retrieveUnsoldTokens();
    }).then(function(success) {
        console.log("Unsold retrieved: " + success.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPToken.deployed().then(function(instance) {
        console.log("getTeamTranchesReleased: [" + GPToken.address + "]");
        return instance.getTeamTranchesReleased.call();
    }).then(function(number) {
        console.log("Tranches released: " + number);
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });

    GPTCrowdsale.deployed().then(function(instance) {
        console.log("tokensSold (0.1 eth): [" + GPTCrowdsale.address + "]");
        return instance.tokensSold.call();
    }).then(function(tokens) {
        console.log("Tokens Sold: " + tokens.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });
};