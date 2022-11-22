// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface ITicket is IEVT {
    /**
     * @dev Update `baseURI`.
     */
    function updateBaseURI(string memory baseURI) external;

    /**
     * @dev Update `startTime`.
     */
    function updateStartTime(uint256 startTime) external;

    /**
     * @dev Update `endTime`.
     */
    function updateEndTime(uint256 endTime) external;

    /**
     * @dev Update `checkDuration`.
     */
    function updateTicketDuration(uint256 checkDuration) external;

    /**
     * @dev Update `payee`.
     */
    function updatePayee(address payee) external;

    /**
     * @dev Batch mint ticket EVT by `multimediaId`.
     */
    function safeMint(
        address to,
        uint256 amount,
        uint256 multimediaId
    ) external payable;

    /**
     * @dev Have tickets checked and write the check-in time.
     *
     * Requirements:
     *
     * - `ticketId` must exist
     * - must own `ticketId` EVT
     * - timestamp greater than `startTime`
     * - timestamp less than `endTime`
     * - ticket has not expired
     */
    function checkTicket(uint256 tokenId) external;

    /**
     * @dev Returns `multimediaAddr`, `startTime`, `endTime`, `ticketDuration`, `baseURI`.
     */
    function commonInfo()
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            string memory
        );

    /**
     * @dev Returns `multimediaAddr`, `startTime`, `endTime`, `ticketDuration`, `baseURI`, `checkingTime`.
     */
    function ticketInfo(uint256 tokenId)
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            string memory,
            uint256
        );

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
     * @dev Emitted when `ticketDuration` is updated.
     */
    event TicketDurationUpdate(uint256 ticketDuration);

    /**
     * @dev Emitted when `payee` is updated.
     */
    event PayeeUpdate(address payee);

    /**
     * @dev Emitted when `ticketId` EVT is created.
     */
    event EventCreateTicket(uint256 indexed ticketId);

    /**
     * @dev Emitted when `ticketId` have checked for the first time.
     */
    event EventTicketCheck(uint256 indexed ticketId, uint256 checkingTime);
}
