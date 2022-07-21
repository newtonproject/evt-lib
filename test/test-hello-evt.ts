import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat";
import { Contract } from "ethers";
import { expect } from "chai";


describe("HelloEVT", function() {
    async function deployHelloEVTFixture() {
        const signers: SignerWithAddress[] = await ethers.getSigners();
        const owner: SignerWithAddress = signers[0];

        const NAME = "HelloName";
        const SYMBOL = "H";
        const IMAGE = "ipfs://logo/";
        const FROM = "H Collection";
        const EXTERNAL_URL = "ipfs://external_url/";

        const HelloEVT = await ethers.getContractFactory("HelloEVT");
        const hello: Contract = await HelloEVT.connect(owner).deploy(NAME, SYMBOL, "", IMAGE, FROM, EXTERNAL_URL);
        await hello.deployed();
    
        return { hello, owner }
    }

    before(async function () {
        this.loadFixture = loadFixture;
    });

    describe("Mint", function(){
        beforeEach(async function () {
            const { hello, owner } = await this.loadFixture(deployHelloEVTFixture);
            this.hello = hello;
            this.owner = await owner.getAddress();
        });
        it("mint token", async function() {
            const signers: SignerWithAddress[] = await ethers.getSigners();
            
            const DESCRIPTION = "The description for EVT";
            const TAX = 100;

            const miner = await signers[1].getAddress();
            await this.hello.safeMint(miner, DESCRIPTION, TAX);
            console.log(`Address ${miner} Mint Token#0`);
        });
    })

    describe("Common Info", function() {
        beforeEach(async function () {
            const { hello, owner } = await this.loadFixture(deployHelloEVTFixture);
            this.hello = hello;
            this.owner = await owner.getAddress();
        });
        it("set base uri", async function() {
            const URI = "new uri";
            await this.hello.setBaseURI(URI);
            expect(await this.hello.baseURI()).to.eq(URI);
        })
        it("set base extension", async function() {
            const EXTENSION = "data:application/json;base64,";
            await this.hello.setBaseExtension(EXTENSION);
            expect(await this.hello.baseExtension()).to.eq(EXTENSION);
        })
        it("get logo", async function() {
            const logo = await this.hello.logo()
            console.log("Logo: " + logo);
        })
        it("get from", async function() {
            const from = await this.hello.from()
            console.log("From: " + from);
        })
        it("get external_url", async function() {
            const external = await this.hello.external_url()
            console.log("External_url: " + external);
        })
    });

    describe("Token Info", function() {
        beforeEach(async function () {
            const { hello } = await this.loadFixture(deployHelloEVTFixture);
            this.hello = hello;
            
            const signers: SignerWithAddress[] = await ethers.getSigners();
            
            const DESCRIPTION = "The description for EVT";
            const TAX = 100;
            await this.hello.safeMint(await signers[1].getAddress(), DESCRIPTION, TAX);
            this.tokenId = 0;
        });

        it("get description", async function() {
            const des = await this.hello.description(this.tokenId)
            console.log(`Description for Token#${this.tokenId} is: ${des}`);
        })
        it("get tax", async function() {
            const tax = await this.hello.tax(this.tokenId)
            console.log(`Tax for Token#${this.tokenId} is: ${tax}`);
        })
    })

    describe("get uri", function() {
        beforeEach(async function () {
            const { hello } = await this.loadFixture(deployHelloEVTFixture);
            this.hello = hello;
            
            const signers: SignerWithAddress[] = await ethers.getSigners();
            
            const DESCRIPTION = "The description for EVT";
            const TAX = 100;
            await this.hello.safeMint(await signers[1].getAddress(), DESCRIPTION, TAX);
            this.tokenId = 0;
        });

        it("get uri", async function() {
            const PropertyName = "Change Me";
            const PropertyValue = "Value";
            await this.hello.addProperty(PropertyName);
            await this.hello.setProperty(this.tokenId, PropertyName, PropertyValue);
            const uri = await this.hello.tokenURI(this.tokenId);
            console.log(`Token#0 uri is: ${uri}`);
        })
    })

})