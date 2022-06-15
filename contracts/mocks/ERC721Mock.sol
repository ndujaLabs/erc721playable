// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "../ERC721Playable.sol";

contract ERC721Mock is ERC721Playable, ERC721Enumerable, Ownable {
  using Address for address;
  address public player;
  uint256 private _nextTokenId = 1;

  constructor() ERC721Playable("Some NFT", "SNFT") {}

  function _beforeTokenTransfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal override(ERC721Playable, ERC721Enumerable) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721Playable, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function mint(address recipient, uint256 quantity) external onlyOwner {
    for (uint256 i = 0; i < quantity; i++) {
      _mint(recipient, _nextTokenId++);
    }
  }

  function mintAndInit(address recipient, address _player,
    uint8[31] calldata _initialAttributes) external onlyOwner {
      _initAttributesAndSafeMint(recipient, _nextTokenId++, _player, _initialAttributes);
  }
}
