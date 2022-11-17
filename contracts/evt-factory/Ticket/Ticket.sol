// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../evt-base/EVT.sol";
import "./ITicket.sol";
import "../Movie/IMovie.sol";

contract Ticket is ITicket, EVT, ERC721Enumerable, Pausable {
    using Counters for Counters.Counter;

    Counters.Counter private _ticketIdCounter;

    address private payee;
    address public movieAddr;
    uint256 public startTime;
    uint256 public movieDuration;
    uint256 public ticketDuration;

    // TicketId => TicketInfo
    mapping(uint256 => TicketInfo) private ticketInfoMap;

    struct TicketInfo {
        uint256 movieId;
        uint256 checkingTime;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory baseURI_,
        address movieAddr_,
        uint256 startTime_,
        uint256 movieDuration_,
        uint256 ticketDuration_
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, baseURI_) {
        movieAddr = movieAddr_;
        movieDuration = movieDuration_;
        ticketDuration = ticketDuration_;
        startTime = startTime_;
        payee = owner();
    }

    modifier onlyMovieOwner(uint256 movieId) {
        require(
            IMovie(movieAddr).isOwnMovie(movieId, msg.sender),
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
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    //onlyOwner
    //onlyOwner
    //onlyOwner
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function updateBaseURI(string memory baseURI_) public override onlyOwner {
        setBaseURI(baseURI_);

        emit BaseURIUpdate(baseURI_);
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

    function getPayee() public view onlyOwner returns (address) {
        return payee;
    }

    //payee or owner
    function withdraw() public {
        require(msg.sender == payee || msg.sender == owner(), "no access");
        Address.sendValue(payable(payee), address(this).balance);
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
    function checkTicket(uint256 ticketId) public override whenNotPaused {
        require(msg.sender == ownerOf(ticketId), "not ticket owner");
        require(block.timestamp > startTime, "time is not up yet");
        require(block.timestamp < startTime + ticketDuration, "timeout");
        uint256 checkingTime_ = ticketInfoMap[ticketId].checkingTime;
        if (checkingTime_ == 0) {
            ticketInfoMap[ticketId].checkingTime = block.timestamp;

            emit EventTicketCheck(ticketId, block.timestamp);
        } else {
            require(
                block.timestamp < checkingTime_ + ticketDuration,
                "Expired ticket"
            );
        }
    }

    //public
    //public
    //public
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
    function tokenURI(uint256 ticketId)
        public
        view
        virtual
        override(ERC721, EVT)
        returns (string memory)
    {
        return super.tokenURI(ticketId);
    }

    function commonInfo()
        public
        view
        override
        returns (
            address,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return (movieAddr, startTime, movieDuration, ticketDuration, baseURI);
    }

    function ticketInfo(uint256 ticketId)
        external
        view
        override
        returns (
            address,
            uint256,
            uint256,
            uint256,
            string memory,
            uint256
        )
    {
        require(ERC721._exists(ticketId), "not exist");
        return (
            movieAddr,
            startTime,
            movieDuration,
            ticketDuration,
            baseURI,
            ticketInfoMap[ticketId].checkingTime
        );
    }
}
