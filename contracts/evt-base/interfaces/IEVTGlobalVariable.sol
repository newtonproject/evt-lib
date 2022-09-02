// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "../IEVT.sol";

interface IEVTGlobalVariable is IEVT {
    /**
     * @dev Emitted when dynamic property updated.
     */
    event GlobalPropertyUpdated(bytes32 propertyId, bytes propertyValue);

     /**
     * @dev Set the `propertyId` and `propertyValue`.
     * propertyId = bytes32(keccak256('propertyName')) 
     * Requirements:
     *
     * - `propertyId` must exist.
     */
	function setDynamicGlobalProperty(bytes32 propertyId, bytes memory propertyValue) external payable;
	
    /**
     * @dev Returns the properties of the `propertyId` token.
     *
     * Requirements:
     *
     * - `propertyId` must exist.
     */
	function getDynamicGlobalProperty(bytes32 propertyId) external view returns (bytes memory propertyValue);

    /**
     * @dev Returns whether the `propertyId` exists.
     *
     * Requirements:
     *
     * - `propertyId` must exist.
     */
    function supportGlobalProperty(bytes32 propertyId) external view returns (bool);
}
