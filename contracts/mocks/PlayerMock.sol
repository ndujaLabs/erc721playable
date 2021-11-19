// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts/access/Ownable.sol";
import "../IERC721Playable.sol";

interface NFTPlayable is IERC721Playable {

  function ownerOf(uint _tokenId) external returns(address);
}

contract PlayerMock is Ownable {

  function isPlayable(NFTPlayable nft) public view returns (bool) {
    return nft.supportsInterface(type(NFTPlayable).interfaceId);
  }

  function isTokenInitialized(NFTPlayable _nft, uint256 _tokenId) public view returns (bool){
    return _nft.attributesOf(_tokenId, address(this)).version > 0;
  }

  function initNFT(
    address _nft,
    uint256 _tokenId
  ) external {
    NFTPlayable nft = NFTPlayable(_nft);
    require(isPlayable(nft), "not an MCIP1 NFT");
    require(!isTokenInitialized(nft, _tokenId), "attributes already set");
    require(nft.ownerOf(_tokenId) == _msgSender(), "not the token owner");
    nft.initAttributes(_tokenId, address(this));
  }

  function fillInitialAttributes(
    address _nft,
    uint256 _tokenId,
    uint8 _version,
    uint8[] memory _attributes
  ) external onlyOwner {
    NFTPlayable nft = NFTPlayable(_nft);
    require(isPlayable(nft), "not an MCIP1 NFT");
    require(!isTokenInitialized(nft, _tokenId), "attributes already set");
    require(nft.ownerOf(_tokenId) == _msgSender(), "not the token owner");
    uint256[] memory indexes = new uint256[](_attributes.length);
    for (uint i = 0; i < _attributes.length; i++) {
      indexes[i] = i;
    }
    nft.updateAttributes(_tokenId, _version, indexes, _attributes);
  }

  function levelUp(
    address _nft,
    uint256 _tokenId,
    uint8 _newLevel
  ) external onlyOwner {
    NFTPlayable nft = NFTPlayable(_nft);
    require(isPlayable(nft), "not an MCIP1 NFT");
    require(isTokenInitialized(nft, _tokenId), "attributes not set yet");
    // this is just an example,
    // where the level attribute is the 4th element in the array
    uint256 levelIndex = 3;
    uint256[] memory indexes = new uint256[](1);
    indexes[0] = levelIndex;
    uint8[] memory attributes = new uint8[](1);
    attributes[0] = _newLevel;
    nft.updateAttributes(_tokenId, 0, indexes, attributes);
  }
}
