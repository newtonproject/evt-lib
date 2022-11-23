import { expect } from "chai";
import { ethers } from "hardhat";
import { MyEVT } from "../typechain-types";

var signers;
var addr: string;
var addr1: string;
var myEvtContract: MyEVT;
var propertyType = "looooooooooooooooooooooooooooooooooooogPropertyType";
var propertyType2 = "looooooooooooooooooooooooooooooooooooogPropertyType2";
var tokenId = 0;
// var tokenId1 = 1;
const encryptedKeyID =
  "0x0de230ce2aaa10a37b6249daabc590268183aa1a6e3d7c601692d01922f91ea9";

describe("MyEVT", function () {
  beforeEach(async () => {
    signers = await ethers.getSigners();
    addr = await signers[0].getAddress();
    addr1 = await signers[1].getAddress();
    const LibGetString = await ethers.getContractFactory("GetString");
    const libGetString = await LibGetString.deploy();
    await libGetString.deployed();
    console.log("LibGetString deployed success");

    const MyEvt = await ethers.getContractFactory("MyEVT", {
      libraries: {
        GetString: libGetString.address,
      },
    });

    myEvtContract = await MyEvt.deploy(
      "EvtName",
      "EvtSymbol",
      "Evtlogo",
      ["0", "1", "2", propertyType],
      ["0x5860a61b005f7c13da7506c2f79f546acc5b197ca30bef91905268d30d6ff475"],
      "newBaseURI"
    );

    await myEvtContract.deployed();
    console.log("EVT deployed success");

    await myEvtContract.registerEncryptedKey(encryptedKeyID);
    await myEvtContract["safeMint(address)"](addr);
  });

  describe("MyEvt:", function () {
    it("MyEvt Test: ", async function () {
      const from = await myEvtContract.from();
      console.log("from: " + from);
      const baseUri = "https://www.newtonproject.org/en/";
      await myEvtContract.setBaseURI(baseUri);
      const propertyValue = "18";
      const contractURI = await myEvtContract.contractURI();
      console.log("contractURI: " + contractURI);

      expect(await myEvtContract.logo()).to.equal("Evtlogo");

      //##############################EVTVariable##############################
      await myEvtContract.setDynamicProperty(
        tokenId,
        propertyType,
        propertyValue
      );

      expect(
        await myEvtContract.getDynamicPropertyValue(tokenId, propertyType)
      ).to.equal(propertyValue);

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

      console.log(
        "getAllSupportProperties: " +
          (await myEvtContract.getAllSupportProperties())
      );

      console.log("\n");
      console.log("variableURI: " + (await myEvtContract.variableURI(tokenId)));

      //##############################EVTEncryption##############################

      const licensee = "0xDa4D32877a70f3A4490008Df66F2DD988451a431";
      const errLicensee = "0x6cA3F330D3488A6157A88b7E3C240C40C16D1Df8";

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

      expect(
        await myEvtContract.hasPermission(tokenId, encryptedKeyID, licensee)
      ).to.equal(true);

      expect(
        await myEvtContract.hasPermission(tokenId, encryptedKeyID, errLicensee)
      ).to.equal(false);

      console.log("\n");
      console.log(
        "encryptionURI: " + (await myEvtContract.encryptionURI(tokenId))
      );

      //##############################tokenURI##############################
      console.log("\n");
      console.log("tokenURI: " + (await myEvtContract.tokenURI(tokenId)));
    });

    it("MyEvt supportsInterface: ", async function () {
      //IERC721
      expect(await myEvtContract.supportsInterface("0x80ac58cd")).to.equal(
        true
      );

      //IEVTMetadata
      expect(await myEvtContract.supportsInterface("0x02ba7d9a")).to.equal(
        true
      );

      //IEVTEncryption
      expect(await myEvtContract.supportsInterface("0x254ee5e2")).to.equal(
        true
      );

      //IEVTVariable
      expect(await myEvtContract.supportsInterface("0xa6bdcdff")).to.equal(
        true
      );
    });
  });
});
