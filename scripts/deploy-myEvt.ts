import { ethers } from "hardhat";

async function main() {
  const GetString = await ethers.getContractFactory("GetString");
  const getString = await GetString.deploy();

  await getString.deployed();

  console.log("getString deployed");
  console.log("getString address: " + getString.address);

  const MyEvt = await ethers.getContractFactory("MyEVT", {
    libraries: {
      GetString: getString.address,
    },
  });
  const myEvt = await MyEvt.deploy(
    "name_",
    "symbol_",
    "logo_",
    ["property"],
    ["0x0de230ce2aaa10a37b6249daabc590268183aa1a6e3d7c601692d01922f91ea9"],
    "baseUri"
  );

  await myEvt.deployed();

  console.log("MyEvt deployed");
  console.log("MyEvt address: " + myEvt.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
