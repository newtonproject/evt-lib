// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IEVTEncryption.sol";

abstract contract EVTEncryption is ERC165, IEVTEncryption {

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // Mapping from tokenId to list of encryptionKeyID => addressSet
    mapping(uint256 => mapping(bytes32 => EnumerableSet.AddressSet)) internal _permissions;

    // Mapping from tokenId to list of encryptionKeyIDs
    mapping(uint256 => EnumerableSet.Bytes32Set) internal _tokenKeyIDs;

    // All encryptionKeyIDs in this contract
    EnumerableSet.Bytes32Set internal _encryptedKeyIDs;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTEncryption).interfaceId || super.supportsInterface(interfaceId);
    }
    
    /**
     * @dev See {IEVTEncryption-registerEncryptedKey}.
     */
    function registerEncryptedKey(bytes32 encryptedKeyID) public payable virtual override {
        require(!_encryptedKeyIDs.contains(encryptedKeyID), "encryptedKeyID exist");
        _encryptedKeyIDs.add(encryptedKeyID);

        emit EncryptedKeyRegistered(encryptedKeyID);
    }
	
    /**
     * @dev See {IEVTEncryption-registerEncryptedKey}.
     */
    function addPermission(
        uint256 tokenId, 
        bytes32 encryptedKeyID, 
        address licensee
    ) public payable virtual override {
        require(_encryptedKeyIDs.contains(encryptedKeyID), "invalid encryptedKeyID");
        require(!_permissions[tokenId][encryptedKeyID].contains(licensee), "licensee has been added");
        _permissions[tokenId][encryptedKeyID].add(licensee);
        _tokenKeyIDs[tokenId].add(encryptedKeyID);

        emit PermissionAdded(tokenId, encryptedKeyID, licensee);
    }
	
    /**
     * @dev See {IEVTEncryption-removePermission}.
     */
    function removePermission(
        uint256 tokenId, 
        bytes32 encryptedKeyID, 
        address licensee
    ) public virtual override {
        require(_encryptedKeyIDs.contains(encryptedKeyID), "invalid encryptedKeyID");
         _permissions[tokenId][encryptedKeyID].remove(licensee);
        _tokenKeyIDs[tokenId].remove(encryptedKeyID);

        emit PermissionRemoved(tokenId, encryptedKeyID, licensee);
    }

    /**
     * @dev See {IEVTEncryption-hasPermission}.
     */
    function hasPermission(
        uint256 tokenId, 
        bytes32 encryptedKeyID, 
        address licensee
    ) public view virtual override returns (bool) {
        require(_encryptedKeyIDs.contains(encryptedKeyID), "EVTEncrytion: invalid encryptedKeyID");
        return _permissions[tokenId][encryptedKeyID].contains(licensee);
    }

    /**
     * @dev See {IEVTEncryption-getPermissions}.
     */
    function getPermissions(
        uint256 tokenId, 
        bytes32 encryptedKeyID
    ) public view virtual override returns (address[] memory) {
        // require(hasPermission(tokenId, encryptedKeyID, msg.sender), "Have no permission");
        EnumerableSet.AddressSet storage _permission = _permissions[tokenId][encryptedKeyID];
        address[] memory licensee = new address[](_permission.length());
        for(uint256 i = 0; i < _permission.length(); ++i) {
            licensee[i] = _permission.at(i);
        }
        return licensee;
    }
}
