// // SPDX-License-Identifier: GPL-3.0
// pragma solidity ^0.8.3;

// import "../../evt-base/IEVT.sol";

// interface ISecureTicket is IEVT {
//     event TicketCreate(uint256 indexed tokenId, uint256 checkStartTime, uint256 checkEndTime);
//     event TicketCheck(uint256 indexed tokenId, uint256 startTime, uint256 endTime);

//     event DurationUpdate(uint duration);
//     event CheckDurationUpdate(uint256 checkDuration);
//     event DefaultURIUpdate(string uri);
//     event PayeeUpdate(address payee);

//     // function commonInfo() external view returns(
//     //     address movie, uint256 movieId, uint256 duration, uint256 checkDuration, string memory defaultUri
//     // );

//     // function ticketInfo(uint256 ticketId)  external view returns(
//     //     uint256 inspectStartTime, uint256 inspectEndTime, bool inspected, uint256 startTime, uint256 endTime
//     // );

//     // function isValidTicket(uint256 tokenId) external view returns (bool);

//     // function isValidWatcher(address watcher) external view returns (bool);

//     // function safeMint(address to, uint256 amount) external payable;

//     // function checkTicket(uint256 tokenId) external;

//     // function updateDefaultURI(string memory style) external;

//     // function updatePayee(address payee) external;

//     // function updateDuration(uint256 duration) external;

//     // function updateCheckDuration(uint256 checkDuration) external;
// }
