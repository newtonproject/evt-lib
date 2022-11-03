// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0;

/// @title GetString
/// @author Damon - <>
/// @notice Provides functions for tranfering to String
library GetString {
    /**
     * @dev Converts a bytes data to its ASCII string decimal representation.
     */
    function toString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    /**
     * @dev Transfer the string array to a string of JSON format.
     * 
     * @param args - String array consist of Object in JSON format.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getStringData(string[] memory args) internal pure returns (string memory) {
        string memory properties = '[';
        for (uint256 i = 0; i < args.length; i++) {
            if (i + 1 == args.length) {
                properties = string(abi.encodePacked(properties, args[i]));
            } else {
                properties = string(abi.encodePacked(properties, args[i], ','));
            }
        }
        properties = string(abi.encodePacked(properties, ']'));
        return properties;
    }
}