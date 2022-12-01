// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IEVTVariable.sol";
import "./IEVTEncryption.sol";

interface IEVT is IERC721, IEVTEncryption, IEVTVariable {}
