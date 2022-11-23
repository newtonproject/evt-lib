// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/interfaces/IEVT.sol";

interface IMultimedia is IEVT {
    /**
    * @dev Update `baseURI`.
    */
    function updateBaseURI(string memory baseURI) external;

    /**
    * @dev Returns token URIStorage.See {IERC721Metadata-tokenURI}.
    */
    function updateTokenURIStorage(uint256 tokenId, string memory uri) external;

    /**
    * @dev Returns whether `addr` own `multimediaId`.
    */
    function isOwnMultimedia(uint256 multimediaId, address addr)
        external
        view
        returns (bool);

    /**
    * @dev Emitted when `multimediaId` EVT is created.
    */
    event CreateMultimedia(uint256 indexed multimediaId);

    /**
    * @dev Emitted when `baseURI` is updated.
    */
    event BaseURIUpdate(string baseURI);
}
