// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../evt-base/EVT.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @dev This implements an simple EVT example.
 * You need to pass some parameters to the constructor.
 * Empty array is Ok for properties and encryptedKeyIDs because they can be changed in
 * functions of addDynamicProperty and registerEncryptedKeyID.
 */
contract MyEVT is EVT {
    using Counters for Counters.Counter;

    // TokenId auto increment
    Counters.Counter private _tokenIdCounter;

    // Logo of the EVT
    string private _logo;

    // Tax of the EVT
    uint256 public _tax;

    /**
     * @dev Constructor function.
     * You need to pass some parameters to the constructor.
     * Empty array is Ok for properties and encryptedKeyIDs because they can be changed in
     * functions of addDynamicProperty and registerEncryptedKeyID.
     */
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

    /**
     * @dev Return the logo of the EVT.
     */
    function logo() public view returns (string memory) {
        return _logo;
    }

    /**
     * @dev Set the tax of the EVT.
     */
    function setTax(uint256 _newTax) public onlyOwner returns (uint256) {
        _tax = _newTax;
        return _tax;
    }

    /**
     * @dev Unsafely mints token and transfers it to `to`.
     */
    function mint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);
        addEncryptedKeyID(tokenId);
    }

    /**
     * @dev Safely mints token and transfers it to `to`.
     */
    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        addEncryptedKeyID(tokenId);
    }

    /**
     * @dev Same as `_safeMint`, with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
        addEncryptedKeyID(tokenId);
    }

    /**
     * @dev You can use this function to get some encryptedKeyIDs for testing.
     */
    function getEncryptedKeyID(string memory propertyName)
        public
        view
        virtual
        returns (bytes32 encryptedKeyID)
    {
        return keccak256(abi.encode(propertyName));
    }
}
