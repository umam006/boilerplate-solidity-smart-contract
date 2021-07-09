const assert = require('assert')
const ganache = require('ganache-cli')
const Web3 = require('web3')
const {abi, evm} = require('../compile')

const web3 = new Web3(ganache.provider())


let accounts;
let inbox;

beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    inbox = await new web3.eth.Contract(abi)
        .deploy({data: evm.bytecode.object, arguments:['hello!']})
        .send({
            from: accounts[0], 
            gas: '4712388',
            gasPrice: await web3.eth.getGasPrice()
        });
});


describe('Inbox', () => {
    it('deployes a contract', () => {
        assert.ok(inbox.options.address)
    })

    it('has default message', async () => {
        const message = await inbox.methods.getMessage().call();
        assert.strictEqual(message, 'hello!');
    })

    it('can update message', async () => {
        await inbox.methods.setMessage('Hai!').send({from: accounts[0], gas: await web3.eth.estimateGas({ from: accounts[0] })});
        const message = await inbox.methods.getMessage().call();
        assert.strictEqual(message, 'Hai!');
    })

})