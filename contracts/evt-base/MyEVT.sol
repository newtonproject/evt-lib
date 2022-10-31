// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "./EVT.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

contract MyEVT is EVT {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor(string memory name_, string memory symbol_, string[] memory properties) EVT("MyEVT", "EVT", properties) {}

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
    
}

