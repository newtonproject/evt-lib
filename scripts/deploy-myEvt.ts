import { ethers } from "hardhat";

async function main() {
  const MyEvt = await ethers.getContractFactory("MyEVT");
  const myEvt = await MyEvt.deploy("name_", "symbol_","logo", ["property"], "baseUri");

  await myEvt.deployed();

  console.log("MyEvt deployed");
  console.log("MyEvt address: "+myEvt.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
