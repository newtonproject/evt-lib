// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../evt-base/EVT.sol";
import "./ISecureTicket.sol";
import "../Movie/ISecureMovie.sol";

contract SecurTicket is ISecureTicket, EVT, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _ticketIdCounter;
    address private payee;
    // TicketId => TicketInfo
    mapping(uint256 => TicketInfo) private ticketInfoMap;

    ISecureMovie public movieContract;
    uint256 public movieDuration;
    uint256 public ticketDuration;
    uint256 public startTime;
    string public uri;

    struct TicketInfo {
        uint256 movieId;
        uint256 checkingTime;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory uri_,
        address movieAddr,
        uint256 startTime_,
        uint256 movieDuration_,
        uint256 ticketDuration_
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, uri_) {
        movieContract = ISecureMovie(movieAddr);
        uri = uri_;
        movieDuration = movieDuration_;
        ticketDuration = ticketDuration_;
        startTime = startTime_;
        payee = owner();
    }

    modifier onlyMovieOwner(uint256 movieId) {
        require(
            movieContract.isOwnerMovie(movieId, msg.sender),
            "not movie owner"
        );
        _;
    }

    //internal
    //internal
    //internal
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    //onlyOwner
    //onlyOwner
    //onlyOwner
    function updateDefaultURI(string memory _uri) public override onlyOwner {
        uri = _uri;

        emit DefaultURIUpdate(_uri);
    }

    function updateMovieDuration(uint256 _movieDuration)
        public
        override
        onlyOwner
    {
        movieDuration = _movieDuration;

        emit MovieDurationUpdate(_movieDuration);
    }

    function updateTicketDuration(uint256 _ticketDuration)
        public
        override
        onlyOwner
    {
        ticketDuration = _ticketDuration;

        emit TicketDurationUpdate(_ticketDuration);
    }

    function updatePayee(address _payee) public override onlyOwner {
        require(_payee != address(0), "Invalid address");
        payee = _payee;

        emit PayeeUpdate(_payee);
    }

    //onlyMovieOwner
    //onlyMovieOwner
    //onlyMovieOwner
    function safeMint(
        address to,
        uint256 amount,
        uint256 movieId
    ) public payable override onlyMovieOwner(movieId) {
        for (uint256 i = 0; i < amount; ++i) {
            uint256 ticketId = _ticketIdCounter.current();
            _ticketIdCounter.increment();
            _safeMint(to, ticketId);
            ticketInfoMap[ticketId].movieId = movieId;

            emit EventCreateTicket(ticketId);
        }
    }

    //onlyTicketOwner
    //onlyTicketOwner
    //onlyTicketOwner
    function checkTicket(uint256 ticketId) public override returns (bool) {
        require(msg.sender == ownerOf(ticketId), "not ticket owner");
        require(startTime < block.timestamp, "time is not up yet");
        require(startTime + ticketDuration > block.timestamp, "timeout");
        uint256 checkingTime_ = ticketInfoMap[ticketId].checkingTime;
        if (checkingTime_ == 0) {
            ticketInfoMap[ticketId].checkingTime = block.timestamp;

            emit EventTicketCheck(ticketId, block.timestamp);
            return true;
        } else {
            return checkingTime_ + ticketDuration < block.timestamp;
        }
    }

    //public
    //public
    //public
    function withdraw() public {
        Address.sendValue(payable(payee), address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, EVT, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IEVTMetadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, EVT)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}