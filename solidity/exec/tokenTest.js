var GPToken = artifacts.require("./GPToken.sol");


module.exports = function (done) {
    console.log("Getting deployed version of GPToken...")
    GPToken.deployed().then(function (instance) {
        console.log("balanceOf 0x141032b5a998f917f1e8cd3b3e32a62220ac70d0");
        return instance.balanceOf.call("0x141032b5a998f917f1e8cd3b3e32a62220ac70d0");
    }).then(function (amount) {
        console.log("Result: " + amount.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });
};

module.exports = function (done) {
    console.log("Getting deployed version of GPToken...")
    GPToken.deployed().then(function (instance) {
        console.log("crowdFundAddress");
        return instance.getCrowdFundAddress.call();
    }).then(function (address) {
        console.log("CrowdFundAddress: " + address.valueOf());
        done();
    }).catch(function (e) {
        console.log(e);
        done();
    });
};