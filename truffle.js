var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "stairs repeat useless cram pet comic junior vehicle worry banner soda echo";

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' // Match any network id
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/LGYfoxWqw7tO8gxMlrjt", 2);
      },
      network_id: 3
    }        
  }

}
