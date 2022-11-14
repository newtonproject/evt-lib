import { ethers } from "hardhat";

async function main() {
  const GetString = await ethers.getContractFactory("GetString");
  const getString = await GetString.deploy();

  await getString.deployed();

  console.log("getString deployed");
  console.log("getString address: "+getString.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
