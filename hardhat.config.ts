import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { resolve } from "path";
import { config as dotenvConfig } from "dotenv";
import "solidity-coverage";
import "hardhat-gas-reporter";

dotenvConfig({ path: resolve(__dirname, "./.env") });

// Ensure that we have all the environment variables we need.
const infuraApiKey: string = process.env.INFURA_API_KEY || "";
const etherscanApiKey: string = process.env.ETHERSCAN_API_KEY || "";
const newChainApiKey: string = process.env.NEWCHAIN_API_KEY || "";


const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  gasReporter: {
    currency: "USD",
    enabled: false,
  },

  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    newchaintest: {
      chainId: 1007,
      url: "https://rpc1.newchain.newtonproject.org",
      accounts: [
        newChainApiKey,
      ],
      gas: 300000000000,
    },
    newchaintest1: {
      chainId: 1007,
      url: "https://rpc6.newchain.cloud.diynova.com",
      accounts: [
        newChainApiKey,
      ],
      gas: 300000000000,
    },
    newchainmain: {
      chainId: 1012,
      url: "https://cn.rpc.mainnet.diynova.com",
      accounts: [
        newChainApiKey,
      ],
      gas: 300000000000,
    },
    sepolia: {
      chainId: 11155111,
      url: "https://sepolia.infura.io/v3/"+infuraApiKey,
      accounts: [
        etherscanApiKey,
      ],
      gas: 300000000000,
    },
  },
};

export default config;
