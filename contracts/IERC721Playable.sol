// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// Initial proposal
// https://github.com/ndujaLabs/MCIPs/blob/main/MCIPs/mcip-1.md

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

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
  function initAttributes(uint256 _tokenId, address _player) external returns (bool);

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
