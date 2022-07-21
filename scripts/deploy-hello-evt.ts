import { ethers } from "hardhat";

async function main() {
    const HelloEVT = await ethers.getContractFactory("HelloEVT");
    const hello = await HelloEVT.deploy("HelloName","H","", "ipfs://logo/", "H Collection", "ipfs://external_url/");

    await hello.deployed();

    console.log("HelloEVT Contract to:", hello.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
