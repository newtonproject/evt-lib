// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/IEVTVariable.sol";

/**
 * @dev This implements an optional extension of {EVT} that adds dynamic properties.
 */
abstract contract EVTVariable is ERC165, IEVTVariable {
    // All property Names
    string[] internal _allPropertyNames;

    // Mapping from token ID to property Names
    mapping(uint256 => string[]) internal _propertyNames;

    // Mapping: tokenId => propertyName => _propertyValue
    mapping(uint256 => mapping(string => string)) internal _propertyValue;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IEVTVariable-addDynamicProperty}.
     */
    function addDynamicProperty(string memory propertyName) public virtual override {
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
        string memory propertyName, 
        string memory property_value
    ) public virtual override payable {
        require(supportsProperty(propertyName), "Not supported property");
        if(!hasProperty(tokenId, propertyName)) {
            _propertyNames[tokenId].push(propertyName);
        }
        _propertyValue[tokenId][propertyName] = property_value;

        emit DynamicPropertyUpdated(tokenId, propertyName, property_value);
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
    
    /**
     * @dev If tokenId has the property.
     */
    function hasProperty(
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

    /**
     * @dev Return two strings is equal or not.
     */
    function hashCompareString(string memory a, string memory b) internal pure returns (bool) {
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
        }
    }
}
