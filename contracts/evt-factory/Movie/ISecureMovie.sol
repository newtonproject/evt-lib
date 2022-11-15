// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../evt-base/IEVT.sol";

interface ISecureMovie is IEVT {
    event MovieCopyCreate(uint256 indexed movieId);
    // event TicketBind(uint256 indexed movieId, address indexed tickets);
    event DefaultURIUpdate(string uri);

    function safeMint(address to, uint256 amount) external;

    function updateDefaultURI(string memory uri) external;

    // function getMovieTicketContracts(uint256 movieId) external view returns(address[] memory ticketsSet);
    // function tickets2movie(address tickets) external view returns(uint256 movieId);
    // function registerTicketContract(uint256 movieId, address tickets) external;

    function isOwnerMovie(uint256 movieId, address addr)
        external
        view
        returns (bool);
}
