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

```solidity
// SPDX-License-Identifier: GPLv3
pragma solidity ^0.8.3;

import "@newton-protocol/evt-lib/evt-base/EVT.sol";

contract MyToken is EVT {
    constructor() EVT("MyToken", "MT0") {
    }
}
```

## License
EVT is released under the GPLv3 License.
