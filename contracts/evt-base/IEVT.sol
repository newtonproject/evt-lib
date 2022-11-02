// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IEVTVariable.sol";
import "./interfaces/IEVTEncryption.sol";

interface IEVT is IERC721, IEVTVariable, IEVTEncryption  {
    
}