// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "./EVT.sol";
import "../libraries/toString.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyEVT is EVT {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _logo;
    
    uint256 public _tax;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory logo_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory _newBaseURI
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, _newBaseURI) {
        _logo = logo_;
    }

    function logo() public view returns (string memory) {
        return _logo;
    }

    function setTax(uint256 _newTax) public onlyOwner returns (uint256) {
        _tax = _newTax;
        return _tax;
    }

    function mint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);
        addEncryptionKeyID(tokenId);
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        addEncryptionKeyID(tokenId);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
        addEncryptionKeyID(tokenId);
    }
}
