// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "./EVT.sol";
import "../libraries/toString.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyEVT is EVT {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _logo;
    
    uint256 public _tax;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory logo_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory _newBaseURI
    ) EVT(name_, symbol_, properties, encryptedKeyIDs, _newBaseURI) {
        _logo = logo_;
    }

    function logo() public view returns (string memory) {
        return _logo;
    }

    function setTax(uint256 _newTax) public onlyOwner returns (uint256) {
        _tax = _newTax;
        return _tax;
    }

    function mint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);
        addEncryptionKeyID(tokenId);
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        // addPermission
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
    }

    // /**
    //  * See helloEVT.json
    //  */
    // function tokenURI(uint256 tokenId) public view override returns (string memory) {
    //     string[20] memory args;
    //     args[0] = '{"name": "';
    //     args[1] = name();
    //     args[2] = ' # ';
    //     args[3] = Strings.toString(tokenId);
    //     args[4] = '", "description": "';
    //     args[5] = description();
    //     args[6] = '", "logo": "';
    //     args[7] = string(abi.encodePacked(logo(), Strings.toString(tokenId)));
    //     args[8] = '", "from": "';
    //     args[9] =  GetString.toString(abi.encodePacked(address(this)));
    //     args[10] = '", "tax": ';
    //     args[11] = Strings.toString(_tax);
    //     args[12] = ', "external_url": "';
    //     args[13] = _baseURI();
    //     args[14] = '", "properties": ';
    //     args[15] = getDynamicPropertiesAsString(tokenId);
    //     args[16] = '},';
    //     args[17] = '{"encryption":';
    //     args[18] = getPermissionsAsString(tokenId);
    //     args[19] = '}';

    //     string memory arg = string(abi.encodePacked(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]));
    //     arg = string(abi.encodePacked(arg, args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]));

    //     string memory json = Base64.encode(bytes(arg));
        
    //     return string(abi.encodePacked("data:application/json;base64,", json));

    // }
}
