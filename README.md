# EVT-LIB

Full spec: [NRC-53](https://neps.newtonproject.org/neps/nep-53/)

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
```solidity
// SPDX-License-Identifier: GPLv3
pragma solidity ^0.8.3;

import "@newton-protocol/evt-lib/contracts/evt-base/EVT.sol";

contract MyToken is EVT {
    constructor() EVT("MyToken", "MT0") {
    }
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
    npx hardhat run --network localhost scripts/deploy-hello-evt.ts
    # you can get Transaction hash, Contract address, 
    # From address, Gas used etc. in your terminal console

    # you can also get accounts by run tasks
    npx hardhat run tasks/accounts.ts
    ```

3. run test script for helloEVT.sol
    ```bash
    # run test script
    npx hardhat test test/test-hello-evt.ts
    ```

## License
EVT is released under the GPLv3 License.
