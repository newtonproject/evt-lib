import { expect } from "chai";
import { ethers } from "hardhat";
import { Movie } from "../typechain-types/contracts/evt-factory/movie/Movie";

var owner;
var movieOwner;
var pub;
var ownerAddr: string;
var movieOwnerAddr: string;
var pubAddr: string;

var movieContract: Movie;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;

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
    movieContract = await Movie.deploy(
      "name_",
      "symbol_",
      [],
      [],
      baseUri
    );
    await movieContract.deployed();
    console.log("MovieContract deployed success");
  });

  describe("Movie:", function () {
    it("Movie Test: ", async function () {
      await movieContract["safeMint(address,uint256)"](ownerAddr, 2);
      const baseUri = "https://www.newtonproject.org";
      await movieContract.updateBaseURI(baseUri);
      expect(await movieContract.baseURI()).to.equal(baseUri);
      expect(await movieContract.isOwn(0, ownerAddr)).to.equal(
        true
      );
      expect(await movieContract.isOwn(0, pubAddr)).to.equal(
        false
      );

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
      

      await movieContract.updateTokenURIStorage(tokenId,uri0)
      await movieContract.updateTokenURIStorage(tokenId1, uri1)
      await movieContract["safeMint(address,string[])"](ownerAddr, [
        uri2,
        uri3,
        uri4,
      ]);

      expect(await movieContract.tokenURIStorage(2)).to.equal(uri2);
      expect(await movieContract.tokenURIStorage(3)).to.equal(uri3);
      expect(await movieContract.tokenURIStorage(4)).to.equal(uri4);
    });
  });
});
