// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../evt-base/EVT.sol";

contract EVTEncryptionDemo is EVT {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address public tokenContract;

    constructor(address _tokenContract) EVT("EncryptionEVT", "EEVT") {
        tokenContract = _tokenContract;
    }

    function mint(address to) public payable {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function getEncryptionKeyId(bytes memory EncryptionKey) public pure returns (bytes32){
        return bytes32(keccak256(EncryptionKey));
    }

    function getTokenCount(address owner) public returns (uint256) {
        bytes memory tokenCount = Address.functionCall(tokenContract, abi.encodeWithSelector(bytes4(keccak256("balanceOf(address)")), owner));
        return abi.decode(tokenCount, (uint256));
    }

    function registerEncryptedKey(uint256 tokenId, bytes32 encryptedKeyID) public payable override {
        require(getTokenCount(msg.sender) > 0, "no register permission");
        require(msg.sender == ERC721.ownerOf(tokenId), "not token owner");
        EVTEncryption.registerEncryptedKey(tokenId, encryptedKeyID);
    }

    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public payable override {
        require(msg.sender == ERC721.ownerOf(tokenId), "not token owner");
        EVTEncryption.addPermission(tokenId, encryptedKeyID, licensee);
    }

    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public override {
        require(msg.sender == ERC721.ownerOf(tokenId), "not token owner");
        EVTEncryption.removePermission(tokenId, encryptedKeyID, licensee);
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
