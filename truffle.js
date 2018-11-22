const HDWalletProvider = require("truffle-hdwallet-provider");
require('dotenv').config();

module.exports = {
     // See <http://truffleframework.com/docs/advanced/configuration>
     // to customize your Truffle configuration!
     networks: {
          ganache: {
               host: "localhost",
               port: 7545,
               network_id: "*" // Match any network id
          },

          chainskills: {
               host: "localhost",
               port: 8545,
               network_id: "4224",
               gas: 4700000,
               // from: '0x85b2c41e4c801ff408852a75a08939589d1b6eaf'
          },

          rinkeby: {
               host: "http://127.0.0.1",
               port: 8545,
               network_id: 4, //rinkeby test network
               gas: 5000000
               // from: "0xbe572fe4102c5247713b154f0db83186e0315b1c"
          },

          ropsten: {
               provider: function () {
                   return new HDWalletProvider(process.env.MNEMONIC, "https://ropsten.infura.io/v3/" + process.env.INFURA_API_KEY);
               },
               network_id: 3,
               gas: 4500000,
               gasPrice: 10000000000
         }
     }
};
