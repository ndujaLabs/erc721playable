// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./IERC721Playable.sol";

contract ERC721Playable is IERC721Playable, ERC721 {
  using Address for address;
  mapping(uint256 => mapping(address => Attributes)) internal _attributes;

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

  function _beforeTokenTransfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal virtual override(ERC721) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  //  function getInterfaceId() external view returns(bytes4) {
  //    return type(IERC721Playable).interfaceId;
  //  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
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

  // this internal function can be called by the mint function to pre-initialize a token
  function _initAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player,
    uint8[31] memory _initialAttributes
  ) internal {
    require(_player.isContract(), "ERC721PlayableUpgradeable: player not a contract");
    _attributes[_tokenId][_player] = Attributes({version: 1, attributes: _initialAttributes});
    _safeMint(_to, _tokenId);
  }
}
