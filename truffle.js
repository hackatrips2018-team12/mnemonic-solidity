var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "orange banana";

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' // Match any network id
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/LGYfoxWqw7tO8gxMlrjt")
      },
      network_id: 3
    }        
  }

}
