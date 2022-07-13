// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

library TicketMetadata {

    struct Ticket {
        uint256 startTime;
        uint256 endTime;
        uint256 checkStartTime;
        uint256 checkEndTime;
        bool checked;
    }
}
