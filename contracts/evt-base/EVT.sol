// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IEVT.sol";
import "./extensions/EVTVariable.sol";

/**
 * @dev Implementation of Encrypted Variable Token Standard (NRC-53).
 */
contract EVT is ERC165, ERC721, EVTVariable, IEVT {

    mapping(bytes32 => string) private _properties;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    /**
     * @dev See {IERC165-supportsInterface}.
     * IEVTVariable: 0xcd401ba7
     * IERC721: 0x80ac58cd
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165, ERC721, EVTVariable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
