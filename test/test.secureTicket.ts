import { expect } from "chai";
import { ethers } from "hardhat";
import { PromiseOrValue } from "../typechain-types/common";
import { SecureMovie } from "../typechain-types/contracts/evt-factory/Movie/SecureMovie";
import { SecureTicket } from "../typechain-types/contracts/evt-factory/Ticket/SecureTicket";

var owner;
var movieOwner;
var ticketOwner;
var pub;
var ownerAddr: string;
var movieOwnerAddr: string;
var ticketOwnerAddr: string;
var pubAddr: string;
var secureMovieContract: SecureMovie;
var secureTicketContract: SecureTicket;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;

describe("SecureTicket", function () {
  beforeEach(async () => {
    owner = (await ethers.getSigners())[0];
    movieOwner = (await ethers.getSigners())[1];
    ticketOwner = (await ethers.getSigners())[2];
    pub = (await ethers.getSigners())[3];
    ownerAddr = await owner.getAddress();
    movieOwnerAddr = await movieOwner.getAddress();
    ticketOwnerAddr = await ticketOwner.getAddress();
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

    const SecureTicket = await ethers.getContractFactory("SecureTicket", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    secureTicketContract = await SecureTicket.deploy(
      "name_",
      "symbol_",
      [],
      [],
      baseUri,
      secureMovieContract.address,
      1668492557,
      31 * 24 * 60 * 60,
      24 * 60 * 60
    );
    await secureTicketContract.deployed();
    console.log("SecureTicketContract deployed success");
  });

  describe("SecureTicket:", function () {
    it("SecureTicket Test: ", async function () {
      await secureMovieContract.safeMint(movieOwnerAddr, 5);

      const uri = "https://www.newtonproject.org";
      await secureTicketContract.updateBaseURI(uri);
      expect(await secureTicketContract.baseURI()).to.equal(uri);

      const time1Movie = 30 * 24 * 60 * 60;
      await secureTicketContract.updateMovieDuration(time1Movie);
      expect(await secureTicketContract.movieDuration()).to.equal(time1Movie);

      const time2Ticket = 3 * 24 * 60 * 60;
      await secureTicketContract.updateTicketDuration(time2Ticket);
      expect(await secureTicketContract.ticketDuration()).to.equal(time2Ticket);

      // expect(await secureTicketContract.getPayee()).to.equal(addr);
      // await secureTicketContract.updatePayee(addr1);
      // expect(await secureTicketContract.getPayee()).to.equal(addr1);

      // await secureTicketContract.safeMint(addr, 5, 0);
      // await secureTicketContract.safeMint(addr, 5, 5).catch((error) => {
      //   expect(error.message).to.include("not movie owner");
      // });

      // await secureTicketContract.connect().checkTicket(tokenId);
    });
  });
});
