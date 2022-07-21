// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../evt-base/EVT.sol";
import "../interfaces/IEVTMetadata.sol";
import "../libraries/HexStrings.sol";
import "../libraries/NewtonAddress.sol";
import "../libraries/base64.sol";

contract HelloEVT is ERC165, EVT, IEVTMetadata, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    struct Value {
        string value_;
        bool has_;
    }
    mapping(bytes32 => Value) private _properties;

    string public baseURI;
    string public baseExtension = "data:application/json;base64,";

    mapping(uint256 => string) private _descriptions;
    mapping(uint256 => uint256) private _taxs;
    string _logo;
    string _from;
    string _external_url;
    
    constructor(
        string memory name_, 
        string memory symbol_, 
        string memory baseURI_, 
        string memory logo_, 
        string memory from_, 
        string memory external_url_
    ) EVT(name_, symbol_) {
        setBaseURI(baseURI_);
        _logo = logo_;
        _from = from_;
        _external_url = external_url_;
    }

    function safeMint(address to, string memory description_, uint256 tax_) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _descriptions[tokenId] = description_;
        _taxs[tokenId] = tax_;
        _safeMint(to, tokenId);
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function description(uint256 tokenId) public view override returns (string memory) {
        return _descriptions[tokenId];
    }

    function logo() public view override returns (string memory) {
        return _logo;
    }

    function from() public view override returns (string memory) {
        return _from;
    }

    function tax(uint256 tokenId) public view override returns (uint) {
        return _taxs[tokenId];
    }

    function external_url() public view override returns (string memory) {
        return _external_url;
    }

    function getPropertyId(string memory propertyName) public view virtual returns (bytes32 propertyId) {
        return keccak256(abi.encode(propertyName));
    }

    function addProperty(string memory propertyName) public onlyOwner {
        require(bytes(propertyName).length > 0, "Empty property!");
        bytes32 propertyId = getPropertyId(propertyName);
        require(!_properties[propertyId].has_, "Repeated property!");
        _properties[propertyId].has_ = true;
    }

    function setProperty(uint256 tokenId, string memory propertyName, string memory propertyValue) public virtual payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_properties[propertyId].has_, "None property!");
        _properties[propertyId].value_ = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }

    function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns(string[] memory properties) {
        (bytes32[] memory ids, bytes[] memory values) = EVTVariable.getProperties(tokenId);
        require(ids.length == values.length, "length error");
        properties = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            string memory args = string(abi.encodePacked('{"trait_type":"', _properties[id].value_, '","value":'));
            
            (string memory value) = abi.decode(values[i], (string));
            args = string(abi.encodePacked(args, '"', value, '"'));

            args = string(abi.encodePacked(args, '}'));
            properties[i] = string(args);
        }
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
    }

    /**
     * See helloEVT.json
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (bytes(baseURI).length != 0) {
            return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
        }
        string[17] memory args;
        args[0] = '{"name": "';
        args[1] = symbol();
        args[2] = ' # ';
        args[3] = Strings.toString(tokenId);
        args[4] = '", "description": "';
        args[5] = description(tokenId);
        args[6] = '", "logo": "';
        args[7] = string(abi.encodePacked(logo(), Strings.toString(tokenId)));
        args[8] = '", "from": "';
        args[9] = from();
        args[10] = '", "tax": ';
        args[11] = Strings.toString(tax(tokenId));
        args[12] = ', "external_url": "';
        args[13] = string(abi.encodePacked(external_url(), Strings.toString(tokenId)));
        args[14] = '", "properties": ';
        args[15] = getDynamicPropertiesAsString(tokenId);
        args[16] = ' }';

        string memory arg = string(abi.encodePacked(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]));
        arg = string(abi.encodePacked(arg, args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]));

        string memory json = Base64.encode(bytes(arg));
        
        return string(abi.encodePacked(baseExtension, json));
    }
       
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, EVT) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
