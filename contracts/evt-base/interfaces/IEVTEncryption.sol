// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

interface IEVTEncryption {

    /**
     * @dev encrypt `tokenId`
     * encryptedKeyID = bytes32(keccak256('encryptedKey');
     * Requirements:
     *
     * - `tokenId` token must exist and be owned by `from`.
     *
     */
    function encrypt(uint256 tokenId, bytes32 encryptedKeyID, bytes memory encryptedKeyValue) external payable;
	
    /**
     * @dev Returns the results - bool
     * expiredTime is the limit dateTime for one permission
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner, uint256 expiredTime) external payable returns(bool);
	
    /**
     * @dev Returns the results - bool
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external returns (bool);

    /**
     * @dev Returns the results - bool
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external view returns (bool);

    /**
     * @dev Returns encryptedKeyValue - bytes
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     */
    function getEncryptedKeyValue(uint256 tokenId, bytes32 encryptedKeyID) external view returns (bytes memory);
}