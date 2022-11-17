import { expect } from "chai";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { Movie } from "../typechain-types/contracts/evt-factory/Movie/Movie";
import { Ticket } from "../typechain-types/contracts/evt-factory/Ticket/Ticket";

var owner: Signer;
var movieOwner: Signer;
var ticketOwner: Signer;
var payee: Signer;
var pub: Signer;
var ownerAddr: string;
var movieOwnerAddr: string;
var ticketOwnerAddr: string;
var payeeAddr: string;
var pubAddr: string;
var movieContract: Movie;
var ticketContract: Ticket;
var baseUri = "https://www.newtonproject.org/en/";
var errExp = new Error("No expected error occurred");
var startTime = Date.parse(new Date().toString()) / 1000;
var endTime = startTime + 31 * 24 * 60 * 60;
var ticketDuration = 24 * 60 * 60;

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
    movieContract = await Movie.deploy("name_", "symbol_", [], [], baseUri);
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
      startTime,
      endTime,
      ticketDuration
    );
    await ticketContract.deployed();
    console.log("TicketContract deployed success");
  });

  describe("Ticket:", function () {
    it("Ticket Test: ", async function () {
      const uri = "https://www.newtonproject.org";
      await ticketContract.updateBaseURI(uri);
      expect(await ticketContract.baseURI()).to.equal(uri);

      const startTime = Date.parse(new Date().toString()) / 1000 + 24 * 60 * 60;
      await ticketContract.updateStartTime(startTime);
      expect(await ticketContract.startTime()).to.equal(startTime);

      const endTime =
        Date.parse(new Date().toString()) / 1000 + 7 * 24 * 60 * 60;
      await ticketContract.updateEndTime(endTime);
      expect(await ticketContract.endTime()).to.equal(endTime);

      const ticketDuration = 3 * 24 * 60 * 60;
      await ticketContract.updateTicketDuration(ticketDuration);
      expect(await ticketContract.ticketDuration()).to.equal(ticketDuration);
    });

    it("Ticket Payee: ", async function () {
      await ticketContract.updatePayee(payeeAddr);
      expect(await ticketContract.getPayee()).to.equal(payeeAddr);

      await ticketContract.connect(owner).withdraw();
      await ticketContract.connect(payee).withdraw();
      await ticketContract
        .connect(pub)
        .withdraw()
        .then(() => {
          throw errExp;
        })
        .catch((error) => {
          expect(error.message).to.include("no access");
        });
    });

    it("Ticket safeMint: ", async function () {
      await movieContract.safeMint(movieOwnerAddr, 5);
      await ticketContract.connect(movieOwner).safeMint(ticketOwnerAddr, 5, 0);
      await ticketContract
        .connect(owner)
        .safeMint(ticketOwnerAddr, 5, 0)
        .then(() => {
          throw errExp;
        })
        .catch((error) => {
          expect(error.message).to.include("not movie owner");
        });
      await ticketContract
        .connect(movieOwner)
        .safeMint(ticketOwnerAddr, 5, 5)
        .then(() => {
          throw errExp;
        })
        .catch((error) => {
          expect(error.message).to.include("ERC721: invalid token ID");
        });
      await ticketContract
        .connect(ticketOwner)
        .safeMint(ticketOwnerAddr, 5, 0)
        .then(() => {
          throw errExp;
        })
        .catch((error) => {
          expect(error.message).to.include("not movie owner");
        });
      await ticketContract
        .connect(pub)
        .safeMint(ticketOwnerAddr, 5, 0)
        .then(() => {
          throw errExp;
        })
        .catch((error) => {
          expect(error.message).to.include("not movie owner");
        });
    });

    it("Ticket checkTicket: ", async function () {
      await movieContract.safeMint(movieOwnerAddr, 5);
      await ticketContract.connect(movieOwner).safeMint(ticketOwnerAddr, 5, 0);
      await ticketContract.connect(ticketOwner).checkTicket(0);
      await ticketContract.connect(ticketOwner).checkTicket(0);

      await ticketContract.connect(ticketOwner).checkTicket(1);
      await ticketContract.connect(ticketOwner).checkTicket(1);

      await ticketContract
        .connect(ticketOwner)
        .checkTicket(5)
        .then(() => {
          throw errExp;
        })
        .catch((error) =>
          expect(error.message).to.include("ERC721: invalid token ID")
        );

      await ticketContract
        .connect(owner)
        .checkTicket(0)
        .then(() => {
          throw errExp;
        })
        .catch((error) => expect(error.message).to.include("not ticket owner"));

      const endTime = Date.parse(new Date().toString()) / 1000 - 60;
      await ticketContract.updateEndTime(endTime);

      await ticketContract
        .connect(ticketOwner)
        .checkTicket(0)
        .then(() => {
          throw errExp;
        })
        .catch((error) =>
          expect(error.message).to.include("already off the screen")
        );

      const startTime = Date.parse(new Date().toString()) / 1000 + 24 * 60 * 60;
      await ticketContract.updateStartTime(startTime);

      await ticketContract
      .connect(ticketOwner)
      .checkTicket(0)
      .then(() => {
        throw errExp;
      })
      .catch((error) =>
        expect(error.message).to.include("not on the screen")
      );
    });

    it("Ticket commonInfo: ", async function () {
      const [movieAddr_, startTime_, endTime_, ticketDuration_, baseUri_] =
        await ticketContract.commonInfo();

      expect([
        movieAddr_,
        startTime_.toNumber(),
        endTime_.toNumber(),
        ticketDuration_.toNumber(),
        baseUri_,
      ]).to.eql([
        movieContract.address,
        startTime,
        endTime,
        ticketDuration,
        baseUri,
      ]);
    });
    it("Ticket ticketInfo: ", async function () {
      await movieContract.safeMint(movieOwnerAddr, 5);
      await ticketContract.connect(movieOwner).safeMint(ticketOwnerAddr, 5, 0);

      await ticketContract
        .ticketInfo(5)
        .then(() => {
          throw errExp;
        })
        .catch((error) => expect(error.message).to.include("not exist"));

      let [
        movieAddr_,
        startTime_,
        endTime_,
        ticketDuration_,
        baseUri_,
        checkingTime_,
      ] = await ticketContract.ticketInfo(0);

      expect([
        movieAddr_,
        startTime_.toNumber(),
        endTime_.toNumber(),
        ticketDuration_.toNumber(),
        baseUri_,
        checkingTime_.toNumber(),
      ]).to.eql([
        movieContract.address,
        startTime,
        endTime,
        ticketDuration,
        baseUri,
        0,
      ]);

      await ticketContract.connect(ticketOwner).checkTicket(0);

      [
        movieAddr_,
        startTime_,
        endTime_,
        ticketDuration_,
        baseUri_,
        checkingTime_,
      ] = await ticketContract.ticketInfo(0);
      expect([
        movieAddr_,
        startTime_.toNumber(),
        endTime_.toNumber(),
        ticketDuration_.toNumber(),
        baseUri_,
      ]).to.eql([
        movieContract.address,
        startTime,
        endTime,
        ticketDuration,
        baseUri,
      ]);

      expect(checkingTime_.toNumber()).to.not.equal(0);
      const date = new Date(checkingTime_.toNumber() * 1000); // have to multiply by 1000
      const Y = date.getFullYear() + "-";
      const M =
        (date.getMonth() + 1 < 10
          ? "0" + (date.getMonth() + 1)
          : date.getMonth() + 1) + "-";
      const D = date.getDate() + " ";
      const h = date.getHours() + ":";
      const m = date.getMinutes() + ":";
      const s = date.getSeconds();
      console.log("checkingTime: " + Y + M + D + h + m + s);
    });
  });
});
