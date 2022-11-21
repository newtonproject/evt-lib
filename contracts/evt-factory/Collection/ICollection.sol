// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface ICollection is IEVT {
    function updateBaseURI(string memory baseURI) external;

    function updateTokenURIStorage(uint256 tokenId, string memory uri) external;

    function isOwnCollection(uint256 collectionId, address addr)
        external
        view
        returns (bool);

    event CreateCollection(uint256 indexed collectionId);
    event BaseURIUpdate(string baseURI);
}
