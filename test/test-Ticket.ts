import { expect } from "chai";
import { ethers } from "hardhat";
import { Movie } from "../typechain-types/contracts/evt-factory/Movie/Movie";
import { Ticket } from "../typechain-types/contracts/evt-factory/Ticket/Ticket";

var owner;
var movieOwner;
var ticketOwner;
var payee;
var pub;
var ownerAddr: string;
var movieOwnerAddr: string;
var ticketOwnerAddr: string;
var payeeAddr: string;
var pubAddr: string;
var movieContract: Movie;
var ticketContract: Ticket;
var baseUri = "https://www.newtonproject.org/en/";
var tokenId = 0;
var tokenId1 = 1;

describe("Ticket", function () {
  beforeEach(async () => {
    owner = (await ethers.getSigners())[0];
    movieOwner = (await ethers.getSigners())[1];
    ticketOwner = (await ethers.getSigners())[2];
    payee = (await ethers.getSigners())[3];
    pub = (await ethers.getSigners())[4];
    ownerAddr = await owner.getAddress();
    movieOwnerAddr = await movieOwner.getAddress();
    ticketOwnerAddr = await ticketOwner.getAddress();
    payeeAddr = await payee.getAddress();
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

    const Ticket = await ethers.getContractFactory("Ticket", {
      libraries: {
        GetString: libGetString.address,
      },
    });
    ticketContract = await Ticket.deploy(
      "name_",
      "symbol_",
      [],
      [],
      baseUri,
      movieContract.address,
      1668492557,
      31 * 24 * 60 * 60,
      24 * 60 * 60
    );
    await ticketContract.deployed();
    console.log("TicketContract deployed success");
  });

  describe("Ticket:", function () {
    it("Ticket Test: ", async function () {
      await movieContract.safeMint(movieOwnerAddr, 5);

      const uri = "https://www.newtonproject.org";
      await ticketContract.updateBaseURI(uri);
      expect(await ticketContract.baseURI()).to.equal(uri);

      const time1Movie = 30 * 24 * 60 * 60;
      await ticketContract.updateMovieDuration(time1Movie);
      expect(await ticketContract.movieDuration()).to.equal(time1Movie);

      const time2Ticket = 3 * 24 * 60 * 60;
      await ticketContract.updateTicketDuration(time2Ticket);
      expect(await ticketContract.ticketDuration()).to.equal(time2Ticket);

      // expect(await ticketContract.getPayee()).to.equal(addr);
      // await ticketContract.updatePayee(addr1);
      // expect(await ticketContract.getPayee()).to.equal(addr1);

      // await ticketContract.safeMint(addr, 5, 0);
      // await ticketContract.safeMint(addr, 5, 5).catch((error) => {
      //   expect(error.message).to.include("not movie owner");
      // });

      // await ticketContract.connect().checkTicket(tokenId);
    });
  });
});
