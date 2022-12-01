// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/interfaces/IEVT.sol";

interface IMusic is IEVT {
    /**
     * @dev Emitted when `tokenId` EVT is created.
     */
    event CreateMusic(uint256 indexed tokenId);

    /**
     * @dev Emitted when `baseURI` is updated.
     */
    event BaseURIUpdate(string baseURI);

    /**
     * @dev Emitted when `startTime` is updated.
     */
    event StartTimeUpdate(uint256 startTime);

    /**
     * @dev Emitted when `endTime` is updated.
     */
    event EndTimeUpdate(uint256 endTime);

    /**
     * @dev Update `baseURI`.
     */
    function updateBaseURI(string memory baseURI) external;

    /**
     * @dev Returns token URIStorage.See {IERC721Metadata-tokenURI}.
     */
    function updateTokenURIStorage(uint256 tokenId, string memory uri) external;

    /**
     * @dev Update `startTime`.
     */
    function updateStartTime(uint256 startTime) external;

    /**
     * @dev Update `endTime`.
     */
    function updateEndTime(uint256 endTime) external;

    /**
     * @dev Returns `startTime`.
     */
    function startTime() external view returns (uint256);

    /**
     * @dev Returns `endTime`.
     */
    function endTime() external view returns (uint256);

    /**
     * @dev Returns whether `addr` own `tokenId`.
     */
    function isOwn(uint256 tokenId, address addr) external view returns (bool);
}
