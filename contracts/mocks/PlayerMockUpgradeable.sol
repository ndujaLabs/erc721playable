// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../ERC721PlayableUpgradeable.sol";

import "hardhat/console.sol";

contract PlayerMockUpgradeable is Initializable, OwnableUpgradeable, UUPSUpgradeable {
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize() public initializer {
    __Ownable_init();
    __UUPSUpgradeable_init();
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

  function isTokenInitialized(ERC721PlayableUpgradeable _nft, uint256 _tokenId) public view returns (bool) {
    require(isNFTPlayable(address(_nft)), "not a playable NFT");
    return _nft.attributesOf(_tokenId, address(this)).version > 0;
  }

  function fillInitialAttributes(
    address _nft,
    uint256 _tokenId,
    uint8 _version,
    uint8[] memory _attributes
  ) external onlyOwner {
    ERC721PlayableUpgradeable nft = ERC721PlayableUpgradeable(_nft);
    uint256[] memory indexes = new uint256[](_attributes.length);
    for (uint256 i = 0; i < _attributes.length; i++) {
      indexes[i] = i;
    }
    nft.updateAttributes(_tokenId, _version, indexes, _attributes);
  }

  function levelUp(
    address _nft,
    uint256 _tokenId,
    uint256 _levelIndex,
    uint8 _newLevel
  ) external onlyOwner {
    ERC721PlayableUpgradeable nft = ERC721PlayableUpgradeable(_nft);
    // this is just an example,
    // where the level attribute is the 4th element in the array
    uint256[] memory indexes = new uint256[](1);
    indexes[0] = _levelIndex;
    uint8[] memory attributes = new uint8[](1);
    attributes[0] = _newLevel;
    nft.updateAttributes(_tokenId, 0, indexes, attributes);
  }

  function isNFTPlayable(address _nft) public view returns (bool) {
    ERC721PlayableUpgradeable nft = ERC721PlayableUpgradeable(_nft);
    return nft.supportsInterface(0xac517b2e);
  }
}
