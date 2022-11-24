// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../evt-base/EVT.sol";
import "./ITicket.sol";
import "../movie/IMovie.sol";

contract Ticket is ITicket, EVT, ERC721Enumerable, Pausable {
    using Counters for Counters.Counter;

    Counters.Counter private _ticketIdCounter;

    address private payee;
    address public movieAddr;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public ticketDuration;

    // TicketId => TicketInfo
    mapping(uint256 => TicketInfo) private ticketInfoMap;

    struct TicketInfo {
        uint256 tokenId;
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
        uint256 endTime_,
        uint256 ticketDuration_
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, baseURI_) {
        movieAddr = movieAddr_;
        endTime = endTime_;
        ticketDuration = ticketDuration_;
        startTime = startTime_;
        payee = owner();
    }

    modifier onlyMovieOwner(uint256 tokenId) {
        require(
            IMovie(movieAddr).isOwn(
                tokenId,
                msg.sender
            ),
            "not movie owner"
        );
        _;
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
     * - When `from` is zero, the tokens will be minted for `to`.
     * - When `to` is zero, ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Update `baseURI`.
     */
    function updateBaseURI(string memory baseURI_) public override onlyOwner {
        setBaseURI(baseURI_);

        emit BaseURIUpdate(baseURI_);
    }

    /**
     * @dev Update `startTime`.
     */
    function updateStartTime(uint256 startTime_) public override onlyOwner {
        startTime = startTime_;

        emit StartTimeUpdate(startTime_);
    }

    /**
     * @dev Update `endTime`.
     */
    function updateEndTime(uint256 endTime_) public override onlyOwner {
        endTime = endTime_;

        emit EndTimeUpdate(endTime_);
    }

    /**
     * @dev Update `checkDuration`.
     */
    function updateTicketDuration(uint256 ticketDuration_)
        public
        override
        onlyOwner
    {
        ticketDuration = ticketDuration_;

        emit TicketDurationUpdate(ticketDuration_);
    }

    /**
     * @dev Update `payee`.
     */
    function updatePayee(address payee_) public override onlyOwner {
        require(payee_ != address(0), "Invalid address");
        payee = payee_;

        emit PayeeUpdate(payee_);
    }

    /**
     * @dev Returns `payee`.
     */
    function getPayee() public view onlyOwner returns (address) {
        return payee;
    }

    /**
     * @dev Withdraw the balance to the payee.
     *
     * Requirements:
     *
     * - owner or payee
     */
    function withdraw() public {
        require(msg.sender == payee || msg.sender == owner(), "no access");
        Address.sendValue(payable(payee), address(this).balance);
    }

    /**
     * @dev Batch mint ticket EVT by `tokenId`.
     */
    function safeMint(
        address to,
        uint256 amount,
        uint256 tokenId
    ) public payable override onlyMovieOwner(tokenId) {
        for (uint256 i = 0; i < amount; ++i) {
            uint256 ticketId = _ticketIdCounter.current();
            _ticketIdCounter.increment();
            _safeMint(to, ticketId);
            ticketInfoMap[ticketId].tokenId = tokenId;

            emit EventCreateTicket(ticketId);
        }
    }

    /**
     * @dev Have tickets checked and write the check-in time.
     *
     * Requirements:
     *
     * - `ticketId` must exist
     * - must own `ticketId` EVT
     * - timestamp greater than `startTime`
     * - timestamp less than `endTime`
     * - ticket has not expired
     */
    function checkTicket(uint256 ticketId) public override whenNotPaused {
        require(msg.sender == ownerOf(ticketId), "not ticket owner");
        require(block.timestamp > startTime, "not on the screen");
        require(block.timestamp < endTime, "already off the screen");
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

    /**
     * @dev See {IERC165-supportsInterface}.
     */
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

    /**
     * @dev Returns `movieAddr`, `startTime`, `endTime`, `ticketDuration`, `baseURI`.
     */
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
        return (movieAddr, startTime, endTime, ticketDuration, baseURI);
    }

    /**
     * @dev Returns `movieAddr`, `startTime`, `endTime`, `ticketDuration`, `baseURI`, `checkingTime`.
     */
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
            endTime,
            ticketDuration,
            baseURI,
            ticketInfoMap[ticketId].checkingTime
        );
    }
}
