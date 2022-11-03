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

    struct Property {
        string property_type;
        string value;
    }

    // All property ids
    EnumerableSet.Bytes32Set internal _allPropertyIds;

    // All property types
    string[] internal _allPropertyNames;

    // Mapping from property ID to property type
    mapping(bytes32 => string) internal _propertyTypes;

    // Mapping from token ID to property IDs
    mapping(uint256 => EnumerableSet.Bytes32Set) private _propertyIds;

    // Mapping from token ID to list of propertyId to Property
    mapping(uint256 => mapping(bytes32 => Property)) private _propertiesValue;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IEVTVariable-addDynamicProperty}.
     */
    function addDynamicProperty(bytes32 propertyId) public payable virtual override {
        // require(msg.sender == , "Have no permission");
        require(supportsProperty(propertyId), "EVTVariable: propertyId not exist");
        _allPropertyIds.add(propertyId);

        emit DynamicPropertyAdded(propertyId);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperty}.
     */
    function setDynamicProperty(uint256 tokenId, bytes32 propertyId, string memory propertyValue) public virtual override payable {
        require(supportsProperty(propertyId), "EVTVariable: invalid propertyId");
        require(_propertyIds[tokenId].contains(propertyId), "EVTVariable: propertyId not exist");
        _propertyIds[tokenId].add(propertyId);
        _propertiesValue[tokenId][propertyId].property_type = _propertyTypes[propertyId];
        _propertiesValue[tokenId][propertyId].value = propertyValue;

        emit DynamicPropertyUpdated(tokenId, propertyId, propertyValue);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperties}.
     */
    function setDynamicProperties(uint256 tokenId, bytes32[] memory propertyIds, string[] memory propertyValues) public virtual override payable {
        require(propertyIds.length == propertyValues.length, "length not equal");
        for(uint256 i = 0; i < propertyIds.length; i++) {
            // require(supportsProperty(propertyIds[i]), "EVTVariable: invalid propertyId");
            // _propertiesValue[tokenId][propertyIds[i]].value = propertyValues[i];
            setDynamicProperty(tokenId, propertyIds[i], propertyValues[i]);

            emit DynamicPropertyUpdated(tokenId, propertyIds[i], propertyValues[i]);
        }
    }
    
    /**
     * @dev See {IEVTVariable-getDynamicProperty}.
     */
    function getDynamicProperty(uint256 tokenId, bytes32 propertyId) public view virtual override returns (string memory) {
        return _propertiesValue[tokenId][propertyId].value;
    }

    /**
     * @dev See {IEVTVariable-getDynamicProperties}.
     */
    function getDynamicProperties(uint256 tokenId) public view virtual override returns (string[] memory, string[] memory) {
        uint256 len = _propertyIds[tokenId].length();
        string[] memory property_types = new string[](len);
        string[] memory properties = new string[](len);
        for (uint256 i = 0; i < len; i++) {
            bytes32 propertyId = _propertyIds[tokenId].at(i);
            string memory property_name = _propertiesValue[tokenId][propertyId].property_type;
            property_types[i] = property_name;
            properties[i] = _propertiesValue[tokenId][propertyId].value;
        }
        return (property_types, properties);
    }

    /**
     * @dev See {IEVTVariable-getAllSupportProperties}.
     */
    function getAllSupportProperties() public view virtual override returns (string[] memory) {
        return _allPropertyNames;   
    }

    /**
     * @dev See {IEVTVariable-supportsProperty}.
     */
    function supportsProperty(bytes32 propertyId) public view virtual override returns (bool) {
        return _allPropertyIds.contains(propertyId);
    }
}
