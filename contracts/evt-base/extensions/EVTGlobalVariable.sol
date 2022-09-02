// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../EVT.sol";
import "../interfaces/IEVTGlobalVariable.sol";

/**
 * @dev This implements an optional extension of {EVT} that adds dynamic properties.
 */
abstract contract EVTGlobalVariable is EVT, IEVTGlobalVariable {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes4 public IEVTGlobalVariable_id = type(IEVTGlobalVariable).interfaceId;

    // List of propertie ids
    EnumerableSet.Bytes32Set private _globalPropertieIds;

    // Mapping propertieId ==> propertieValue
    mapping(bytes32 => bytes) private _globalProperties;

    /**
     * @dev See {IERC165-supportsInterface}.
     * IEVTGlobalVariable: 
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, EVT) returns (bool) {
        return interfaceId == type(IEVTGlobalVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    function setDynamicGlobalProperty(bytes32 propertyId, bytes memory propertyValue) public virtual override payable {
        _globalPropertieIds.add(propertyId);
        _globalProperties[propertyId] = propertyValue;

        emit GlobalPropertyUpdated(propertyId, propertyValue);
    }
    
	function getDynamicGlobalProperty(bytes32 propertyId) public view virtual override returns (bytes memory) {
        return _globalProperties[propertyId];
    }

    function supportGlobalProperty(bytes32 propertyId) public view virtual override returns (bool) {
        return _globalPropertieIds.contains(propertyId);
    }
}