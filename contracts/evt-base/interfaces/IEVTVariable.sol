// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

interface IEVTVariable {
    /**
     * @dev Emitted when dynamic property added.
     */
    event DynamicPropertyAdded(string propertyName);
    
    /**
     * @dev Emitted when dynamic property updated.
     */
    event DynamicPropertyUpdated(uint256 tokenId, string propertyName, string propertyValue);

    /**
     * @dev Add the `propertyName`.
     *
     * Requirements:
     *
     * - `msg.sender` must be the contract owner.
     */
    function addDynamicProperty(string memory propertyName) external;
    
    /**
     * @dev Set the `propertyValue` by `tokenId` and `propertyName`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyName` must exist.
     */
	function setDynamicProperty(uint256 tokenId, string memory propertyName, string memory propertyValue) external payable;
	
    /**
     * @dev Set the `propertyValue` by `tokenId` and `propertyName` in quantity.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyName` must exist.
     */
	function setDynamicProperties(uint256 tokenId, string[] memory propertyNames, string[] memory propertyValues) external payable;

    /**
     * @dev Returns the `propertyValue` of the tokenId's `propertyName`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyName` must exist.
     */
	function getDynamicPropertyValue(uint256 tokenId, string memory propertyName) external view returns (string memory propertyValue);

    /**
     * @dev Returns the `propertyName` array and `propertyValue` array corresponding to tokenId.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyName` must exist.
     */
    function getDynamicProperties(uint256 tokenId) external view returns (string[] memory propertyNames, string[] memory propertyValues);

    /**
     * @dev Returns all supported propertyNames.
     */
    function getAllSupportProperties() external view returns (string[] memory);
  
    /**
     * @dev Returns whether the `propertyName` exists.
     */
	function supportsProperty(string memory propertyName) external view returns (bool);
}
