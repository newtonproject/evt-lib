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
    EnumerableSet.Bytes32Set private _allPropertyIds;

    mapping(uint256 => EnumerableSet.Bytes32Set) private _propertyIds;

    struct Value {
        string trait_type;
        string value;
    }

    // Mapping tokenId ==> propertyId ==> propertie Id and value
    mapping(uint256 => mapping(bytes32 => Value)) private _propertiesValue;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IEVTVariable).interfaceId || super.supportsInterface(interfaceId);
    }

    function addDynamicProperty(uint256 tokenId, bytes32 propertyName) public payable virtual override {
        require(_allPropertyIds.contains(keccak256(abi.encode(propertyName))) && !propertyIds.contains(keccak256(abi.encode(propertyName))) , "EVTVariable: propertyId exist");
        _propertyIds[tokenId].add(keccak256(abi.encode(propertyName)));
        _propertiesValue[tokenId][propertyId].trait_type = propertyName;

        emit DynamicPropertyAdded(propertyId);
    }

    function setDynamicProperty(uint256 tokenId, bytes32 propertyId, bytes memory propertyValue) public virtual override payable {
        require(supportsProperty(propertyId), "EVTVariable: invalid propertyId");
        _propertiesValue[tokenId][propertyId].value = propertyValue;

        emit DynamicPropertyUpdated(tokenId, propertyId, propertyValue);
    }

    function setDynamicProperties(uint256 tokenId, bytes32[] memory propertyIds, bytes[] memory propertyValues) public virtual override payable {
        require(propertyIds.length == propertieValues.length, "length not equal");
        for(uint256 i = 0; i < propertyIds.length; i++) {
            require(supportsProperty(propertyIds[i]), "EVTVariable: invalid propertyId");
            _propertiesValue[tokenId][propertyIds[i]].value = propertyValues[i];

            emit DynamicPropertyUpdated(tokenId, propertyId, propertyValue);
        }
    }
    
	function getDynamicProperty(uint256 tokenId, bytes32 propertyId) public view virtual override returns (bytes memory) {
        return _propertiesValue[tokenId][propertyId].value;
    }

    // return dynamic properties ids and dynamic properties, id is the result of property id's hash
    function getDynamicProperties(uint256 tokenId) public view virtual override returns(bytes32[] memory ids, bytes[] memory properties) {
        uint256 len = _propertyIds[tokenId].length();
        bytes32[] memory trait_type = new bytes32[](len);
        bytes[] memory properties = new bytes[](len);
        for (uint256 i = 0; i < len; i++) {
            bytes32 trait_name = _propertiesValue[tokenId][_propertyIds.at[i]].trait_type;
            trait_type[i] = trait_name;
            properties[i] = _propertiesValue[tokenId].value;
        }
        return (trait_type, properties);
    }

	function supportsProperty(bytes32 propertyId) public view virtual override returns (bool) {
        return _propertyIds.contains(propertyId);
    }
}