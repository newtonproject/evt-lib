import { expect } from "chai";
import { ethers } from "hardhat";
import { Multimedia } from "../typechain-types/contracts/evt-factory/Multimedia/Multimedia";

var owner;
var multimediaOwner;
var pub;
var ownerAddr: string;
var multimediaOwnerAddr: string;
var pubAddr: string;

var multimediaContract: Multimedia;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;

describe("Multimedia", function () {
  beforeEach(async () => {
    owner = (await ethers.getSigners())[0];
    multimediaOwner = (await ethers.getSigners())[1];
    pub = (await ethers.getSigners())[2];
    ownerAddr = await owner.getAddress();
    multimediaOwnerAddr = await multimediaOwner.getAddress();
    pubAddr = await pub.getAddress();

    const LibGetString = await ethers.getContractFactory("GetString");
    const libGetString = await LibGetString.deploy();
    await libGetString.deployed();
    console.log("LibGetString deployed success");

    const Multimedia = await ethers.getContractFactory("Multimedia", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    multimediaContract = await Multimedia.deploy(
      "name_",
      "symbol_",
      [],
      [],
      baseUri
    );
    await multimediaContract.deployed();
    console.log("MultimediaContract deployed success");
  });

  describe("Multimedia:", function () {
    it("Multimedia Test: ", async function () {
      await multimediaContract["safeMint(address,uint256)"](ownerAddr, 2);
      const baseUri = "https://www.newtonproject.org";
      await multimediaContract.updateBaseURI(baseUri);
      expect(await multimediaContract.baseURI()).to.equal(baseUri);
      expect(await multimediaContract.isOwnMultimedia(0, ownerAddr)).to.equal(
        true
      );
      expect(await multimediaContract.isOwnMultimedia(0, pubAddr)).to.equal(
        false
      );

      console.log("\n");
      console.log(await multimediaContract.tokenURI(tokenId));

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
      

      await multimediaContract.updateTokenURIStorage(tokenId,uri0)
      await multimediaContract.updateTokenURIStorage(tokenId1, uri1)
      await multimediaContract["safeMint(address,string[])"](ownerAddr, [
        uri2,
        uri3,
        uri4,
      ]);

      expect(await multimediaContract.tokenURIStorage(2)).to.equal(uri2);
      expect(await multimediaContract.tokenURIStorage(3)).to.equal(uri3);
      expect(await multimediaContract.tokenURIStorage(4)).to.equal(uri4);
    });
  });
});
