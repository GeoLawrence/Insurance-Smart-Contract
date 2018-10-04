const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3 (ganache.provider());

const { interface, bytecode } = require('../compile');

let insurance;
let accounts;

beforeEach(async () => {
  accounts = await web3.eth.getAccounts();

  insurance = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas: '1000000' });
});

describe ('Medrisc Contract', () => {
  it('deploys a contract', () => {
    assert.ok(insurance.options.address);
  });

  it ('allows one account to enter and pay premium', async () => {
    await insurance.methods.underwrite().send({
      from: accounts[0],
      value: web3.utils.toWei('2', 'ether')
    });

    assert.ok(insurance.options.address);

  });



  it ('allows multiple account to enter', async () => {

    await insurance.methods.underwrite().send({
      from: accounts[0],
      value: web3.utils.toWei('2', 'ether')
    });

    await insurance.methods.underwrite().send({
      from: accounts[1],
      value: web3.utils.toWei('2', 'ether')
    });

    await insurance.methods.underwrite().send({
      from: accounts[2],
      value: web3.utils.toWei('2', 'ether')
    });

    assert.ok(insurance.options.address);
  });


    it ('only manager can call verified', async() => {
      try {
        await insurance.methods.verified().send({
          from: Accounts[0]
        });

          assert(false);
        } catch (err) {
          assert(err);
        }
    });

});
