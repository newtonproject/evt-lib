// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/IEVTVariable.sol";

/**
 * @dev This implements an optional extension of {EVT} that adds dynamic properties.
 */
abstract contract EVTVariable is ERC165, IEVTVariable {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // List of propertie ids
    EnumerableSet.Bytes32Set private _propertieIds;

    // Mapping tokenId ==> propertieId ==> propertieValue
    mapping(uint256 => mapping(bytes32 => bytes)) private _properties;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    function setDynamicProperty(uint256 tokenId, bytes32 propertyId, bytes memory propertyValue) public virtual override payable {
        _propertieIds.add(propertyId);
        _properties[tokenId][propertyId] = propertyValue;

        emit DynamicPropertyUpdated(tokenId, propertyId, propertyValue);
    }

    function setDynamicProperties(uint256 tokenId, bytes memory message) public virtual override payable {
        require(false, "NOT IMPLEMENTED!");
        // TODO:
    }
    
	function getProperty(uint256 tokenId, bytes32 propertyId) public view virtual override returns (bytes memory) {
        return _properties[tokenId][propertyId];
    }

    function getProperties(uint256 tokenId) public view virtual override returns(bytes32[] memory ids, bytes[] memory properties) {
        uint256 len = _propertieIds.length();
        ids = new bytes32[](len);
        properties = new bytes[](len);
        for (uint256 i = 0; i < len; i++) {
            bytes32 id = _propertieIds.at(i);
            ids[i] = id;
            properties[i] = _properties[tokenId][id];
        }
    }

	function supportsProperty(bytes32 propertyId) public view virtual override returns (bool) {
        return _propertieIds.contains(propertyId);
    }
}