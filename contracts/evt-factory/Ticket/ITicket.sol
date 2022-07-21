// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "../../evt-base/IEVT.sol";


interface ITicket is IEVT, IERC721Enumerable {
    event BuyTicket(uint256 indexed tokenId, uint256 checkStartTime, uint256 checkEndTime);
    event CheckTicket(uint256 indexed tokenId, uint256 startTime, uint256 endTime);

    function getInfo() external view returns(
        uint256 price,
        string memory currency,
        string memory issuer,
        string memory logo,
        uint256 duration,
        uint256 checkDuration
    );

    function getStatus(uint256 ticketId)  external view returns(
        uint256 checkStartTime, 
        uint256 checkEndTime, 
        bool checked, 
        uint256 startTime, 
        uint256 endTime
    );

    function isValid(uint256 tokenId) external view returns (bool);

    function buy(address to, uint256 amount) external payable;

    function checkin(uint256 tokenId) external;

}
