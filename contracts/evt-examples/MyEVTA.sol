// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../evt-base/EVTA.sol";

contract MyEVTA is EVTA {
    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory _newBaseURI,
        uint256 maxBatchSize_,
        uint256 collectionSize_
    )
        EVTA(
            name_,
            symbol_,
            properties,
            encryptedKeyIDs,
            _newBaseURI,
            maxBatchSize_,
            collectionSize_
        )
    {}
}
