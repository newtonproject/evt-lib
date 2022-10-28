// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./IEVT.sol";
import "./extensions/EVTVariable.sol";
import "./extensions/EVTEncryption.sol";
import "./interfaces/IEVTMetadata.sol";
import "./libraries/base64.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard (NRC-).
 */
contract EVT is IEVT, IEVTMetadata, ERC721, EVTVariable, EVTEncryption {

    using EnumerableSet for EnumerableSet.Bytes32Set;

    address private _from = address(this);

    // using Counters for Counters.Counter;

    // Counters.Counter private _tokenIdCounter;

    constructor(string memory name_, string memory symbol_, string[] memory properties) ERC721(name_, symbol_) {
        uint256 len = properties.length;
        for(uint256 i = 0; i < len; i++) {
            bytes32 propertyId = keccak256(abi.encode(properties[i]));
            _allPropertyTypes.push(properties[i]);
            _propertyTypes[propertyId] = properties[i];
            _allPropertyIds.add(propertyId);
        }
    }

    function from() external view override returns (address) {
        return _from;
    }
    
    /**
     * @dev See {IERC165-supportsInterface}
     * IEVTVariable   : 0x6af74b02
     * IEVTEncryption : 0xd28afde2
     * IERC721        : 0x80ac58cd
     * IEVTMetadata   : todo
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721, EVTVariable, EVTEncryption) returns (bool) {
        
        return 
            interfaceId == type(IEVT).interfaceId ||
            interfaceId == type(IEVTMetadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }


    function contractURI() public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();   
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        baseURI,
                        "contract/",
                        Strings.toHexString(uint256(uint160(address(this))))
                    )
                )
                : "";
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, IEVTMetadata) returns (string memory) {
        // require(_requireMinted(tokenId));
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(
                            abi.encodePacked(
                                baseURI,
                                '{"properties":"',
                                getDynamicPropertiesAsString(tokenId),
                                '"},'
                                '{"encryption":"',
                                getPermissionsAsString(tokenId),
                                '"}'
                            )
                        )
                    )
                )
                : "";
                // : string(
                //     abi.encodePacked(
                //         "data:application/json;base64,",
                //         Base64.encode(
                //             abi.encodePacked(
                //                 '{"properties":"',
                //                 getDynamicPropertiesAsString(tokenId),
                //                 '"},'
                //                 '{"encryption":"',
                //                 getPermissionsAsString(tokenId),
                //                 '"}'
                //             )
                //         )
                //     )
                // );
    }

    function variableURI(uint256 tokenId) public view virtual override returns (string memory) {
        // require(_requireMinted(tokenId));
        return 
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"properties":',
                            getDynamicPropertiesAsString(tokenId),
                            '}'
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    function encryptionURI(uint256 tokenId) public view virtual override returns (string memory) {
        // require(_requireMinted(tokenId));
        // string memory baseURI = _baseURI();
        return
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"encryption":',
                            getPermissionsAsString(tokenId),
                            '}'
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    function getPermissionsAsString(uint256 tokenId) public view virtual returns(string memory) {
        string[] memory args = getPermissionsArray(tokenId);
        return getStringData(args);
    }

    function getPermissionsArray(uint256 tokenId) public view virtual returns(string[] memory) {
        // return permissions array
        (bytes32[] memory encryptionKeyIds, address[][] memory license) = EVTEncryption.getPermissions(tokenId);
        string[] memory permissions = new string[](encryptionKeyIds.length);
        for (uint256 i = 0; i < encryptionKeyIds.length; i++) {
            bytes32 encryptionKeyId = encryptionKeyIds[i];
            string memory args = string(abi.encodePacked('{"encryptionKeyId":"',
                                                            encryptionKeyId,
                                                            '","license":'
                                                            // '['    
                                                        ));
            string[] memory stringLicense;
            for(uint256 j = 0; j < license[i].length; j++) {
                // (string memory singleLicense) = abi.decode(license[i], (string));
                
                // args = string(abi.encodePacked(args, 
                //                                 toString(abi.encodePacked(license[i][j])),
                //                                 '",'
                //                               ));
                stringLicense[j] = toString(abi.encodePacked(license[i][j]));
 
            }
            string memory data = getStringData(stringLicense);
            // args = string(abi.encodePacked(args, ']}'));
            args = string(abi.encodePacked(args, data, '}'));

            permissions[i] = args;
        }

        return permissions;
    } 

    function getDynamicPropertiesAsString(uint256 tokenId) public view virtual returns(string memory) {
        string[] memory args = getDynamicPropertiesArray(tokenId);
        string memory res = getStringData(args);
        return res;
    }

    function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns(string[] memory) {
        (string[] memory trait_type, string[] memory values) = EVTVariable.getDynamicProperties(tokenId);
        require(trait_type.length == values.length, "length error");
        string[] memory properties = new string[](trait_type.length);
        for (uint256 i = 0; i < trait_type.length; i++) {
            string memory trait_name = trait_type[i];
            string memory args = string(abi.encodePacked('{"property_type":"',
                                                          trait_name,
                                                          '","value":'
                                                          ));
            
                // (string memory value) = abi.decode(values[i], (string));
                args = string(abi.encodePacked(args, '"', values[i], '"'));

                args = string(abi.encodePacked(args, '}'));
                properties[i] = string(args);
        }
        return properties;
    }

    function getStringData(string[] memory args) public pure returns (string memory) {
        string memory properties = '[';
        for (uint256 i = 0; i < args.length; i++) {
            if (i + 1 == args.length) {
                properties = string(abi.encodePacked(properties, args[i]));
            } else {
                properties = string(abi.encodePacked(properties, args[i], ','));
            }
        }
        properties = string(abi.encodePacked(properties, ']'));
        return properties;
    }

    function toString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
    
}