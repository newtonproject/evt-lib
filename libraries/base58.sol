// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/// @title Base58
/// @author Newton Project
/// @notice Provides a function for encoding some bytes in base58
library Base58 {
    bytes constant ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
    
    function encode(bytes memory input) internal pure returns (string memory) {
        uint inputLength = input.length;
        
        uint prefixZeroes = 0;
        for ( ; 
            prefixZeroes < inputLength && input[prefixZeroes] == 0; 
            prefixZeroes++) {
        }
 

        uint capacity = (inputLength-prefixZeroes)*138/100 + 1; // log256 / log58
        bytes memory output = new bytes(capacity);
        uint outputReverseEnd = capacity - 1;

        uint32 carry;
        uint outputIdx;
        
        for (uint256 inputByteIndex = prefixZeroes; inputByteIndex<inputLength; inputByteIndex++) {
            carry = uint32(uint8(input[inputByteIndex]));
            
            outputIdx = capacity - 1;
            
            for ( ; outputIdx > outputReverseEnd || carry != 0; outputIdx--) {
                carry += (uint32(uint8(output[outputIdx])) << 8); // XX << 8 same as: 256 * XX
                output[outputIdx] = bytes1(uint8(carry % 58));
                carry /= 58;
              }
            outputReverseEnd = outputIdx;
        }
        
        bytes memory encodeTable = ALPHABET;
        
        bytes memory retStrBytes = new bytes(prefixZeroes+(capacity-1-outputReverseEnd));
        for (uint i = 0; i < prefixZeroes; i++) {
          retStrBytes[i] = bytes1(encodeTable[0]);
        }
       
        for ( (uint i, uint j) = (0, outputReverseEnd+1); j < output.length; j++) {
            uint n = uint256(uint8(output[j]));
            retStrBytes[prefixZeroes + i] = bytes1(encodeTable[n]);
            
            i++;
        }
        
        return string(retStrBytes);
    }
}
