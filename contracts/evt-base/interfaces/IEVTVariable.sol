// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

interface IEVTVariable {
    /**
     * @dev Emitted when dynamic property added.
     */
    event DynamicPropertyAdded(bytes32 propertyId);
    
    /**
     * @dev Emitted when dynamic property updated.
     */
    event DynamicPropertyUpdated(uint256 tokenId, bytes32 propertyId, string propertyValue);


     /**
     * @dev Add the `propertyId`.
     *
     * Requirements:
     *
     * - `propertyId` must exist.
     */
    function addDynamicProperty(uint256 tokenId, bytes32 propertyId) external payable;
    
     /**
     * @dev Set the `propertyValue` by `tokenId` and `propertyId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyId` must exist.
     */
	function setDynamicProperty(uint256 tokenId, bytes32 propertyId, string memory propertyValue) external payable;
	
    /**
     * @dev Set the `propertyValue` by `tokenId` and `propertyId` in quantity.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyId` must exist.
     */
	function setDynamicProperties(uint256 tokenId, bytes32[] memory propertyIds, string[] memory propertyValues) external payable;

    /**
     * @dev Returns the properties of the `propertyId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyId` must exist.
     */
	function getDynamicProperty(uint256 tokenId, bytes32 propertyId) external view returns (string memory propertyValue);

    /**
     * @dev Returns the properties of the `propertyId` token in quantity.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `propertyId` must exist.
     */
    function getDynamicProperties(uint256 tokenId) external view returns (string[] memory propertyIds, string[] memory propertyValues);

    /**
     * @dev Returns all supported properties.
     */
    function getAllSupportProperties() external view returns (string[] memory);
  
    /**
     * @dev Returns whether the `propertyId` exists.
     */
	function supportsProperty(bytes32 propertyId) external view returns (bool);
}
