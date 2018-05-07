var GPToken = artifacts.require("./GPToken.sol");
var GPTCrowdsale = artifacts.require("./GPTCrowdsale.sol");
var fs = require('fs');


module.exports = function (deployer) {
  var prefs_json = JSON.parse(fs.readFileSync("../prefs.json", "utf8"));
  var beneficiary = prefs_json["beneficiary"];
  var team = prefs_json["team"];
  var advisors = prefs_json["advisors"];
  var bountyProgram = prefs_json["bountyprogram"];
  var gameSupportFund = prefs_json["gamesupportfund"];

  var start = getTimeStamp('2018-05-15 12:00:00');
  var end = getTimeStamp('2018-07-01 12:00:00');
  var rate = new web3.BigNumber(2000);

  deployer.deploy(GPToken).then(function () {
    deployer.deploy(GPTCrowdsale, start, end, rate, beneficiary, gameSupportFund, bountyProgram, advisors, team, GPToken.address);
  });
};


// var start = getTimeStamp('2018-05-15 12:00:00');
// var end = getTimeStamp('2018-07-01 12:00:00');
function getTimeStamp(input) {
  var parts = input.trim().split(' ');
  var date = parts[0].split('-');
  var time = (parts[1] ? parts[1] : '00:00:00').split(':');

  // NOTE:: Month: 0 = January - 11 = December.
  var d = Date.UTC(date[0], date[1] - 1, date[2], time[0], time[1], time[2]);
  return d / 1000;
}