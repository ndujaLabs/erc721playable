// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract ERC721NotPlayableMockUpgradeable is Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize() public initializer {
    __ERC721_init("Some Not Playable NFT", "SNPNFT");
    __Ownable_init();
    __UUPSUpgradeable_init();
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

  function _beforeTokenTransfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal override(ERC721Upgradeable) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
