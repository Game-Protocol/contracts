var GPToken = artifacts.require("./GPToken.sol");
var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");
var fs = require('fs');
const verifyCode = require('../scripts/verifyCode');
const toTimestamp = require('../scripts/toTimestamp');


module.exports = function (deployer) {
  var prefs_json = JSON.parse(fs.readFileSync("../prefs.json", "utf8"));
  var beneficiary = prefs_json["beneficiary"];
  var team = prefs_json["team"];
  var advisors = prefs_json["advisors"];
  var bountyProgram = prefs_json["bountyprogram"];
  var gameSupportFund = prefs_json["gamesupportfund"];

  var start = toTimestamp.getTimeStamp('2018-05-15 12:00:00');
  var end = toTimestamp.getTimeStamp('2018-07-01 12:00:00');
  var rate = new web3.BigNumber(2000);

  verifyCode.flatten("GPToken.sol");
  verifyCode.flatten("GPTCrowdsale.sol");

  deployer.deploy(GPToken).then(function () {
    var types = ["uint256" ,"uint256" ,"uint256" ,"address" ,"address" ,"address" ,"address" , "address" , "address"];
    var params = [start, end, rate, beneficiary, gameSupportFund, bountyProgram, advisors, team, GPToken.address];
    verifyCode.toABI("GPTCrowdsale.abi.txt", types, params);
    deployer.deploy(GPTCrowdsale, start, end, rate, beneficiary, gameSupportFund, bountyProgram, advisors, team, GPToken.address);
  });
};