// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "../erc721a/IERC721A.sol";
import "./interfaces/IEVTVariable.sol";
import "./interfaces/IEVTEncryption.sol";

interface IEVTA is IERC721A, IEVTVariable, IEVTEncryption  {

    /**
     * @dev Add new property besides properties passed in constructor function 
     * when Contract initiated.
     *
     * Requirements:
     *
     * - `msg.sender` must be the owner of the contract.
     * - PropertyName must not be empty.
     */
    function addDynamicProperty(string memory propertyName) external payable;

    /**
     * @dev Get tokenId's encryptedKeys and licenses for every encryptionKey.
     * 
     * The result is a string in a JSON formatted array.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getPermissionsAsString(uint256 tokenId) external view returns (string memory);

    /**
     * @dev Get tokenId's dynamic properties.
     * 
     * The result is a string in a JSON formatted array.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getDynamicPropertiesAsString(uint256 tokenId) external view returns (string memory);
}