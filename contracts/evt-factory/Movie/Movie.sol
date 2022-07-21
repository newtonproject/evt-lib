// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../../evt-base/IEVT.sol";
import "../../evt-base/EVT.sol";
import "./IMovie.sol";

contract Movie is IMovie, EVT, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.AddressSet;

    Counters.Counter private _tokenIdCounter;

    // movieId ==> ticket list
    mapping(uint256 => EnumerableSet.AddressSet) private _movie2TicketsSet;
    // tickets ==> movieId
    mapping(address => uint256) public override findMovieByTicket;

    constructor() EVT("Movie", "MOVIE") {
    }

    function safaMint(address to, string memory uri) public override returns(uint256 movieId) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        return tokenId;
    }

    function updateTokenURI(uint256 tokenId, string memory uri) public {
        require(msg.sender == ownerOf(tokenId), "Caller is not owner");
        _setTokenURI(tokenId, uri);
    }

    function issueTicket(uint256 tokenId, address ticket) public override returns(address) {
        require(msg.sender == ownerOf(tokenId), "Caller is not owner");

        findMovieByTicket[ticket] = tokenId;
        EnumerableSet.AddressSet storage set = _movie2TicketsSet[tokenId];
        set.add(ticket);        

        emit IssueTicket(tokenId, ticket);

        return ticket;
    }

    function getTickets(uint256 movieId) public view override returns(address[] memory ticketsSet) {
        return _movie2TicketsSet[movieId].values();
    }

    function withdraw() public {
        Address.sendValue(payable(owner()), address(this).balance);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721, EVT)
        returns (bool)
    {
        return
            super.supportsInterface(interfaceId);
    }
}
