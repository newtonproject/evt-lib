# EVT-LIB

Full spec: [https://neps.newtonproject.org/neps/nep-53/](https://neps.newtonproject.org/neps/nep-53/)

**Library for EVT development.**

- Standard implementation of EVT
- Example contracts for using EVT
- Factory for EVT industry application

## Overview

### Installation

```bash
$ npm install @newton-protocol/evt-lib
```

### Usage

#### Use evt-base

1. EVT

```solidity
// SPDX-License-Identifier: GPLv3
pragma solidity ^0.8.9;

import "@newton-protocol/evt-lib/contracts/evt-base/EVT.sol";

contract MyEVT is EVT {
    string private _logo;
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
}
```

2. EVTA

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@newton-protocol/evt-lib/contracts/evt-base/EVTA.sol";

contract MyEVTA is EVTA {
    constructor(
        string memory name_,
        string memory symbol_,
        string[] memory properties,
        bytes32[] memory encryptedKeyIDs,
        string memory _newBaseURI,
        uint256 maxBatchSize_,
        uint256 collectionSize_
    )
        EVTA(
            name_,
            symbol_,
            properties,
            encryptedKeyIDs,
            _newBaseURI,
            maxBatchSize_,
            collectionSize_
        )
    {}
}
```

#### Run evt-examples

1. Install dependencies

   ```bash
   # you shoule install node. see https://nodejs.org/en/
   npm install
   ```

2. deploy & compile contract with hardhat

   ```bash
   # compile contracts
   npx hardhat compile

   # run local network, get test address
   npx hardhat node

   # deploy contract
   npx hardhat run --network localhost scripts/deploy-myEvt.ts
   # you can get Transaction hash, Contract address,
   # From address, Gas used etc. in your terminal console

   # you can also get accounts by run tasks
   npx hardhat run tasks/accounts.ts
   ```

3. run test script for MyEVT.sol
   ```bash
   # run test script
   npx hardhat test test/test-myevt.ts
   ```

## License

EVT is released under the GPLv3 License.
