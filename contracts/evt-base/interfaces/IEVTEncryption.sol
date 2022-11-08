// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

interface IEVTEncryption {
    /**
     * @dev Emitted when register `encryptedKeyID` encryptedKey for `tokenId` token.
     */
    event EncryptedKeyRegistered(bytes32 encryptedKeyID);
    
    /**
     * @dev Emitted when add `tokenId` token permission to `licensee`.
     */
    event PermissionAdded(uint256 indexed tokenId, bytes32 encryptedKeyID, address indexed licensee);

    /**
     * @dev Emitted when remove `tokenId` token permission from `licensee`.
     */
    event PermissionRemoved(uint256 indexed tokenId, bytes32 encryptedKeyID, address indexed licensee);

    /**
     * @dev Emitted when add `encryptedKeyID` to `tokenId` token.
     */
    event EncryptionKeyIDAdded(uint256 indexed tokenId, bytes32 encryptedKeyID);
    
    /**
     * @dev registerEncryptedKey to `tokenId` token
     * Requirements:
     *
     * - `tokenId` token must exist and be owned by `from`.
     *
     */
    function registerEncryptedKey(bytes32 encryptedKeyID) external payable;

    /**
     * @dev Add all encryptionKeyIDs to `tokenId` token
     * Requirements:
     *
     * - `tokenId` token must exist.
     *
     */
    function addEncryptionKeyID(uint256 tokenId) external payable;
	
    /**
     * @dev Add `tokenId` token Permission to `licensee` width `encryptedKeyID`
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist and must registered.
     */
    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) external payable;
	
    /**
     * @dev Remove `tokenId` token Permission to `licensee` width `encryptedKeyID`
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) external;

    /**
     * @dev Returns the results - bool
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address licensee) external view returns (bool);

    /**
     * @dev Returns the list of licensees
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function getPermissions(uint256 tokenId, bytes32 encryptedKeyID) external view returns (address[] memory);
}