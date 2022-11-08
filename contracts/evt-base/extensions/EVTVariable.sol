// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/IEVTVariable.sol";

/**
 * @dev This implements an optional extension of {EVT} that adds dynamic properties.
 */
abstract contract EVTVariable is ERC165, IEVTVariable {
    // All property types
    string[] internal _allPropertyNames;

    // Mapping from token ID to property IDs
    mapping(uint256 => string[]) internal _propertyNames;

    // tokenId => propertyName => _propertyValue
    mapping(uint256 => mapping(string => string)) internal _propertyValue;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    function hashCompareString(string memory a, string memory b) internal pure returns (bool) {
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
        }
    }

    /**
     * @dev See {IEVTVariable-addDynamicProperty}.
     */
    function addDynamicProperty(string memory propertyName) public payable virtual override {
        require(bytes(propertyName).length > 0, "Empty property");
        require(!supportsProperty(propertyName), "PropertyName exist");
        _allPropertyNames.push(propertyName);

        emit DynamicPropertyAdded(propertyName);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperty}.
     */
    function setDynamicProperty(
        uint256 tokenId, 
        string memory property_name, 
        string memory property_value
    ) public virtual override payable {
        // require(supportsProperty(propertyId), "EVTVariable: Not supported propertyId");
        // require(_propertyIds[tokenId].contains(propertyId), "EVTVariable: propertyId not exist");
        require(supportsProperty(property_name), "Not supported property");
        if(!tokenHasProperty(tokenId, property_name)) {
            _propertyNames[tokenId].push(property_name);
        }
        // _properties[tokenId].name = property_name;
        // _properties[tokenId].value = property_value;
        _propertyValue[tokenId][property_name] = property_value;

        emit DynamicPropertyUpdated(tokenId, property_name, property_value);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperties}.
     */
    function setDynamicProperties(
        uint256 tokenId, 
        string[] memory propertyNames, 
        string[] memory propertyValues
    ) public virtual override payable {
        require(propertyNames.length == propertyValues.length, "length err");
        for(uint256 i = 0; i < propertyNames.length; ++i) {
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
        return _propertyValue[tokenId][propertyName];
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
        for (uint256 i = 0; i < len; ++i) {
            property_names[i] = _propertyNames[tokenId][i];
            properties[i] = _propertyValue[tokenId][property_names[i]];
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
        for(uint8 i = 0; i < _allPropertyNames.length; ++i) {
            if(hashCompareString(propertyName, _allPropertyNames[i])) {
                res = true;
                break;
            }
        }
        return res;
    }

    function tokenHasProperty(
        uint256 tokenId, 
        string memory propertyName
    ) public view virtual returns (bool) {
        bool res = false;
        for(uint8 i = 0; i < _propertyNames[tokenId].length; ++i) {
            if(hashCompareString(propertyName, _propertyNames[tokenId][i])) {
                res = true;
                break;
            }
        }
        return res;
    }
}
