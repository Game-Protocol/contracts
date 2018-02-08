var HDWalletProvider = require("truffle-hdwallet-provider");
var fs = require('fs');

var prefs_json = JSON.parse(fs.readFileSync("../prefs.json", "utf8"));
var infuraApi = prefs_json["infura_api"];
var ownerWallet = prefs_json["owner"];
// console.log("infuraApi: \n", infuraApi);
// console.log("ownerWallet: \n", ownerWallet);

var wallets_json = JSON.parse(fs.readFileSync("../wallets.json", "utf8"));
var key = wallets_json[ownerWallet];
// console.log("key: \n", key);


module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    mainnet: {
      provider: new HDWalletProvider(key, "https://mainnet.infura.io/" + infuraApi),
      network_id: 2,
    },
    ropsten: {
      provider: new HDWalletProvider(key, "https://ropsten.infura.io/" + infuraApi),
      network_id: 3,
    },
    rinkeby: {
      provider: new HDWalletProvider(key, "https://rinkeby.infura.io/" + infuraApi),
      network_id: 4,
    }
  }
};