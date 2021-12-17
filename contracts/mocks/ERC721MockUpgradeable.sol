// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "../ERC721PlayableUpgradeable.sol";

contract ERC721MockUpgradeable is
  Initializable,
  ERC721PlayableUpgradeable,
  ERC721EnumerableUpgradeable,
  OwnableUpgradeable,
  UUPSUpgradeable
{
  using AddressUpgradeable for address;
  address public player;
  uint256 private _nextTokenId;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize() public initializer {
    __ERC721Playable_init("Some NFT", "SNFT");
    __Ownable_init();
    __UUPSUpgradeable_init();
    _nextTokenId = 1;
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

  function _beforeTokenTransfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal override(ERC721PlayableUpgradeable, ERC721EnumerableUpgradeable) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721PlayableUpgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }

  function mint(address recipient, uint256 quantity) external onlyOwner {
    for (uint256 i = 0; i < quantity; i++) {
      _mint(recipient, _nextTokenId++);
    }
  }
}
