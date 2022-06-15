// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

//import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./IERC721PlayableInitializable.sol";
import "../ERC721PlayableUpgradeable.sol";

contract ERC721PlayableInitializableUpgradeable is ERC721PlayableUpgradeable, IERC721PlayableInitializable, OwnableUpgradeable {
  using AddressUpgradeable for address;

  function __ERC721PlayableInitializable_init(string memory name_, string memory symbol_) internal initializer {
    __ERC721Playable_init(name_, symbol_);
    __Ownable_init();
  }

  function initAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player,
    uint8[31] calldata _initialAttributes
  ) public virtual override onlyOwner {
    require(_player.isContract(), "ERC721PlayableInitializableUpgradeable: player not a contract");
    _attributes[_tokenId][_player] = Attributes({version: 1, attributes: _initialAttributes});
    _safeMint(_to, _tokenId);
  }
}
