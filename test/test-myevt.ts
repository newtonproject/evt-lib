import { ethers } from "hardhat";
import { expect } from "chai";

describe("MyEvt", function () {
  it("MyEvt Test", async function () {
    const signers = await ethers.getSigners();
    const addr = await signers[0].getAddress();

    const LibGetString = await ethers.getContractFactory("GetString");
    const libGetString = await LibGetString.deploy();
    await libGetString.deployed();
    console.log("LibGetString deployed success");

    const MyEvt = await ethers.getContractFactory("MyEVT", {
      signer: signers[0],
      libraries: {
        GetString: libGetString.address,
      },
    });
    const propertyType = "safeMintsafeMintsafeMintsafeMintsafeMint";

    const myEvtContract = await MyEvt.deploy(
      "EvtName",
      "EvtSymbol",
      "Evtlogo",
      ["0", "1", "2", propertyType],
      "newBaseURI"
    );

    await myEvtContract.deployed();
    console.log("EVT deployed success");

    const from = await myEvtContract.from();
    console.log("from: " + from);

    expect(await myEvtContract.baseURI()).to.equal("newBaseURI");

    await myEvtContract.setBaseURI("https://www.baidu.com/");
    expect(await myEvtContract.baseURI()).to.equal("https://www.baidu.com/");

    const tokenId = 0;
    const propertyValue = "18";
    const contractURI = await myEvtContract.contractURI();
    console.log("contractURI: " + contractURI);

    expect(await myEvtContract.logo()).to.equal("Evtlogo");

    await myEvtContract.mint(addr);
    await myEvtContract["safeMint(address)"](addr);

    await myEvtContract.setDynamicProperty(
      tokenId,
      propertyType,
      propertyValue
    );

    expect(
      await myEvtContract.getDynamicPropertyValue(tokenId, propertyType)
    ).to.equal(propertyValue);

    const propertyType2 = "safeMintsafeMintsafeMintsafeMintsafeMint2";
    await myEvtContract.addDynamicProperty(propertyType2);

    const propertyValues = ["20", "180cm"];
    await myEvtContract.setDynamicProperties(
      tokenId,
      [propertyType, propertyType2],
      propertyValues
    );
    console.log(
      "getDynamicPropertiesAsString: " +
        (await myEvtContract.getDynamicPropertiesAsString(tokenId))
    );

    const encryptedKeyID =
      "0x0de230ce2aaa10a37b6249daabc590268183aa1a6e3d7c601692d01922f91ea9";
    const licensee = "0xDa4D32877a70f3A4490008Df66F2DD988451a431";
    const errLicensee = "0x6cA3F330D3488A6157A88b7E3C240C40C16D1Df8";
    await myEvtContract.registerEncryptedKey(encryptedKeyID);
    await myEvtContract.addPermission(tokenId, encryptedKeyID, licensee);
    await myEvtContract.removePermission(tokenId, encryptedKeyID, licensee);
    console.log(
      "getPermissionsAsString: " +
        (await myEvtContract.getPermissionsAsString(tokenId))
    );
    await myEvtContract.addPermission(tokenId, encryptedKeyID, licensee);
    console.log(
      "getPermissionsAsString: " +
        (await myEvtContract.getPermissionsAsString(tokenId))
    );
    console.log(
      "getAllSupportProperties: " +
        (await myEvtContract.getAllSupportProperties())
    );

    console.log("tokenURI: " + (await myEvtContract.tokenURI(tokenId)));
    console.log("variableURI: " + (await myEvtContract.variableURI(tokenId)));
    console.log(
      "encryptionURI: " + (await myEvtContract.encryptionURI(tokenId))
    );

    expect(
      await myEvtContract.hasPermission(tokenId, encryptedKeyID, licensee)
    ).to.equal(true);

    expect(
      await myEvtContract.hasPermission(tokenId, encryptedKeyID, errLicensee)
    ).to.equal(false);
  });

  
});
