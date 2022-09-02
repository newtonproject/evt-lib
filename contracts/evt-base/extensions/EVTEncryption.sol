// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/IEVTEncryption.sol";

abstract contract EVTEncryption is ERC165, IEVTEncryption {

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // mapping from tokenId to list of encryptionKeyID => addressSet
    mapping(uint256 => mapping(bytes32 => EnumerableSet.AddressSet)) private _permissions;

    mapping(uint256 => EnumerableSet.Bytes32Set) private _tokenKeyIds;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTEncryption).interfaceId || super.supportsInterface(interfaceId);
    }
   
    function registerEncryptedKey(uint256 tokenId, bytes32 encryptedKeyID) public payable virtual override {
        EnumerableSet.Bytes32Set storage _keyIds = _tokenKeyIds[tokenId];
        require(!_keyIds.contains(encryptedKeyID), "encryptedKeyID exist");
        _keyIds.add(encryptedKeyID);

        emit EncryptedKeyRegistered(tokenId, encryptedKeyID);
    }
	
    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public payable virtual override {
        require(_tokenKeyIds[tokenId].contains(encryptedKeyID), "EVTEncrytion: invalid encryptedKeyID");
        EnumerableSet.AddressSet storage _authorize = _permissions[tokenId][encryptedKeyID];
        _authorize.add(licensee);

        emit PermissionAdded(tokenId, encryptedKeyID, licensee);
    }
	
    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public virtual override {
        EnumerableSet.AddressSet storage _authorize = _permissions[tokenId][encryptedKeyID];
        _authorize.remove(licensee);

        emit PermissionRemoved(tokenId, encryptedKeyID, licensee);
    }

    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public view virtual override returns (bool) {
        EnumerableSet.AddressSet storage _authorize = _permissions[tokenId][encryptedKeyID];
        return _authorize.contains(licensee);
    }
}