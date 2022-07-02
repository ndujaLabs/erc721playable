const {expect, assert} = require("chai");
const {deployContract} = require("./helpers");

describe("Uint8Lib", function () {
  let uint8LibMock;

  before(async function () {
    [owner, holder] = await ethers.getSigners();
  });

  beforeEach(async function () {
    uint8LibMock = await deployContract("Uint8Lib");
  });

  it("should convert properly among uint8 and uint16 and uint32", async function () {
    let uint8LibMock = await deployContract("Uint8Lib");

    let value = 24354;
    let [v0, v1] = await uint8LibMock.uint16ToUint8s(value);
    expect(v0).equal(34);
    expect(v1).equal(95);

    expect(await uint8LibMock.uint8ToUint16([v0, v1])).equal(value);

    value = 1254324354;
    [v0, v1, v2, v3] = await uint8LibMock.uint32ToUint8s(value);
    expect(v0).equal(130);
    expect(v1).equal(120);
    expect(v2).equal(195);
    expect(v3).equal(74);

    expect(await uint8LibMock.uint8ToUint32([v0, v1, v2, v3])).equal(value);

    value = ethers.BigNumber.from("276356451254324354");
    [v0, v1, v2, v3, v4, v5, v6, v7] = await uint8LibMock.uint64ToUint8s(value);
    expect(v0).equal(130);
    expect(v1).equal(204);
    expect(v2).equal(102);
    expect(v3).equal(108);
    expect(v4).equal(186);
    expect(v5).equal(208);
    expect(v6).equal(213);
    expect(v7).equal(3);

    expect(await uint8LibMock.uint8ToUint64([v0, v1, v2, v3, v4, v5, v6, v7])).equal(value);
  });
});
