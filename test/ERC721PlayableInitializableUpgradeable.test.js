const {expect, assert} = require("chai")
const {deployContract, deployContractUpgradeable} = require('./helpers')

describe("ERC721PlayableInitializableUpgradeable", function () {

  let erc721Mock
  let playerMock

  let owner, holder

  before(async function () {
    [owner, holder, playerMock] = await ethers.getSigners()
  })

  beforeEach(async function () {
    erc721Mock = await deployContractUpgradeable('ERC721InitializableMockUpgradeable')
  })

  it("should mint token and set attributes", async function () {

    await erc721Mock.initAttributesAndSafeMint(holder.address, 1, playerMock.address,
        [1, 5, 34, 21, 8, 0, 34, 12, 31, 65, 178, 243, 2, 1, 5, 34, 21, 8, 0, 34, 12, 31, 65, 178, 243, 2, 1, 5, 34, 21, 8]);

    expect(await erc721Mock.ownerOf(1)).to.equal(holder.address)
    //
    const attributes = await erc721Mock.attributesOf(1, playerMock.address)
    expect(attributes.version).to.equal(1)
  })

})
