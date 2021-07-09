const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { abi, evm } = require('./compile');

///login wallet provider
const provider = new HDWalletProvider(
  'fill with mnemonic frasa',
  'fill with etherium node api'
);

///connect web3js to wallet
const web3 = new Web3(provider);

///deployment process
const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  const result = await new web3.eth.Contract(abi)
    .deploy({ data: evm.bytecode.object, arguments: [] })
    .send({
      from: accounts[0],
      gas: '4712388',
      gasPrice: await web3.eth.getGasPrice(),
    });
  console.log('Contract Deployed to: ', result.options.address);
  console.log('abi', abi);
};

deploy();
