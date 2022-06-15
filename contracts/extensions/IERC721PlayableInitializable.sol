// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC721Playable.sol";

interface IERC721PlayableInitializable is IERC721Playable {

  /// @notice Initialize the initial attributes of a token during the minting
  /// @dev It must be called by the contract's owner.
  /// @param _to The recipient of the token
  /// @param _tokenId The id of the token for whom to change the attributes
  /// @param _player The pre-configured player
  /// @param _initialAttributes The initial attributes
  function initAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player,
    uint8[31] calldata _initialAttributes
  ) external;
}
