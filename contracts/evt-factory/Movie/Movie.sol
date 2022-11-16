// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../evt-base/EVT.sol";
import "./IMovie.sol";

contract Movie is IMovie, EVT, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _movieIdCounter;

    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory _uri
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, _uri) {
        
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
    function safeMint(address to, uint256 amount) public override onlyOwner {
        for (uint256 i = 0; i < amount; ++i) {
            uint256 movieId = _movieIdCounter.current();
            _movieIdCounter.increment();
            _safeMint(to, movieId);

            emit MovieCopyCreate(movieId);
        }
    }

    function updateBaseURI(string memory _uri) public override onlyOwner {
        setBaseURI(_uri);

        emit BaseURIUpdate(_uri);
    }

    // function withdraw() public onlyOwner {
    //     Address.sendValue(payable(owner()), address(this).balance);
    // }

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
    function tokenURI(uint256 movieId)
        public
        view
        virtual
        override(ERC721, EVT)
        returns (string memory)
    {
        return super.tokenURI(movieId);
    }

    function isOwnerMovie(uint256 movieId, address addr)
        public
        view
        override
        returns (bool)
    {
        return ownerOf(movieId) == addr;
    }
}
