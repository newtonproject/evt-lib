// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface IMovie is IEVT {
    function safeMint(address to, uint256 amount) external;

    function updateBaseURI(string memory baseURI) external;

    function isOwnMovie(uint256 movieId, address addr)
        external
        view
        returns (bool);

    event MovieCopyCreate(uint256 indexed movieId);
    event BaseURIUpdate(string baseURI);
}
