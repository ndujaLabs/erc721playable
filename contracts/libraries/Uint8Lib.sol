// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Author: Francesco Sullo <francesco@sullo.co>
// (c) 2022+ SuperPower Labs Inc.

// If you have date larger than uint64, most likely
// you need something else than a uint8[31] array

library Uint8Lib {
  function uint16ToUint8s(uint16 value) public pure returns (uint8[2] memory) {
    return [uint8(value & 0xff), uint8(value >> 8)];
  }

  function uint8ToUint16(uint8[2] calldata values) public pure returns (uint16) {
    return (uint16(values[1]) << 8) | values[0];
  }

  function uint32ToUint8s(uint32 value) public pure returns (uint8[4] memory) {
    return [uint8(value & 0x000000ff), uint8(value >> 8), uint8(value >> 16), uint8(value >> 24)];
  }

  function uint8ToUint32(uint8[4] memory values) public pure returns (uint32) {
    return (uint32(values[3]) << 24) | (uint32(values[2]) << 16) | (uint32(values[1]) << 8) | values[0];
  }

  function uint64ToUint8s(uint64 value) public pure returns (uint8[8] memory) {
    return [
      uint8(value & 0x000000ff),
      uint8(value >> 8),
      uint8(value >> 16),
      uint8(value >> 24),
      uint8(value >> 32),
      uint8(value >> 40),
      uint8(value >> 48),
      uint8(value >> 56)
    ];
  }

  function uint8ToUint64(uint8[8] memory values) public pure returns (uint64) {
    return
      (uint64(values[7]) << 56) |
      (uint64(values[6]) << 48) |
      (uint64(values[5]) << 40) |
      (uint64(values[4]) << 32) |
      (uint64(values[3]) << 24) |
      (uint64(values[2]) << 16) |
      (uint64(values[1]) << 8) |
      uint64(values[0]);
  }
}
