import { expect } from "chai";
import { ethers } from "hardhat";
import { Movie } from "../typechain-types/contracts/evt-factory/Movie/Movie";

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
      await movieContract.safeMint(ownerAddr, 2);
      const uri = "https://www.newtonproject.org";
      await movieContract.updateBaseURI(uri);
      expect(await movieContract.baseURI()).to.equal(uri);
      expect(await movieContract.isOwnerMovie(0, ownerAddr)).to.equal(
        true
      );
      expect(await movieContract.isOwnerMovie(0, pubAddr)).to.equal(
        false
      );
      console.log("\n");
      console.log(await movieContract.tokenURI(tokenId));
    });
  });
});
