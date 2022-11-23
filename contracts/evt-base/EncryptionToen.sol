// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./extensions/EVTEncryption.sol";
import "../libraries/GetString.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard.
 * https://neps.newtonproject.org/neps/nep-53/
 */
contract EncryptionToen is
    IERC721,
    IEVTEncryption,
    ERC721,
    Ownable,
    EVTEncryption
{
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // Point to the EVT offchain data
    string public baseURI;

    // =============================================================
    //                          CONSTRUCTOR
    // =============================================================

    /**
     * @dev Initializes the contract by setting `name`、`symbol`、`encryptedKeyIDs`
     * and `baseURI` to the token collection.
     *
     * For example,
     */
    constructor(
        string memory name_,
        string memory symbol_,
        bytes32[] memory encryptedKeyIDs,
        string memory baseURI_
    ) ERC721(name_, symbol_) {
        setBaseURI(baseURI_);
        for (uint256 i = 0; i < encryptedKeyIDs.length; ++i) {
            _encryptedKeyIDs.add(encryptedKeyIDs[i]);
        }
    }

    // =============================================================
    //                            IERC165
    // =============================================================

    /**
     * @dev See {IERC165-supportsInterface}
     * IEVTVariable   : 0x6af74b02
     * IEVTEncryption : 0xd28afde2
     * IERC721        : 0x80ac58cd
     * IEVTMetadata   : todo
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721, EVTEncryption)
        returns (bool)
    {
        return
            interfaceId == type(IEVTEncryption).interfaceId ||
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
                                '{"encryption":',
                                getPermissionsAsString(tokenId),
                                "}"
                            )
                        )
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
