// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IEVTA.sol";
import "./extensions/EVTVariable.sol";
import "./extensions/EVTEncryption.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard (NRC-53).
 */
contract EVTA is ERC165, ERC721A, IEVTA, EVTVariable, EVTEncryption {

    mapping(bytes32 => string) private _properties;

    constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
    /**
     * @dev See {IERC165-supportsInterface}
     * IEVTVariable   : 0x6af74b02
     * IEVTEncryption : 0xd28afde2
     * IERC721        : 0x80ac58cd
     * IERC721A       : 0xc21b8f28
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC721A, ERC721A, EVTVariable, EVTEncryption) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
