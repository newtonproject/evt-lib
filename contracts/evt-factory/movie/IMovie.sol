// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/interfaces/IEVT.sol";

interface IMovie is IEVT {
    /**
     * @dev Emitted when `tokenId` EVT is created.
     */
    event CreateMovie(uint256 indexed tokenId);

    /**
     * @dev Emitted when `baseURI` is updated.
     */
    event BaseURIUpdate(string baseURI);

    /**
     * @dev Update `baseURI`.
     */
    function updateBaseURI(string memory baseURI) external;

    /**
     * @dev Returns token URIStorage.See {IERC721Metadata-tokenURI}.
     */
    function updateTokenURIStorage(uint256 tokenId, string memory uri) external;

    /**
     * @dev Returns whether `addr` own `tokenId`.
     */
    function isOwn(uint256 tokenId, address addr)
        external
        view
        returns (bool);
}
