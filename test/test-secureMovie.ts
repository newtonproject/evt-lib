import { expect } from "chai";
import { ethers } from "hardhat";
import { SecureMovie } from "../typechain-types/contracts/evt-factory/Movie/SecureMovie";

var owner;
var movieOwner;
var pub;
var ownerAddr: string;
var movieOwnerAddr: string;
var pubAddr: string;

var secureMovieContract: SecureMovie;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;

describe("SecureMovie", function () {
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

    const SecureMovie = await ethers.getContractFactory("SecureMovie", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    secureMovieContract = await SecureMovie.deploy(
      "name_",
      "symbol_",
      [],
      [],
      baseUri
    );
    await secureMovieContract.deployed();
    console.log("SecureMovieContract deployed success");
  });

  describe("SecureMovie:", function () {
    it("SecureMovie Test: ", async function () {
      await secureMovieContract.safeMint(ownerAddr, 2);
      const uri = "https://www.newtonproject.org";
      await secureMovieContract.updateBaseURI(uri);
      expect(await secureMovieContract.baseURI()).to.equal(uri);
      expect(await secureMovieContract.isOwnerMovie(0, ownerAddr)).to.equal(
        true
      );
      expect(await secureMovieContract.isOwnerMovie(0, pubAddr)).to.equal(
        false
      );
      console.log("\n");
      console.log(await secureMovieContract.tokenURI(tokenId));
    });
  });
});
