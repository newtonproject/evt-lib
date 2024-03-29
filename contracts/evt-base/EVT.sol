// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./interfaces/IEVT.sol";
import "./extensions/EVTVariable.sol";
import "./extensions/EVTEncryption.sol";
import "../libraries/GetString.sol";
import "./interfaces/IEVTMetadata.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard.
 * https://neps.newtonproject.org/neps/nep-53/
 */
contract EVT is
    IEVT,
    ERC721,
    IEVTMetadata,
    Ownable,
    EVTEncryption,
    EVTVariable
{
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // Point to the EVT offchain data
    string public baseURI;

    // =============================================================
    //                          CONSTRUCTOR
    // =============================================================

    /**
     * @dev Initializes the contract by setting `name`、`symbol`、`properties`、`encryptedKeyIDs`
     * and `baseURI` to the token collection.
     *
     * For example,
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory baseURI_
    ) ERC721(name_, symbol_) {
        setBaseURI(baseURI_);
        _allPropertyNames = properties;
        for (uint256 i = 0; i < encryptedKeyIDs.length; ++i) {
            _encryptedKeyIDs.add(encryptedKeyIDs[i]);
        }
    }

    // =============================================================
    //                            IERC165
    // =============================================================

    /**
     * @dev See {IERC165-supportsInterface}
     * IERC721        : 0x80ac58cd
     * IEVTEncryption : 0x254ee5e2
     * IEVTVariable   : 0xa6bdcdff
     * IEVTMetadata   : 0x02ba7d9a
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721, EVTVariable, EVTEncryption)
        returns (bool)
    {
        return
            interfaceId == type(IEVT).interfaceId ||
            interfaceId == type(IEVTMetadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // =============================================================
    //                        URI OPERATIONS
    // =============================================================

    /**
     * @dev Return the Contract Address.
     */
    function from() external view override returns (address) {
        return address(this);
    }

    /**
     * @dev Set the baseURI.
     *
     * Requirements:
     *
     * - `msg.sender` must be the owner of the contract.
     */
    function setBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    /**
     * @dev See {IEVTMetadata-contractURI}.
     */
    function contractURI()
        public
        view
        virtual
        override
        returns (string memory)
    {
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
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, IEVTMetadata)
        returns (string memory)
    {
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(
                            abi.encodePacked(
                                '{"baseURI":',
                                '"',
                                baseURI,
                                '"',
                                ',"properties":',
                                getDynamicPropertiesAsString(tokenId),
                                ","
                                '"encryption":',
                                getPermissionsAsString(tokenId),
                                "}"
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
                                ",",
                                '"encryption":',
                                getPermissionsAsString(tokenId),
                                "}"
                            )
                        )
                    )
                );
    }

    /**
     * @dev See {IEVTMetadata-variableURI}.
     */
    function variableURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"properties":',
                            getDynamicPropertiesAsString(tokenId),
                            "}"
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    /**
     * @dev See {IEVTMetadata-encryptionURI}.
     */
    function encryptionURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"encryption":',
                            getPermissionsAsString(tokenId),
                            "}"
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    // =============================================================
    //                     Property OPERATIONS
    // =============================================================

    /**
     * @dev See {IEVT-addDynamicProperty}.
     */
    function addDynamicProperty(string memory propertyName)
        public
        virtual
        override(IEVTVariable, EVTVariable)
        onlyOwner
    {
        EVTVariable.addDynamicProperty(propertyName);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperty}.
     */
    function setDynamicProperty(
        uint256 tokenId,
        string memory propertyName,
        string memory propertyValue
    ) public payable virtual override(IEVTVariable, EVTVariable) {
        require(msg.sender == ownerOf(tokenId), "not token owner");
        EVTVariable.setDynamicProperty(tokenId, propertyName, propertyValue);
    }

    /**
     * @dev See {IEVTVariable-setDynamicProperties}.
     */
    function setDynamicProperties(
        uint256 tokenId,
        string[] memory propertyNames,
        string[] memory propertyValues
    ) public payable virtual override(IEVTVariable, EVTVariable) {
        require(msg.sender == ownerOf(tokenId), "not token owner");
        EVTVariable.setDynamicProperties(
            tokenId,
            propertyNames,
            propertyValues
        );
    }

    /**
     * @dev See {IEVT-getDynamicPropertiesAsString}.
     */
    function getDynamicPropertiesAsString(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string[] memory args = _getDynamicPropertiesArray(tokenId);
        string memory res = GetString.getStringData(args);
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
    function _getDynamicPropertiesArray(uint256 tokenId)
        private
        view
        returns (string[] memory)
    {
        _requireMinted(tokenId);
        (string[] memory property_names, string[] memory values) = EVTVariable
            .getDynamicProperties(tokenId);
        require(property_names.length == values.length, "length error");
        string[] memory properties = new string[](property_names.length);
        for (uint256 i = 0; i < property_names.length; ++i) {
            string memory trait_name = property_names[i];
            string memory args = string(
                abi.encodePacked('{"property_name":"', trait_name, '","value":')
            );
            args = string(abi.encodePacked(args, '"', values[i], '"'));

            args = string(abi.encodePacked(args, "}"));
            properties[i] = string(args);
        }
        return properties;
    }

    // =============================================================
    //                   Encryption OPERATIONS
    // =============================================================

    /**
     * @dev See {IEVTEncryption-registerEncryptedKey}.
     */
    function registerEncryptedKey(bytes32 encryptedKeyID)
        public
        virtual
        override(IEVTEncryption, EVTEncryption)
        onlyOwner
    {
        EVTEncryption.registerEncryptedKey(encryptedKeyID);
    }

    /**
     * @dev See {IEVTEncryption-registerEncryptedKey}.
     */
    function addPermission(
        uint256 tokenId,
        bytes32 encryptedKeyID,
        address licensee
    ) public payable virtual override(IEVTEncryption, EVTEncryption) {
        require(msg.sender == ownerOf(tokenId), "not token owner");
        EVTEncryption.addPermission(tokenId, encryptedKeyID, licensee);
    }

    /**
     * @dev See {IEVTEncryption-removePermission}.
     */
    function removePermission(
        uint256 tokenId,
        bytes32 encryptedKeyID,
        address licensee
    ) public virtual override(IEVTEncryption, EVTEncryption) {
        require(msg.sender == ownerOf(tokenId), "not token owner");
        EVTEncryption.removePermission(tokenId, encryptedKeyID, licensee);
    }

    /**
     * @dev See {IEVTEncryption-hasPermission}.
     */
    function hasPermission(
        uint256 tokenId,
        bytes32 encryptedKeyID,
        address licensee
    )
        public
        view
        virtual
        override(IEVTEncryption, EVTEncryption)
        returns (bool)
    {
        if (msg.sender == ownerOf(tokenId) && msg.sender == licensee) {
            return true;
        }
        return EVTEncryption.hasPermission(tokenId, encryptedKeyID, licensee);
    }

    /**
     * @dev See {IEVT-getPermissionsAsString}.
     */
    function getPermissionsAsString(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string[] memory args = _getPermissionsArray(tokenId);
        string memory res = GetString.getStringData(args);
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
    function _getPermissionsArray(uint256 tokenId)
        private
        view
        returns (string[] memory)
    {
        _requireMinted(tokenId);
        uint256 len = _tokenKeyIDs[tokenId].length();
        string[] memory permissions = new string[](len);
        for (uint256 i = 0; i < len; ++i) {
            bytes32 encryptionKeyId = _tokenKeyIDs[tokenId].at(i);
            address[] memory license = EVTEncryption.getPermissions(
                tokenId,
                encryptionKeyId
            );
            string memory args = string(
                abi.encodePacked(
                    '{"encryptionKeyId":',
                    '"',
                    GetString.toString(abi.encodePacked(encryptionKeyId)),
                    '"',
                    ',"license":'
                )
            );
            string[] memory stringLicense = new string[](license.length);
            for (uint256 j = 0; j < license.length; ++j) {
                stringLicense[j] = GetString.toString(
                    abi.encodePacked(license[j])
                );
                stringLicense[j] = string(
                    abi.encodePacked('"', stringLicense[j], '"')
                );
            }
            string memory data = GetString.getStringData(stringLicense);
            args = string(abi.encodePacked(args, data));
            args = string(abi.encodePacked(args, "}"));

            permissions[i] = args;
        }
        return permissions;
    }
}
