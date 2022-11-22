// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../../evt-base/EVT.sol";
import "./IMultimedia.sol";

contract Multimedia is
    IMultimedia,
    EVT,
    ERC721Enumerable,
    ERC721URIStorage,
    Pausable,
    ERC721Burnable
{
    using Counters for Counters.Counter;

    Counters.Counter private _multimediaIdCounter;

    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory baseURI_
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, baseURI_) {}

    /**
     * @dev Burns `tokenId`. See {ERC721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
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
     * @dev Batch mint multimedias.
     */
    function safeMint(address to, uint256 amount) public onlyOwner {
        for (uint256 i = 0; i < amount; ++i) {
            uint256 multimediaId = _multimediaIdCounter.current();
            _multimediaIdCounter.increment();
            _safeMint(to, multimediaId);

            emit CreateMultimedia(multimediaId);
        }
    }

    /**
     * @dev Batch mint multimedias and set tokenURI.
     */
    function safeMint(address to, string[] memory uris) public onlyOwner {
        for (uint256 i = 0; i < uris.length; ++i) {
            uint256 multimediaId = _multimediaIdCounter.current();
            _multimediaIdCounter.increment();
            _safeMint(to, multimediaId);
            _setTokenURI(multimediaId, uris[i]);

            emit CreateMultimedia(multimediaId);
        }
    }

    /**
     * @dev Update Token URIStorage.See {IERC721Metadata-tokenURI}.
     */
    function updateTokenURIStorage(uint256 tokenId, string memory uri)
        public
        override
        onlyOwner
    {
        _setTokenURI(tokenId, uri);
    }

    /**
     * @dev Update `baseURI`.
     */
    function updateBaseURI(string memory baseURI_) public override onlyOwner {
        setBaseURI(baseURI_);

        emit BaseURIUpdate(baseURI_);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable, EVT, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IEVTMetadata-tokenURI}.
     */
    function tokenURI(uint256 multimediaId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage, EVT)
        returns (string memory)
    {
        return super.tokenURI(multimediaId);
    }


    /**
     * @dev Returns token URIStorage.See {IERC721Metadata-tokenURI}.
     */
    function tokenURIStorage(uint256 multimediaId)
        public
        view
        returns (string memory)
    {
        return ERC721URIStorage.tokenURI(multimediaId);
    }


    /**
     * @dev Returns whether `addr` own `multimediaId`.
     */
    function isOwnMultimedia(uint256 multimediaId, address addr)
        public
        view
        override
        returns (bool)
    {
        return ownerOf(multimediaId) == addr;
    }
}
