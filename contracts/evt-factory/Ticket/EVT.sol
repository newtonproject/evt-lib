// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./IEVT.sol";
import "./extensions/EVTVariable.sol";
import "./extensions/EVTEncryption.sol";
import "./interfaces/IEVTMetadata.sol";
import "../libraries/base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard (NRC-).
 */
contract EVT is IEVT, IEVTMetadata, ERC721, EVTEncryption, EVTVariable {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // EVT contract address
    address private _from = address(this);

    // Point to the EVT offchain data
    string private _external_uri;

    /**
     * @dev Initializes the contract by setting `name`、`symbol`、`properties` and `baseURI` to the token collection.
     */
    constructor(
        string memory name_, 
        string memory symbol_, 
        string[] memory properties,
        string memory _newBaseURI
    ) ERC721(name_, symbol_) {
        setBaseURI(_newBaseURI);
        uint256 len = properties.length;
        for(uint256 i = 0; i < len; i++) {
            bytes32 propertyId = keccak256(abi.encode(properties[i]));
            _allPropertyTypes.push(properties[i]);
            _propertyTypes[propertyId] = properties[i];
            _allPropertyIds.add(propertyId);
        }
    }

    /**
     * @dev Return the Contract Address.
     */
    function from() external view override returns (address) {
        return _from;
    }
    
    /**
     * @dev Set the _external_uri.
     *
     * Requirements:
     * 
     * - `msg.sender` must be the owner of the contract.
     */
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        _external_uri = _newBaseURI;
    }

    /**
     * @dev Override _baseURI() in ERC721.sol and return the _external_uri 
     representing the base URI for all token IDs.
     */
    function _baseURI() public view virtual override returns (string memory) {
        return _external_uri;
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

    /**
     * @dev Add new property besides properties passed in constructor function 
     * when Contract initiated.
     *
     * Requirements:
     *
     * - `msg.sender` must be the owner of the contract.
     * - PropertyName must not be empty.
     */
    function addDynamicProperty(string propertyName) public payable onlyOwner virtual override {
        require(bytes(propertyName).length > 0, "Empty property!");
        _allPropertyTypes.push(propertyName);
        bytes32 propertyId = keccak256(abi.encode(propertyName));
        EVTVariable.addDynamicProperty(propertyId);
    }

    /**
     * @dev See {IEVTMetadata-contractURI}.
     */  
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

    /**
     * @dev See {IEVTMetadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, IEVTMetadata) returns (string memory) {
        string memory baseURI = _baseURI();   
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(
                            abi.encodePacked(
                                '{"external_uri":',
                                baseURI,
                                ',"properties":',
                                getDynamicPropertiesAsString(tokenId),
                                ','
                                '"encryption":',
                                getPermissionsAsString(tokenId),
                                '}'
                            )
                        )
                    )
                )
                : string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(
                            abi.encodePacked(
                                '{"properties":',
                                getDynamicPropertiesAsString(tokenId),
                                ',',
                                '"encryption":',
                                getPermissionsAsString(tokenId),
                                '}'
                            )
                        )
                    )
                );
    }

    /**
     * @dev See {IEVTMetadata-variableURI}.
     */
    function variableURI(uint256 tokenId) public view virtual override returns (string memory) {
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
    
    /**
     * @dev See {IEVTMetadata-encryptionURI}.
     */
    function encryptionURI(uint256 tokenId) public view virtual override returns (string memory) {
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

    /**
     * @dev Get tokenId's encryptedKeys and licenses for every encryptionKey.
     * 
     * The result is a string in a JSON formatted array.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getPermissionsAsString(uint256 tokenId) public view virtual returns (string memory) {
        _requireMinted(tokenId);
        string[] memory args = getPermissionsArray(tokenId);
        string memory res = getStringData(args);
        return res;
    }

    /**
     * @dev Get tokenId's encryptedKeys and licenses for every encryptionKey.
     * 
     * The result is a string array consist of Object in JSON format.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getPermissionsArray(uint256 tokenId) public view virtual returns (string[] memory) {
        _requireMinted(tokenId);
        // (bytes32[] memory encryptionKeyIds, address[][] memory license) = EVTEncryption.getPermissions(tokenId);
        uint256 len = _tokenKeyIds[tokenId].length();
        string[] memory permissions = new string[](len);
        for (uint256 i = 0; i < len; i++) {
            bytes32 encryptionKeyId = _tokenKeyIds[tokenId].at(i);
            address[] memory license = EVTEncryption.getPermissions(tokenId, encryptionKeyId);
            string memory args = string(abi.encodePacked('{"encryptionKeyId":',
                                                            toString(abi.encodePacked(encryptionKeyId)),
                                                            ',"license":'
                                                          ));
            string[] memory stringLicense = new string[](license.length);
            for(uint256 j = 0; j < license.length; j++) {
                stringLicense[j] = toString(abi.encodePacked(license[j]));
 
            }
            string memory data = getStringData(stringLicense);
            args = string(abi.encodePacked(args, data));
            args = string(abi.encodePacked(args, '}'));

            permissions[i] = args;
        }

        return permissions;
    } 

    /**
     * @dev Get tokenId's dynamic properties.
     * 
     * The result is a string in a JSON formatted array.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getDynamicPropertiesAsString(uint256 tokenId) public view virtual returns (string memory) {
        _requireMinted(tokenId);
        string[] memory args = getDynamicPropertiesArray(tokenId);
        string memory res = getStringData(args);
        return res;
    }

    /**
     * @dev Get tokenId's dynamic properties.
     * 
     * The result is a string array consist of Object in JSON format.
     * 
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns (string[] memory) {
        _requireMinted(tokenId);
        (string[] memory trait_type, string[] memory values) = EVTVariable.getDynamicProperties(tokenId);
        require(trait_type.length == values.length, "length error");
        string[] memory properties = new string[](trait_type.length);
        for (uint256 i = 0; i < trait_type.length; i++) {
            string memory trait_name = trait_type[i];
            string memory args = string(abi.encodePacked('{"property_name":"',
                                                          trait_name,
                                                          '","value":'
                                                          ));
                args = string(abi.encodePacked(args, '"', values[i], '"'));

                args = string(abi.encodePacked(args, '}'));
                properties[i] = string(args);
        }
        return properties;
    }

    /**
     * @dev Transfer the string array to a string of JSON format.
     * 
     * @param args - String array consist of Object in JSON format.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getStringData(string[] memory args) internal pure returns (string memory) {
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