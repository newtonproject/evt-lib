// // SPDX-License-Identifier: GPL-3.0
// pragma solidity ^0.8.3;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "../evt-base/EVT.sol";

// contract EVTVariableDemo is EVT, Ownable {

//     using Counters for Counters.Counter;

//     Counters.Counter private _tokenIdCounter;
    
//     mapping(bytes32 => string) private _properties;

    
//     constructor() EVT("VariableEVT", "VEVT") {
//     }

//     function safeMint(address to) public onlyOwner {
//         uint256 tokenId = _tokenIdCounter.current();
//         _tokenIdCounter.increment();
//         _safeMint(to, tokenId);
//     }

//     function getPropertyId(string memory propertyName) public view virtual returns (bytes32 propertyId) {
//         return keccak256(abi.encode(propertyName));
//     }

//     function addProperty(string memory propertyName) public onlyOwner {
//         require(bytes(propertyName).length > 0, "Invalid property!");
//         bytes32 propertyId = getPropertyId(propertyName);
//         EVTVariable.addDynamicProperty(propertyId);
//     }

//     function setProperty(uint256 tokenId, string memory propertyName, string memory propertyValue) public virtual payable {
//         bytes32 propertyId = getPropertyId(propertyName);
//         _properties[propertyId] = propertyName;
//         EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
//     }

//     function getProperty(uint256 tokenId, string memory propertyName) view public returns (string memory) {
//         bytes32 propertyId = getPropertyId(propertyName);
//         bytes memory propertyValue = EVTVariable.getDynamicProperty(tokenId, propertyId);
//         return abi.decode(propertyValue, (string));
//     }

//     function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns(string[] memory properties) {
//         (bytes32[] memory ids, bytes[] memory values) = EVTVariable.getDynamicProperties(tokenId);
//         require(ids.length == values.length, "length error");
//         properties = new string[](ids.length);
//         for (uint256 i = 0; i < ids.length; i++) {
//             bytes32 id = ids[i];
//             string memory args = string(abi.encodePacked('{"trait_type":"', _properties[id], '","value":'));
            
//             (string memory value) = abi.decode(values[i], (string));
//             args = string(abi.encodePacked(args, '"', value, '"'));

//             args = string(abi.encodePacked(args, '}'));
//             properties[i] = string(args);
//         }
//     }

//     function getDynamicPropertiesAsString(uint256 tokenId) public view virtual returns(string memory properties) {
//         string[] memory args = getDynamicPropertiesArray(tokenId);
//         properties = '[';
//         for (uint256 i = 0; i < args.length; i++) {
//             if (i + 1 == args.length) {
//                 properties = string(abi.encodePacked(properties, args[i]));
//             } else {
//                 properties = string(abi.encodePacked(properties, args[i], ','));
//             }
//         }
//         properties = string(abi.encodePacked(properties, ']'));
//     }
// }
