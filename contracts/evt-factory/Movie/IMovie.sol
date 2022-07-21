// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "../../evt-base/IEVT.sol";

interface IMovie is IEVT {

    event IssueTicket(uint256 indexed tokenId, address indexed ticket);

    function getTickets(uint256 movieId) external view returns(address[] memory ticketsSet);
    function findMovieByTicket(address ticket) external view returns(uint256 movieId);

    function safaMint(address to, string memory uri) external returns(uint256 movieId);
    function issueTicket(uint256 movieId, address ticket) external returns(address);
}
