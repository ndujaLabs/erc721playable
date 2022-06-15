// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

//import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./IERC721Playable.sol";

contract ERC721PlayableUpgradeable is IERC721Playable, ERC721Upgradeable {
  using AddressUpgradeable for address;

  mapping(uint256 => mapping(address => Attributes)) internal _attributes;

  function __ERC721Playable_init(string memory name_, string memory symbol_) internal initializer {
    __ERC721_init(name_, symbol_);
  }

  function _beforeTokenTransfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal virtual override(ERC721Upgradeable) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable) returns (bool) {
    return interfaceId == type(IERC721Playable).interfaceId || super.supportsInterface(interfaceId);
  }

  function attributesOf(uint256 _tokenId, address _player) public view override returns (Attributes memory) {
    return _attributes[_tokenId][_player];
  }

  function _emptyAttributesArray() internal pure returns (uint8[31] memory) {
    uint8[31] memory arr;
    return arr;
  }

  function initAttributes(uint256 _tokenId, address _player) external override returns (bool) {
    // called by the nft's owner
    require(_player.isContract(), "ERC721Playable: _player not a contract");
    require(ownerOf(_tokenId) == _msgSender(), "ERC721Playable: not the token owner");
    require(_attributes[_tokenId][_player].version == 0, "ERC721Playable: player already initialized");
    _attributes[_tokenId][_player] = Attributes({version: 1, attributes: _emptyAttributesArray()});
    return true;
  }

  function updateAttributes(
    uint256 _tokenId,
    uint8 _newVersion,
    uint256[] memory _indexes,
    uint8[] memory _values
  ) public override returns (bool) {
    // called by a previously initiated player
    require(_indexes.length == _values.length, "ERC721Playable: inconsistent lengths");
    require(_attributes[_tokenId][_msgSender()].version > 0, "ERC721Playable: player not initialized");
    if (_newVersion > _attributes[_tokenId][_msgSender()].version) {
      _attributes[_tokenId][_msgSender()].version = _newVersion;
    }
    for (uint256 i = 0; i < _indexes.length; i++) {
      _attributes[_tokenId][_msgSender()].attributes[_indexes[i]] = _values[i];
    }
    return true;
  }
}
