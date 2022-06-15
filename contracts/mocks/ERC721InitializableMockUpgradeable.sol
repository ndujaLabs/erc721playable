// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "../extensions/ERC721PlayableInitializableUpgradeable.sol";

contract ERC721InitializableMockUpgradeable is
  Initializable,
  ERC721PlayableInitializableUpgradeable,
  UUPSUpgradeable
{
  using AddressUpgradeable for address;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize() public initializer {
    __ERC721PlayableInitializable_init("Some NFT", "SNFT");
    __UUPSUpgradeable_init();
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

  function initAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player,
    uint8[31] calldata _initialAttributes
  ) public virtual override onlyOwner {
//    require(_player.isContract(), "ERC721PlayableInitializableUpgradeable: player not a contract");
    _attributes[_tokenId][_player] = Attributes({version: 1, attributes: _initialAttributes});
    _safeMint(_to, _tokenId);
  }
}
