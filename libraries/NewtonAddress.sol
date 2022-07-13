// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './base58.sol';

/// @title NewtonAddress
/// @author Newton Project
/// @notice Provides a function for convert newton address
library NewtonAddress {
    function hex2New(address hexAddress) internal view returns (string memory) {
        uint256 id;
        assembly {
            id := chainid()
        }
        
        bytes memory data = abi.encodePacked(bytes1(0), uint16(id), hexAddress);
        bytes32 hash = sha256(data);
        hash = sha256(abi.encodePacked(hash));
        
        string memory data58 = Base58.encode(abi.encodePacked(bytes1(0), uint16(id), hexAddress, bytes4(hash))); 
        
        return string(abi.encodePacked("NEW", data58));
    }
}
