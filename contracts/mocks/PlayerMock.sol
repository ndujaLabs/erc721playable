// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Author: Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "@openzeppelin/contracts/access/Ownable.sol";
import "../IERC721Playable.sol";

import "hardhat/console.sol";

interface NFTPlayable is IERC721Playable {
  function ownerOf(uint256 _tokenId) external returns (address);
}

contract PlayerMock is Ownable {

  function isTokenInitialized(NFTPlayable _nft, uint256 _tokenId) public view returns (bool) {
    //    require(_nft.supportsInterface(type(NFTPlayable).interfaceId), "not a playable NFT");
    return _nft.attributesOf(_tokenId, address(this)).version > 0;
  }

  function fillInitialAttributes(
    address _nft,
    uint256 _tokenId,
    uint8 _version,
    uint8[] memory _attributes
  ) external onlyOwner {
    NFTPlayable nft = NFTPlayable(_nft);
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
    NFTPlayable nft = NFTPlayable(_nft);
    // this is just an example,
    // where the level attribute is the 4th element in the array
    uint256[] memory indexes = new uint256[](1);
    indexes[0] = _levelIndex;
    uint8[] memory attributes = new uint8[](1);
    attributes[0] = _newLevel;
    nft.updateAttributes(_tokenId, 0, indexes, attributes);
  }

  function isNFTPlayable(address addr) public view returns (bool) {
    IERC721Playable nft = IERC721Playable(addr);
    try nft.isMCIP1() returns (bool yes) {
      if (yes) {
        return true;
      }
    } catch Error(string memory) {
    } catch (bytes memory) {
    }
    return false;
  }
}
