// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface IMultimedia is IEVT {
    function updateBaseURI(string memory baseURI) external;

    function updateTokenURIStorage(uint256 tokenId, string memory uri) external;

    function isOwnMultimedia(uint256 multimediaId, address addr)
        external
        view
        returns (bool);

    event CreateMultimedia(uint256 indexed multimediaId);
    event BaseURIUpdate(string baseURI);
}
