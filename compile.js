const path = require('path');
const fs = require('fs');
const solc = require('solc');

//get path smart contract
const inboxPath = path.resolve(__dirname, 'contracts', 'Arisan.sol');

//read file smart contract
const source = fs.readFileSync(inboxPath, 'utf8');

//config compiler smart contract
const input = {
  language: 'Solidity',
  sources: {
    'Arisan.sol': {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*'],
      },
    },
  },
};

//process compile smart contract
module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  'Arisan.sol'
].Arisan;
