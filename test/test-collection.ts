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
      await collectionContract["safeMint(address,uint256)"](ownerAddr, 2);
      const baseUri = "https://www.newtonproject.org";
      await collectionContract.updateBaseURI(baseUri);
      expect(await collectionContract.baseURI()).to.equal(baseUri);
      expect(await collectionContract.isOwnCollection(0, ownerAddr)).to.equal(
        true
      );
      expect(await collectionContract.isOwnCollection(0, pubAddr)).to.equal(
        false
      );

      console.log("\n");
      console.log(await collectionContract.tokenURI(tokenId));

      const uri0 =
        '{"name":"Lucky Generation 0","description":"Lucky Generation...","image":"ifps://.../1.png","version":"0.2","type":"music","playlist":[{"path":"....","cid":"ipfs://...","running_time":240}],"expire_date":"2052-12-01T00undefined00","attributes":[{"trait_type":"Background","value":"Grey Blue"}]}';
      const uri1 =
        '{"name":"Lucky Generation 1","description":"Lucky Generation...","image":"ifps://.../1.png","version":"0.2","type":"music","playlist":[{"path":"....","cid":"ipfs://...","running_time":240}],"expire_date":"2052-12-01T00undefined00","attributes":[{"trait_type":"Background","value":"Grey Blue"}]}';
      const uri2 =
        '{"name":"Lucky Generation 2","description":"Lucky Generation...","image":"ifps://.../1.png","version":"0.2","type":"music","playlist":[{"path":"....","cid":"ipfs://...","running_time":240}],"expire_date":"2052-12-01T00undefined00","attributes":[{"trait_type":"Background","value":"Grey Blue"}]}';
      const uri3 =
        '{"name":"Lucky Generation 3","description":"Lucky Generation...","image":"ifps://.../1.png","version":"0.2","type":"music","playlist":[{"path":"....","cid":"ipfs://...","running_time":240}],"expire_date":"2052-12-01T00undefined00","attributes":[{"trait_type":"Background","value":"Grey Blue"}]}';
        const uri4 =
        '{"name":"Lucky Generation 4","description":"Lucky Generation...","image":"ifps://.../1.png","version":"0.2","type":"music","playlist":[{"path":"....","cid":"ipfs://...","running_time":240}],"expire_date":"2052-12-01T00undefined00","attributes":[{"trait_type":"Background","value":"Grey Blue"}]}';
        const uri5 =
        '{"name":"Lucky Generation 5","description":"Lucky Generation...","image":"ifps://.../1.png","version":"0.2","type":"music","playlist":[{"path":"....","cid":"ipfs://...","running_time":240}],"expire_date":"2052-12-01T00undefined00","attributes":[{"trait_type":"Background","value":"Grey Blue"}]}';
      

      await collectionContract.updateTokenURIStorage(tokenId,uri0)
      await collectionContract.updateTokenURIStorage(tokenId1, uri1)
      await collectionContract["safeMint(address,string[])"](ownerAddr, [
        uri2,
        uri3,
        uri4,
      ]);

      expect(await collectionContract.tokenURIStorage(2)).to.equal(uri2);
      expect(await collectionContract.tokenURIStorage(3)).to.equal(uri3);
      expect(await collectionContract.tokenURIStorage(4)).to.equal(uri4);
    });
  });
});
