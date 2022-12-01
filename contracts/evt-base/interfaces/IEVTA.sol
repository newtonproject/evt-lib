// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../../erc721a/IERC721A.sol";
import "./IEVTVariable.sol";
import "./IEVTEncryption.sol";

interface IEVTA is IERC721A, IEVTVariable, IEVTEncryption {}
