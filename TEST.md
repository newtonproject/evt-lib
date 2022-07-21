### Run with hardhat

1. get source & install

```bash
git clone https://github.com/newtonproject/evt-lib.git && cd evt-lib

## you shoule install node see https://nodejs.org/en/
npm install

```

2. deploy & compile contract with hardhat

```bash
## compile contracts
npx hardhat compile

## run local network, get test address
npx hardhat node

## deploy contract
npx hardhat run --network localhost scripts/deploy-hello-evt.ts
## you can get Transaction hash, Contract address, 
## From address, Gas used etc. in your terminal console

## you can also get accounts by run tasks
npx hardhat run tasks/accounts.ts

```

3. run test script for helloEVT.sol

```bash
## run test script
npx hardhat test test/test-hello-evt.ts
```

