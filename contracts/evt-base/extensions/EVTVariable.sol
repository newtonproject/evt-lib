// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/IEVTVariable.sol";

/**
 * @dev This implements an optional extension of {EVT} that adds dynamic properties.
 */
abstract contract EVTVariable is ERC165, IEVTVariable {
    // using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Property {
        string name;
        string value;
    }

    // All property types
    string[] internal _allPropertyNames;

    // Mapping from property ID to property type
    // mapping(bytes32 => string) internal _propertyTypes;

    // Mapping from token ID to property IDs
    mapping(uint256 => string[]) internal _propertyNames;

    // Mapping from token ID to list of propertyId to Property
    mapping(uint256 => Property) internal _properties;

    // tokenId => propertyName => propertyValue
    mapping(uint256 => mapping(string => string)) propertyValue;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    function hashCompareString(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
    }

    /**
     * @dev See {IEVTVariable-addDynamicProperty}.
     */
    function addDynamicProperty(string memory propertyName) public payable virtual override {
        // require(supportsProperty(propertyId), "EVTVariable: propertyId not exist");
        // _allPropertyIds.add(propertyId);
        _allPropertyNames.push(propertyName);

        emit DynamicPropertyAdded(propertyName);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperty}.
     */
    function setDynamicProperty(
        uint256 tokenId, 
        string memory property_Name, 
        string memory property_Value
    ) public virtual override payable {
        // require(supportsProperty(propertyId), "EVTVariable: Not supported propertyId");
        // require(_propertyIds[tokenId].contains(propertyId), "EVTVariable: propertyId not exist");
        require(supprtProperrt(property_Name), "Not supported property!");
        _propertyNames[tokenId].push(property_Name);
        _properties[tokenId].name = property_Name;
        _properties[tokenId].value = property_Value;
        propertyValue[tokenId][property_Name] = property_Value;

        emit DynamicPropertyUpdated(tokenId, property_Name, property_Value);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperties}.
     */
    function setDynamicProperties(
        uint256 tokenId, 
        string[] memory propertyNames, 
        string[] memory propertyValues
    ) public virtual override payable {
        require(propertyNames.length == propertyValues.length, "length not equal");
        for(uint256 i = 0; i < propertyNames.length; i++) {
            setDynamicProperty(tokenId, propertyNames[i], propertyValues[i]);
        }
    }
    
    /**
     * @dev See {IEVTVariable-getDynamicProperty}.
     */
    function getDynamicPropertyValue(
        uint256 tokenId, 
        string memory propertyName
    ) public view virtual override returns (string memory) {
        return propertyValue[tokenId][propertyName];
    }

    /**
     * @dev See {IEVTVariable-getDynamicProperties}.
     */
    function getDynamicProperties(
        uint256 tokenId
    ) public view virtual override returns (string[] memory, string[] memory) {
        uint256 len = _propertyNames[tokenId].length;
        string[] memory property_names = new string[](len);
        string[] memory properties = new string[](len);
        for (uint256 i = 0; i < len; i++) {
            property_names[i] = _properties[tokenId].name;
            properties[i] = _properties[tokenId].value;
        }
        return (property_names, properties);
    }

    /**
     * @dev See {IEVTVariable-getAllSupportProperties}.
     */
    function getAllSupportProperties(
    ) public view virtual override returns (string[] memory) {
        return _allPropertyNames;   
    }

    /**
     * @dev See {IEVTVariable-supportsProperty}.
     */
    function supportsProperty(
        string memory propertyName
    ) public view virtual override returns (bool) {
        bool res = false;
        for(uint8 i = 0; i < _allPropertyNames.length; i++) {
            if(hashCompareString(propertyName, _allPropertyNames[i])) {
                res = true;
                break;
            }
        }
        return res;
    }
}
