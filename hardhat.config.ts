import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "solidity-coverage"
import "hardhat-gas-reporter"

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.3",
    settings: {
        optimizer: {
            enabled: true,
            runs: 200,
        },
    }
  },
  gasReporter: {
    currency: "USD",
    enabled: false
  },
};

export default config;
