const {expect, assert} = require("chai")

// NOT WORKING YET

describe("EverDragons2", function () {

  let ERC721Mock
  let erc721Mock
  let GameMock
  let gameMock

  let addr0 = '0x0000000000000000000000000000000000000000'
  let owner, teamMember, validator, collector1, collector2, edOwner1, edOwner2

  async function assertThrowsMessage(promise, message, showError) {
    try {
      await promise
      assert.isTrue(false)
      console.error('This did not throw: ', message)
    } catch (e) {
      if (showError) {
        console.error('Expected: ', message)
        console.error(e.message)
      }
      assert.isTrue(e.message.indexOf(message) > -1)
    }
  }

  before(async function () {
    [owner, teamMember, validator, collector1, collector2, edOwner1, edOwner2] = await ethers.getSigners()
  })

  beforeEach(async function () {
    ERC721Mock = await ethers.getContractFactory("Erc721Mock")
    erc721Mock = await ERC721Mock.deploy()
    await erc721Mock.deployed()
    GameMock = await ethers.getContractFactory("GameMock")
    gameMock = await GameMock.deploy(erc721Mock.address)
    await gameMock.deployed()
    erc721Mock.setManager(gameMock.address)
  })

  it("should return that the NFT has not being initiated by the game", async function () {
    expect(await erc721Mock.attributesOf(gameMock.address, 1)).to.equal("EverDragons2")
    expect(await erc721Mock.symbol()).to.equal("ED2")
    expect(await erc721Mock.manager()).to.equal(gameMock.address)
    expect(await erc721Mock.ownerOf(10001)).to.equal(owner.address)

    // console.log(await everDragons2.getInterfaceId())
  })

  it("should mint token 23, 100 and 3230 and give them to collector1", async function () {

    const tokenIds = [23, 100, 3230]

    await expect(gameMock['mint(address,uint256[])'](collector1.address, tokenIds))
        .to.emit(erc721Mock, 'Transfer')
        .withArgs(addr0, collector1.address, tokenIds[0])
        .to.emit(erc721Mock, 'Transfer')
        .withArgs(addr0, collector1.address, tokenIds[1])
        .to.emit(erc721Mock, 'Transfer')
        .withArgs(addr0, collector1.address, tokenIds[2]);

    expect(await erc721Mock.ownerOf(tokenIds[0])).to.equal(collector1.address)
    expect(await erc721Mock.tokenOfOwnerByIndex(collector1.address, 0)).to.equal(tokenIds[0])
    expect(await erc721Mock.tokenOfOwnerByIndex(collector1.address, 1)).to.equal(tokenIds[1])
    expect(await erc721Mock.tokenOfOwnerByIndex(collector1.address, 2)).to.equal(tokenIds[2])

  })

  it("should mint token 23, 100 and 3230 and give two to collector1 and one to collector2", async function () {

    const tokenIds = [23, 100, 3230]

    await expect(gameMock['mint(address[],uint256[])']([collector1.address, collector2.address, collector1.address,], tokenIds))
        .to.emit(erc721Mock, 'Transfer')
        .withArgs(addr0, collector1.address, tokenIds[0])
        .to.emit(erc721Mock, 'Transfer')
        .withArgs(addr0, collector2.address, tokenIds[1])
        .to.emit(erc721Mock, 'Transfer')
        .withArgs(addr0, collector1.address, tokenIds[2])

    expect(await erc721Mock.ownerOf(tokenIds[0])).to.equal(collector1.address)
    expect(await erc721Mock.ownerOf(tokenIds[1])).to.equal(collector2.address)
    expect(await erc721Mock.ownerOf(tokenIds[2])).to.equal(collector1.address)
  })

  it("should throw if dragons master tries to mint when minting is ended", async function () {

    await erc721Mock.endMinting()
    const tokenIds = [1, 2, 3, 4]
    await expect(gameMock['mint(address,uint256[])'](collector1.address, tokenIds))
        .revertedWith('Minting ended')
  })

})
