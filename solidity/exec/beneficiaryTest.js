var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");

module.exports = function (done) {
    GPTCrowdsale.deployed().then(function(instance) {
        console.log("changeBeneficiary: [" + GPTCrowdsale.address + "]");
        return instance.changeBeneficiary("0x40570a290f4e1810ce374cdc23e24facdc6f318b");
    }).then(function(success) {
        console.log("changeBeneficiary: " + success);
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });
};