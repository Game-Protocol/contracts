var GPToken = artifacts.require("./GPToken.sol");
var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");
var fs = require('fs');

module.exports = function (deployer) {
  var prefs_json = JSON.parse(fs.readFileSync("../../prefs.json", "utf8"));
  var team = prefs_json["team"];
  var advisors = prefs_json["advisors"];
  var marketing = prefs_json["marketing"];
  var beneficiary = prefs_json["beneficiary"];
  deployer.deploy(GPTCrowdsale, beneficiary, 30, 1000, 4, 20).then(function () {
    return deployer.deploy(GPToken, GPTCrowdsale.address, advisors, marketing, team, 30).then(function () {
      GPTCrowdsale.deployed().then(function (instance) {
        return instance.setToken(GPToken.address);
      });
    });
  });
};
