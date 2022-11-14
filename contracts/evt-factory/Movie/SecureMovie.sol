// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../../evt-base/EVT.sol";
import "./ISecureMovie.sol";

contract SecureMovie is ISecureMovie, EVT {
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.AddressSet;

    Counters.Counter private _movieIdCounter;

    // movieId ==> owner
    mapping(uint256 => address) private _movieIdToAddr;

    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory _uri
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, _uri) {}

    //internal
    //internal
    //internal
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 movieId,
        uint256 batchSize
    ) internal override {
        super._beforeTokenTransfer(from, to, movieId, batchSize);

        //Maintain _movieIdToAddr
        _movieIdToAddr[movieId] = to;
    }

    //onlyOwner
    //onlyOwner
    //onlyOwner
    function safeMint(address to, uint256 amount) public onlyOwner {
        for (uint256 i = 0; i < amount; ++i) {
            uint256 movieId = _movieIdCounter.current();
            _movieIdCounter.increment();
            _safeMint(to, movieId);

            emit MovieCopyCreate(movieId);
        }
    }

    function updateDefaultURI(string memory _uri) public onlyOwner {
        setBaseURI(_uri);
        emit DefaultURIUpdate(_uri);
    }

    function withdraw() public onlyOwner {
        Address.sendValue(payable(owner()), address(this).balance);
    }

    //public
    //public
    //public
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, EVT)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function isOwnerMovie(uint256 movieId, address addr)
        public
        view
        override
        returns (bool)
    {
        return _movieIdToAddr[movieId] == addr;
    }
}
