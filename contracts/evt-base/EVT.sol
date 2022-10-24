// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IEVT.sol";
import "./extensions/EVTVariable.sol";
import "./extensions/EVTEncryption.sol";
import "../interfaces/IEVTMetadata.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard (NRC-).
 */
contract EVT is IEVT, IEVTMetadata, ERC721, EVTVariable, EVTEncryption {

    // todo
    address public _from;

    constructor(string memory name_, string memory symbol_, string[] memory properties) ERC721(name_, symbol_) {
        for(uint256 i = 0; i < properties.length; i++) {
            _allPropertyIds.add(keccak256(abi.encode(properties[i])));
        }
    }
    
    /**
     * @dev See {IERC165-supportsInterface}
     * IEVTVariable   : 0x6af74b02
     * IEVTEncryption : 0xd28afde2
     * IERC721        : 0x80ac58cd
     * IEVTMetadata   : todo
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165, ERC721, EVTVariable, EVTEncryption) returns (bool) {
        
        return 
            interfaceId == type(IEVT).interfaceId ||
            interfaceId == type(IEVTMetadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function from(uint256 tokenId) external view virtual override returns (string memory) {
        return _from;
    }

    // function external_urltokenId(uint256 tokenId) external view virtual override returns (string memory) {

    // }

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

    function variableURI(uint256 tokenId) public view virtual override returns (string memory) {
        // string memory baseURI = _baseURI();
        // return
        //     bytes(baseURI).length > 0
        //         ? string(abi.encodePacked(baseURI, "variable/", tokenId.toString()))
        //         : "";

        return 
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"properties":"',
                            getDynamicPropertiesAsString(tokenId),
                            '"}"'
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    function encryptionURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();
        return
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"encryption":"',
                            getPermission(tokenId),
                            '"}"'
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    function getPermissionArray(tokenId) public view virtual returns(string[] memory permissions) {
        // 返回permission数组

        return _permisson[tokenId];
        // Set转化为string
        // for() {
            
        // }
    } 

    function getDynamicPropertiesAsString(uint256 tokenId) public view virtual returns(string memory properties) {
        string[] memory args = getDynamicPropertiesArray(tokenId);
        properties = '[';
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

    function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns(string[] memory properties) {
        (bytes32[] memory trait_type, bytes[] memory values) = EVTVariable.getDynamicProperties(tokenId);
        require(trait_type.length == values.length, "length error");
        properties = new string[](trait_type.length);
        for (uint256 i = 0; i < trait_type.length; i++) {
            bytes32 trait_name = trait_type[i];
            string memory args = string(abi.encodePacked('{"trait_type":"', trait_name, '","value":'));
            
            (string memory value) = abi.decode(values[i], (string));
            args = string(abi.encodePacked(args, '"', value, '"'));

            args = string(abi.encodePacked(args, '}'));
            properties[i] = string(args);
        }
        return properties;
    }

}
