// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../../evt-base/IEVT.sol";
import "../../evt-base/EVT.sol";
import "./ITicketMetadata.sol";
import "./lib/TicketMetadata.sol";
import "./ITicket.sol";
import "../../libraries/base64.sol";

contract Ticket is ITicket, EVT, ITicketMetadata, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using TicketMetadata for TicketMetadata.Ticket;

    Counters.Counter private _tokenIdCounter;

    uint256 public _price;
    string public _currency;
    string public _issuer;
    string _logo;

    uint256 public duration;
    uint256 public checkDuration;
    address public payee;

    // tokenId => Ticket
    mapping (uint256 => TicketMetadata.Ticket) private _rights;

    constructor(
            uint256 price_, string memory currency_, string memory issuer_, string memory logo_,
            uint256 duration_, uint256 checkDuration_
        ) EVT("Tickets","TICKET") {
        _price = price_;
        _currency = currency_;
        _issuer = issuer_;
        _logo = logo_;
        duration = duration_;
        checkDuration = checkDuration_;
        payee = owner();
    }

    function getInfo() public view override returns (
        uint256 price_,
        string memory currency_,
        string memory issuer_,
        string memory logo_,
        uint256 duration_,
        uint256 checkDuration_
    ) {
        return (_price, _currency, _issuer, _logo, duration, checkDuration);
    }

    function isValid(uint256 tokenId) public view override returns (bool) {
        TicketMetadata.Ticket memory _right = _rights[tokenId];
        return (_right.startTime <= block.timestamp && block.timestamp <= _right.endTime);
    }

    function getStatus(uint256 tokenId) public view override returns (
        uint256 checkStartTime_, 
        uint256 checkEndTime_, 
        bool checked_, 
        uint256 startTime_, 
        uint256 endTime_
    ) {
        TicketMetadata.Ticket memory _right = _rights[tokenId];
        return (_right.checkStartTime, _right.checkEndTime, _right.checked, _right.startTime, _right.endTime);
    }

    function buy(address to, uint256 amount) public override payable {
        require(msg.value >= amount * _price, "Purchase price error");

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            _rights[tokenId].checkStartTime = block.timestamp;
            _rights[tokenId].checkEndTime = block.timestamp + checkDuration;
            
            emit BuyTicket(tokenId, _rights[tokenId].checkStartTime, _rights[tokenId].checkEndTime);
        }
    }

    function checked(uint256 tokenId) public view override returns (bool) {
        return _rights[tokenId].checked;
    }

    function startTime(uint256 tokenId) public view override returns (uint256) {
        return _rights[tokenId].startTime;
    }

    function endTime(uint256 tokenId) public view override returns (uint256) {
        return _rights[tokenId].endTime;
    }

    function logo() public view returns (string memory) {
        return _logo;
    }

    function price() public view override returns (uint256) {
        return _price;
    }

    function currency() public view override returns (string memory) {
        return _currency;
    }

    function issuer() public view override returns (string memory) {
        return _issuer;
    }

    function checkin(uint256 tokenId) public override {
        TicketMetadata.Ticket memory _right = _rights[tokenId];
        require(!_right.checked, "Has checked");
        require(_right.checkStartTime <= block.timestamp && block.timestamp <= _right.checkEndTime);

        _rights[tokenId].startTime = block.timestamp;
        _rights[tokenId].endTime = block.timestamp + duration;
        _rights[tokenId].checked = true;

        emit CheckTicket(tokenId, _rights[tokenId].startTime, _rights[tokenId].endTime);
    }

    function updatePrice(uint256 price_) external {
        require(msg.sender == owner(), "Caller is not owner");

        _price = price_;
    }

    function updatePayee(address payee_) external {
        require(msg.sender == owner(), "Caller is not owner");
        require(payee_ != address(0), "Invalid address");

        payee = payee_;
    }


    function withdraw() public {
        Address.sendValue(payable(payee), address(this).balance);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[17] memory args;
        args[0] = '{"Number": ';
        args[1] = Strings.toString(tokenId);
        args[2] = ', "logo": "';
        args[3] = string(abi.encodePacked(logo(), Strings.toString(tokenId)));
        args[4] = '", "issuer": "';
        args[5] = issuer();
        args[6] = '", "price": ';
        args[7] = Strings.toString(price());
        args[8] = ', "currency": "';
        args[9] = currency();
        args[10] = '", "checked": ';
        args[11] = checked(tokenId) ? 'true' : 'false';
        args[12] = ', "startTime": ';
        args[13] = Strings.toString(_rights[tokenId].startTime);
        args[14] = ', "endTime": ';
        args[15] = Strings.toString(_rights[tokenId].endTime);
        args[16] = ' }';

        string memory arg = string(abi.encodePacked(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]));
        arg = string(abi.encodePacked(arg, args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]));

        string memory json = Base64.encode(bytes(arg));
        
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721Enumerable, EVT)
        returns (bool)
    {
        return
            super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        return super._beforeTokenTransfer(from, to, tokenId);
    }
}
