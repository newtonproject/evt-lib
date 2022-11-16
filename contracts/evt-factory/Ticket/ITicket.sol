// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface ITicket is IEVT {
    event EventCreateTicket(uint256 indexed ticketId);
    event EventTicketCheck(uint256 indexed ticketId, uint256 startTime);

    event MovieDurationUpdate(uint256 movieDuration);
    event TicketDurationUpdate(uint256 ticketDuration);
    event BaseURIUpdate(string uri);
    event PayeeUpdate(address payee);

    // function commonInfo() external view returns(
    //     address movie, uint256 movieId, uint256 duration, uint256 checkDuration, string memory defaultUri
    // );

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

    // function isValidWatcher(address watcher) external view returns (bool);

    function safeMint(
        address to,
        uint256 amount,
        uint256 movieId
    ) external payable;

    function checkTicket(uint256 tokenId) external returns (bool);

    function updateBaseURI(string memory style) external;

    function updatePayee(address payee) external;

    function updateMovieDuration(uint256 duration) external;

    function updateTicketDuration(uint256 checkDuration) external;
}
