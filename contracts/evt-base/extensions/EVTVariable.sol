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

    // evt constructor propertyIds
    EnumerableSet.Bytes32Set internal _allPropertyIds;

    mapping(bytes32 => string) internal _propertyTypes;
    string[] internal _allPropertyTypes;

    // tokenId => propertyIds
    mapping(uint256 => EnumerableSet.Bytes32Set) private _propertyIds;

    struct Property {
        string property_type;
        string value;
    }

    // Mapping tokenId ==> propertyId ==> propertie Id and value
    mapping(uint256 => mapping(bytes32 => Property)) private _propertiesValue;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    function addDynamicProperty(uint256 tokenId, bytes32 propertyId) public payable virtual override {
        // bytes32 _propertyId = keccak256(abi.encode(propertyName));
        require(supportsProperty(propertyId) && !_propertyIds[tokenId].contains(propertyId) , "EVTVariable: propertyId exist");
        _propertyIds[tokenId].add(propertyId);
        _propertiesValue[tokenId][propertyId].property_type = _propertyTypes[propertyId];

        emit DynamicPropertyAdded(propertyId);
    }

    function setDynamicProperty(uint256 tokenId, bytes32 propertyId, string memory propertyValue) public virtual override payable {
        require(supportsProperty(propertyId), "EVTVariable: invalid propertyId");
        _propertyIds[tokenId].add(propertyId);
        _propertiesValue[tokenId][propertyId].property_type = _propertyTypes[propertyId];
        _propertiesValue[tokenId][propertyId].value = propertyValue;

        emit DynamicPropertyUpdated(tokenId, propertyId, propertyValue);
    }

    function setDynamicProperties(uint256 tokenId, bytes32[] memory propertyIds, string[] memory propertyValues) public virtual override payable {
        require(propertyIds.length == propertyValues.length, "length not equal");
        for(uint256 i = 0; i < propertyIds.length; i++) {
            // require(supportsProperty(propertyIds[i]), "EVTVariable: invalid propertyId");
            // _propertiesValue[tokenId][propertyIds[i]].value = propertyValues[i];
            setDynamicProperty(tokenId, propertyIds[i], propertyValues[i]);

            emit DynamicPropertyUpdated(tokenId, propertyIds[i], propertyValues[i]);
        }
    }
    
	function getDynamicProperty(uint256 tokenId, bytes32 propertyId) public view virtual override returns (string memory) {
        return _propertiesValue[tokenId][propertyId].value;
    }

    // return dynamic properties ids and dynamic properties, id is the result of property id's hash
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

	function supportsProperty(bytes32 propertyId) public view virtual override returns (bool) {
        return _allPropertyIds.contains(propertyId);
    }
}
