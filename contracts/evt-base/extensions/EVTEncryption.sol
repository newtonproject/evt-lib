// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/IEVTEncryption.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract EVTEncryption is ERC165, IEVTEncryption {

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // mapping from tokenId to list of encryptionKeyID => addressSet
    mapping(uint256 => mapping(bytes32 => EnumerableSet.AddressSet)) internal _permissions;

    mapping(uint256 => EnumerableSet.Bytes32Set) internal _tokenKeyIds;

    EnumerableSet.Bytes32Set internal _encryptionKeys;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTEncryption).interfaceId || super.supportsInterface(interfaceId);
    }
    
    function registerEncryptedKey(bytes32 encryptedKeyID) public payable virtual override {
        require(!_encryptionKeys.contains(encryptedKeyID), "encryptedKeyID exist");
        _encryptionKeys.add(encryptedKeyID);

        emit EncryptedKeyRegistered(encryptedKeyID);
    }
	
    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address license) public payable virtual override {
        require(_encryptionKeys.contains(encryptedKeyID), "EVTEncrytion: invalid encryptedKeyID");
        require(!_permissions[tokenId][encryptedKeyID].contains(license), "license have added");
        EnumerableSet.AddressSet storage _authorize = _permissions[tokenId][encryptedKeyID];
        _authorize.add(license);
        _tokenKeyIds[tokenId].add(encryptedKeyID);

        emit PermissionAdded(tokenId, encryptedKeyID, license);
    }
	
    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public virtual override {
        require(_encryptionKeys.contains(encryptedKeyID), "EVTEncrytion: invalid encryptedKeyID");
        EnumerableSet.AddressSet storage _authorize = _permissions[tokenId][encryptedKeyID];
        _authorize.remove(licensee);

        emit PermissionRemoved(tokenId, encryptedKeyID, licensee);
    }

    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) public view virtual override returns (bool) {
        require(_encryptionKeys.contains(encryptedKeyID), "EVTEncrytion: invalid encryptedKeyID");
        EnumerableSet.AddressSet storage _authorize = _permissions[tokenId][encryptedKeyID];
        return _authorize.contains(licensee);
    }

    // function getPermissions(uint256 tokenId) public view virtual returns (bytes32[] memory, address[][] memory) {
    //     uint256 len = _encryptionKeys.length();
    //     bytes32[] memory encryptionKeyIds = new bytes32[](len);
    //     address[][] memory license;
    //     for(uint256 i = 0; i < len; i++) {
    //         encryptionKeyIds[i] = _encryptionKeys.at(i);
    //         license[i] = getPermissions(tokenId, encryptionKeyIds[i]);
    //     }
    //     return (encryptionKeyIds, license);
    // }

    function getPermissions(uint256 tokenId, bytes32 encryptionKeyId) public view virtual returns (address[] memory) {
        EnumerableSet.AddressSet storage _permission = _permissions[tokenId][encryptionKeyId];
        address[] memory license = new address[](_permission.length());
        for(uint256 i = 0; i < _permission.length(); i++) {
            license[i] = _permission.at(i);
        }
        return license;
    }
}
