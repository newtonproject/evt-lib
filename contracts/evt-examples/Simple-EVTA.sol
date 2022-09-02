// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "../evt-base/EVTA.sol";

contract MyEVTA is EVTA {
    constructor() EVTA("SimpleEVTA", "EVTA") {}

    function safeMint(address to, uint256 quantity) public {
        _safeMint(to, quantity);
    }
}
