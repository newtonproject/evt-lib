// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interfaces/IEVTVariable.sol";
import "./interfaces/IEVTEncryption.sol";

interface IEVT is IERC721, IEVTVariable, IEVTEncryption  {
    
    /**
     * @dev Add new property besides properties passed in constructor function 
     * when Contract initiated.
     *
     * Requirements:
     *
     * - `msg.sender` must be the owner of the contract.
     * - PropertyName must not be empty.
     */
    function addDynamicProperty(string propertyName) public payable;

    /**
     * @dev Get tokenId's encryptedKeys and licenses for every encryptionKey.
     * 
     * The result is a string in a JSON formatted array.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getPermissionsAsString(uint256 tokenId) public view returns (string memory);

    /**
     * @dev Get tokenId's dynamic properties.
     * 
     * The result is a string in a JSON formatted array.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getDynamicPropertiesAsString(uint256 tokenId) public view virtual returns (string memory);
}