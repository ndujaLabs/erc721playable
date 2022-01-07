# Cross-player on-chain NFT attributes

Discussion at https://github.com/ndujaLabs/MCIPs/issues/3

Author: Francesco Sullo <francesco@sullo.co>

## Simple Summary

A proposal to extend the ERC721 standard with a struct and a few functions to allow players, for example games, to use NFTs storing data on the NFT itself.

This repo implements the [MCIP-1 proposal](https://github.com/ndujaLabs/MCIPs/blob/main/MCIPs/mcip-1.md) mantaining full compatibility with the ERC721 standard.


## Motivation

The standard ERC721 works very well for collectibles, despite being introduced by a game. Decentralized player, for example games, need attributes and other information on chain to be able to play with it. For example, the [original EverDragons factory](https://github.com/mscherer82/everdragons/blob/master/everdragons-contract/contracts/EverDragonsFactory.sol) was implementing the following

```solidity
    struct Dragon {
        bytes32 name;
        uint24 attributes;
        uint32 experience;
        uint32 prestige;
        uint16 state;
        mapping(bytes32 => uint32) items;
    }
```

to manage mutable and immutable properties of a dragon. The limit of this model is that the properties were predefined and a different game could not reuse the same approach.

Projects like [EverDragons2](https://everdragons2.com), which does not have a ready game right now, need a generic solution that establish basic rules and is flexible enough to manage most scenarios and make NFT really movable among games. The same rules can be helpful in any other game, as well as in any platform that can take advantage for managing an array of values in the NFT.

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.


```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC721Playable Cross-player On-chain Attributes
///  Version: 0.1.1
/// ERC165 interfaceId is 0xac517b2e
interface IERC721Playable /* is IERC165 */ {

  /// @dev Emitted when the attributes for a token id and a player is set.
  event AttributesSet(uint256 indexed _tokenId, address indexed _player, Attributes _attributes);

  /// @dev This struct saves info about the token.
  struct Attributes {
    // A player can change the way it manages the data, updating the version
    // If 8 bits are not enough, one attribute can be used to form a uint16
    // Alternatively, we could use the first attribute as a version, but it
    // would use the same space, making the concept less clear
    uint8 version;

    // Attributes can be immutable (for example because taken from the attributes.json)
    // or mutable, because they depends only on the player itself.
    // If a field requires more than 256 possible value, two bytes can be used for it.
    uint8[31] attributes;
  }

  /// @dev It returns the on-chain attributes of a specific token
  /// @param _tokenId The id of the token for whom to query the on-chain attributes
  /// @param _player The address of the player's contract
  /// @return The attributes of the token
  function attributesOf(uint256 _tokenId, address _player) external view returns (Attributes memory);

  /// @notice Initialize the attributes of a token
  /// @dev It must be called by the nft's owner to approve the player.
  /// To avoid that nft owners give themselves arbitrary values, they can
  /// only set an empty uint8[], with version = 1
  /// Later, the player will be able to update array and version, with the right values
  /// @param _tokenId The id of the token for whom to change the attributes
  /// @param _player The version of the attributes
  /// @return true if the initialization is successful
  function initAttributes(
    uint256 _tokenId,
    address _player
  ) external returns (bool);

  /// @notice Sets the attributes of a token after first set up
  /// @dev It modifies attributes by id for a specific player. It must
  /// be called by the player's contract, after an NFT has been initialized.
  /// @param _tokenId The id of the token for whom to change the attributes
  /// @param _newVersion It should be changed only when introducing a new set
  /// of attributes. If set to zero, the update should be ignored.
  /// @param _indexes The indexes of the attributes to be changed
  /// @param _attributes The values of the attributes to be changed
  /// @return true if the change is successful
  function updateAttributes(
    uint256 _tokenId,
    uint8 _newVersion,
    uint256[] memory _indexes,
    uint8[] memory _attributes
  ) external returns (bool);
}

```

## Rationale

The reason why ERC721 metadata are off-chain makes perfect sense in general, in particular for immutable collectibles, but it does not allow pure on-chain games to interact with the NFT because they cannot access the metadata. This proposal adds a relatively inexpensive solution to it.

Imagine that there are two Bored Ape with the same rarity, but the two apes are used in a game. If one of the two gets very good attributes, whoever will by the ape will also buy levels in the game where the ape played. So, the value on the market of the good ape will be higher that the value of the ape who is a bad player.

Of course, to work as expected, OpenSea and other marketplace should have a list of games and be able to retrieve the attributes on game of any NFT.

## NFT Owner inits and Player updates

If NFT owners are allowed to update the attributes of their tokens, they could set whichever value the want, so the only the Player must be able to update the attributes. It is important that the owner cannot revoke the approval because if not, owners could play a game and, when they realized they are decreasing their score, before that the game updates the attributes, they revoke the approval.

On the other hand, if the Player initializes the token, spam will florish. For example, a bad game could initialize tokens pretending that their owner played the game. Think of a porn game that sets your NFT and pretends that you have high scores. That can be a problem, right? The solution is that the Owner only can initialize the attribute for a specific game. 

## Recommendation

The on-chain Metadata must be used only for important informations, like, for example, level ups. If used for frequent changing values, too many changes will congestionate the blockchain.

## Interaction with NFT marketplaces

A game just need to be able to set attributes in the NFT to manage it. Marketplace, however, need more information to show their users the attributes in a way that makes sense and helps users to value a token.  It is unrealistic to expect that a marketplace understands what an attribute is used for in any game in the crypto metaverse. 

The solution is an interface that any game can implement to expose a map that shows what any attribute is for.

We will cover this in a future proposal, but the idea is to expose a function like
```solidity
function attributesURI(uint8 _version) external returns(string memory);
```
which should return a JSON file allowing the marketplace to interpretate any attribute for a specific version, and return the full set of information if the passed version is `0`.

## Backwards Compatibility

This is totally compatible with the ERC721 standard.

## Implementation

This repo implements a full working contract at https://github.com/ndujaLabs/erc721playable/blob/main/contracts/ERC721Playable.sol

## Install an usage

Install with
```
npm install @ndujalabs/erc721playable
```
and use as
```solidity
import "@ndujalabs/erc721playable/contracts/ERC721Playable.sol";

contract YourNFT is ERC721Playable {
   ...
```

## License

MIT

## Copyright

(c) 2021 [Francesco Sullo](https://francesco.sullo.co) & [Nduja Labs](https://ndujalabs.com)
