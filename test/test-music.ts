import { expect } from "chai";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { Music } from "../typechain-types/contracts/evt-factory/music/Music";

var owner: Signer;
var musicOwner: Signer;
var pub: Signer;
var ownerAddr: string;
var musicOwnerAddr: string;
var pubAddr: string;

var musicContract: Music;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;
const encryptedKeyID =
  "0x0de230ce2aaa10a37b6249daabc590268183aa1a6e3d7c601692d01922f91ea9";

describe("Music", function () {
  beforeEach(async () => {
    owner = (await ethers.getSigners())[0];
    musicOwner = (await ethers.getSigners())[1];
    pub = (await ethers.getSigners())[2];
    ownerAddr = await owner.getAddress();
    musicOwnerAddr = await musicOwner.getAddress();
    pubAddr = await pub.getAddress();

    const LibGetString = await ethers.getContractFactory("GetString");
    const libGetString = await LibGetString.deploy();
    await libGetString.deployed();
    console.log("LibGetString deployed success");

    const Music = await ethers.getContractFactory("Music", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    musicContract = await Music.deploy("name_", "symbol_", [], [], baseUri);
    await musicContract.deployed();
    console.log("MusicContract deployed success");
  });

  describe("Music:", function () {
    it("Music Test: ", async function () {
      await musicContract["safeMint(address,uint256)"](ownerAddr, 2);
      const baseUri = "https://www.newtonproject.org";
      await musicContract.updateBaseURI(baseUri);
      expect(await musicContract.baseURI()).to.equal(baseUri);
      expect(await musicContract.isOwn(0, ownerAddr)).to.equal(true);
      expect(await musicContract.isOwn(0, pubAddr)).to.equal(false);

      console.log("\n");
      console.log(await musicContract.tokenURI(tokenId));

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

      await musicContract.updateTokenURIStorage(tokenId, uri0);
      await musicContract.updateTokenURIStorage(tokenId1, uri1);
      await musicContract["safeMint(address,string[])"](ownerAddr, [
        uri2,
        uri3,
        uri4,
      ]);

      expect(await musicContract.tokenURIStorage(2)).to.equal(uri2);
      expect(await musicContract.tokenURIStorage(3)).to.equal(uri3);
      expect(await musicContract.tokenURIStorage(4)).to.equal(uri4);
    });

    it("Music Copyright: ", async function () {
      await musicContract.registerEncryptedKey(encryptedKeyID);
      await musicContract["safeMint(address,uint256)"](musicOwnerAddr, 1);

      await musicContract
        .connect(musicOwner)
        .addPermission(tokenId, encryptedKeyID, musicOwnerAddr);

      let copyrightStartTime = Date.parse(new Date().toString()) / 1000;
      let copyrightEndTime = copyrightStartTime + 31 * 24 * 60 * 60;

      await musicContract.updateCopyrightStartTime(copyrightStartTime);
      expect(await musicContract.copyrightStartTime()).to.equal(
        copyrightStartTime
      );

      await musicContract.updateCopyrightEndTime(copyrightEndTime);
      expect(await musicContract.copyrightEndTime()).to.equal(copyrightEndTime);

      expect(
        await musicContract.hasPermission(tokenId, encryptedKeyID, ownerAddr)
      ).to.equal(false);

      expect(
        await musicContract
          .connect(musicOwner)
          .hasPermission(tokenId, encryptedKeyID, musicOwnerAddr)
      ).to.equal(true);
    });
  });
});
