// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

//import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./IERC721PlayableInitializable.sol";
import "../ERC721Playable.sol";

contract ERC721PlayableInitializable is ERC721Playable, IERC721PlayableInitializable, Ownable {
  using Address for address;

  constructor(string memory name, string memory symbol) ERC721Playable(name, symbol) {}

  function initAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player,
    uint8[31] calldata _initialAttributes
  ) public override virtual onlyOwner {
    require(_player.isContract(), "ERC721PlayableInitializable: player not a contract");
    _attributes[_tokenId][_player] = Attributes({version: 1, attributes: _initialAttributes});
    _safeMint(_to, _tokenId);
  }
}
