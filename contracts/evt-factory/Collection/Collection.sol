// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../evt-base/EVT.sol";
import "./ICollection.sol";

contract Collection is ICollection, EVT, ERC721Enumerable, Pausable {
    using Counters for Counters.Counter;

    Counters.Counter private _collectionIdCounter;

    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory baseURI_
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, baseURI_) {}

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

    function safeMint(address to, uint256 amount) public override onlyOwner {
        for (uint256 i = 0; i < amount; ++i) {
            uint256 collectionId = _collectionIdCounter.current();
            _collectionIdCounter.increment();
            _safeMint(to, collectionId);

            emit CreateCollection(collectionId);
        }
    }

    function updateBaseURI(string memory baseURI_) public override onlyOwner {
        setBaseURI(baseURI_);

        emit BaseURIUpdate(baseURI_);
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
    function tokenURI(uint256 collectionId)
        public
        view
        virtual
        override(ERC721, EVT)
        returns (string memory)
    {
        return super.tokenURI(collectionId);
    }

    function isOwnCollection(uint256 collectionId, address addr)
        public
        view
        override
        returns (bool)
    {
        return ownerOf(collectionId) == addr;
    }
}