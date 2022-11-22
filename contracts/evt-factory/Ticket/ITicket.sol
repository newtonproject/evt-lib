// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface ITicket is IEVT {
    function updateBaseURI(string memory baseURI) external;

    function updateStartTime(uint256 startTime) external;

    function updateEndTime(uint256 endTime) external;

    function updateTicketDuration(uint256 checkDuration) external;

    function updatePayee(address payee) external;

    function safeMint(
        address to,
        uint256 amount,
        uint256 multimediaId
    ) external payable;

    function checkTicket(uint256 tokenId) external;

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

    event BaseURIUpdate(string baseURI);
    event StartTimeUpdate(uint256 startTime);
    event EndTimeUpdate(uint256 endTime);
    event TicketDurationUpdate(uint256 ticketDuration);
    event PayeeUpdate(address payee);
    event EventCreateTicket(uint256 indexed ticketId);
    event EventTicketCheck(uint256 indexed ticketId, uint256 checkingTime);
}
