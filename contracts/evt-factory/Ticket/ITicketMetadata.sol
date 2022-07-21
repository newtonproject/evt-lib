// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "./lib/TicketMetadata.sol";

interface ITicketMetadata {
    /**
     * @dev Returns the ticket price.
     */
    function price() external view returns (uint256);

    /**
     * @dev Returns the ticket currency type.
     */
    function currency() external view returns (string memory);

    /**
     * @dev Returns the ticket issuer.
     */
    function issuer() external view returns (string memory);

    /**
     * @dev Returns the ticket check status.
     */
    function checked(uint256 tokenId) external view returns (bool);

    /**
     * @dev Returns the ticket validity startTime.
     */
    function startTime(uint256 tokenId) external view returns (uint256);

    /**
     * @dev Returns the ticket validity endTime.
     */
    function endTime(uint256 tokenId) external view returns (uint256);

}
