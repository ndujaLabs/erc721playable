const {expect, assert} = require("chai");
const {deployContract} = require("./helpers");

describe("ERC721Playable", function () {
  let erc721Mock;
  let erc721NotPlayableMock;
  let playerMock;

  let owner, holder;

  before(async function () {
    [owner, holder] = await ethers.getSigners();
  });

  beforeEach(async function () {
    erc721Mock = await deployContract("ERC721Mock");
    erc721NotPlayableMock = await deployContract("ERC721NotPlayableMock");
    playerMock = await deployContract("PlayerMock");
  });

  it("should mint token and verify that the player is not initiated", async function () {
    await erc721Mock.mint(holder.address, 1);
    expect(await erc721Mock.ownerOf(1)).to.equal(holder.address);

    const attributes = await erc721Mock.attributesOf(1, playerMock.address);
    expect(attributes.version).to.equal(0);
  });

  it("should mint and pre-initialize ", async function () {
    await erc721Mock.mintAndInit(
      holder.address,
      playerMock.address,
      [1, 5, 34, 21, 8, 0, 34, 12, 31, 65, 178, 243, 2, 1, 5, 34, 21, 8, 0, 34, 12, 31, 65, 178, 243, 2, 1, 5, 34, 21, 8]
    );

    expect(await erc721Mock.ownerOf(1)).to.equal(holder.address);
    //
    const attributes = await erc721Mock.attributesOf(1, playerMock.address);
    expect(attributes.version).to.equal(1);
    expect(attributes.attributes[3]).to.equal(21);
  });

  it("should allow token holder to set a player", async function () {
    await erc721Mock.mint(holder.address, 1);
    await erc721Mock.connect(holder).initAttributes(1, playerMock.address);
    await playerMock.fillInitialAttributes(
      erc721Mock.address,
      1,
      0, // keeps the existent version
      [1, 5, 34, 21, 8, 0, 34, 12, 31, 65, 178, 243, 2]
    );

    const attributes = await erc721Mock.attributesOf(1, playerMock.address);
    expect(attributes.version).to.equal(1);
    expect(attributes.attributes[2]).to.equal(34);
  });

  it("should update the levels in PlayerMock", async function () {
    await erc721Mock.mint(holder.address, 1);
    await erc721Mock.connect(holder).initAttributes(1, playerMock.address);
    await playerMock.fillInitialAttributes(
      erc721Mock.address,
      1,
      0, // keeps the existent version
      [1, 5, 34, 21, 8, 0, 34, 12, 31, 65, 178, 243, 2]
    );

    let attributes = await erc721Mock.attributesOf(1, playerMock.address);
    let levelIndex = 3;
    expect(attributes.attributes[levelIndex]).to.equal(21);

    await playerMock.levelUp(erc721Mock.address, 1, levelIndex, 63);

    attributes = await erc721Mock.attributesOf(1, playerMock.address);
    expect(attributes.attributes[levelIndex]).to.equal(63);
  });

  it("should check if nft is playable", async function () {
    assert.isTrue(await playerMock.isNFTPlayable(erc721Mock.address));
    assert.isFalse(await playerMock.isNFTPlayable(erc721NotPlayableMock.address));
  });
});
