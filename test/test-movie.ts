import { expect } from "chai";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { Movie } from "../typechain-types/contracts/evt-factory/movie/Movie";

var owner: Signer;
var movieOwner: Signer;
var pub: Signer;
var ownerAddr: string;
var movieOwnerAddr: string;
var pubAddr: string;

var movieContract: Movie;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;
const encryptedKeyID =
  "0x0de230ce2aaa10a37b6249daabc590268183aa1a6e3d7c601692d01922f91ea9";

describe("Movie", function () {
  beforeEach(async () => {
    owner = (await ethers.getSigners())[0];
    movieOwner = (await ethers.getSigners())[1];
    pub = (await ethers.getSigners())[2];
    ownerAddr = await owner.getAddress();
    movieOwnerAddr = await movieOwner.getAddress();
    pubAddr = await pub.getAddress();

    const LibGetString = await ethers.getContractFactory("GetString");
    const libGetString = await LibGetString.deploy();
    await libGetString.deployed();
    console.log("LibGetString deployed success");

    const Movie = await ethers.getContractFactory("Movie", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    movieContract = await Movie.deploy("name_", "symbol_", [], [], baseUri);
    await movieContract.deployed();
    console.log("MovieContract deployed success");
  });

  describe("Movie:", function () {
    it("Movie Test: ", async function () {
      await movieContract["safeMint(address,uint256)"](ownerAddr, 2);
      const baseUri = "https://www.newtonproject.org";
      await movieContract.updateBaseURI(baseUri);
      expect(await movieContract.baseURI()).to.equal(baseUri);
      expect(await movieContract.isOwn(0, ownerAddr)).to.equal(true);
      expect(await movieContract.isOwn(0, pubAddr)).to.equal(false);

      console.log("\n");
      console.log(await movieContract.tokenURI(tokenId));

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

      await movieContract.updateTokenURIStorage(tokenId, uri0);
      await movieContract.updateTokenURIStorage(tokenId1, uri1);
      await movieContract["safeMint(address,string[])"](ownerAddr, [
        uri2,
        uri3,
        uri4,
      ]);

      expect(await movieContract.tokenURIStorage(2)).to.equal(uri2);
      expect(await movieContract.tokenURIStorage(3)).to.equal(uri3);
      expect(await movieContract.tokenURIStorage(4)).to.equal(uri4);
    });

    it("Movie Copyright: ", async function () {
      await movieContract.registerEncryptedKey(encryptedKeyID);
      await movieContract["safeMint(address,uint256)"](movieOwnerAddr, 1);

      await movieContract
        .connect(movieOwner)
        .addPermission(tokenId, encryptedKeyID, movieOwnerAddr);

      let startTime = Date.parse(new Date().toString()) / 1000;
      let endTime = startTime + 31 * 24 * 60 * 60;

      await movieContract.updateStartTime(startTime);
      expect(await movieContract.startTime()).to.equal(startTime);

      await movieContract.updateEndTime(endTime);
      expect(await movieContract.endTime()).to.equal(endTime);

      expect(
        await movieContract.hasPermission(tokenId, encryptedKeyID, ownerAddr)
      ).to.equal(false);

      expect(
        await movieContract
          .connect(movieOwner)
          .hasPermission(tokenId, encryptedKeyID, movieOwnerAddr)
      ).to.equal(true);
    });
  });
});
