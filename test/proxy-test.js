const { expect } = require('chai')
const { ethers } = require('hardhat')

//  wirte the test cases and see the outputs
describe('Proxy', async () => {
  let logic, proxy
  let signer // owner account
  beforeEach(async () => {

    const [owner] = await ethers.getSigners() // account 0
    signer = owner

    const Logic = await ethers.getContractFactory('Logic')
    logic = await Logic.deploy()
    await logic.deployed()

    const Proxy = await ethers.getContractFactory('Proxy')
    proxy = await Proxy.deploy()
    await proxy.deployed()
    await proxy.setImplementation(logic.address)
    
    // abi: Logic contract ABI
    // address: address is the proxy contract address
    const logicContractABI = [
      "function initialize() public",
      "function setMagicNumber(uint256 newMagicNumber) public",
      "function getMagicNumber() public view returns (uint256)"
    ]
    const proxied = new ethers.Contract(proxy.address, logicContractABI, signer)
    await proxied.initialize()
  })

  it('points to an implemenation contract', async () => {
    expect(await proxy.getImplementation()).to.eq(logic.address)
  })

  it('proxies contract calls to the implementation contract', async () => {
  })
})