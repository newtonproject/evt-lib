// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "erc721a/contracts/IERC721A.sol";
import "./interfaces/IEVTVariable.sol";
import "./interfaces/IEVTEncryption.sol";

interface IEVTA is IERC721A, IEVTVariable, IEVTEncryption  {
 
}