import { expect } from "chai";
import { ethers } from "hardhat";
import { Collection } from "../typechain-types/contracts/evt-factory/Collection/Collection";

var owner;
var collectionOwner;
var pub;
var ownerAddr: string;
var collectionOwnerAddr: string;
var pubAddr: string;

var collectionContract: Collection;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;

describe("Collection", function () {
  beforeEach(async () => {
    owner = (await ethers.getSigners())[0];
    collectionOwner = (await ethers.getSigners())[1];
    pub = (await ethers.getSigners())[2];
    ownerAddr = await owner.getAddress();
    collectionOwnerAddr = await collectionOwner.getAddress();
    pubAddr = await pub.getAddress();

    const LibGetString = await ethers.getContractFactory("GetString");
    const libGetString = await LibGetString.deploy();
    await libGetString.deployed();
    console.log("LibGetString deployed success");

    const Collection = await ethers.getContractFactory("Collection", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    collectionContract = await Collection.deploy(
      "name_",
      "symbol_",
      [],
      [],
      baseUri
    );
    await collectionContract.deployed();
    console.log("CollectionContract deployed success");
  });

  describe("Collection:", function () {
    it("Collection Test: ", async function () {
      await collectionContract.safeMint(ownerAddr, 2);
      const uri = "https://www.newtonproject.org";
      await collectionContract.updateBaseURI(uri);
      expect(await collectionContract.baseURI()).to.equal(uri);
      expect(await collectionContract.isOwnCollection(0, ownerAddr)).to.equal(
        true
      );
      expect(await collectionContract.isOwnCollection(0, pubAddr)).to.equal(
        false
      );
      console.log("\n");
      console.log(await collectionContract.tokenURI(tokenId));
    });
  });
});
