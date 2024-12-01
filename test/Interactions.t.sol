// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Interactions, Constants} from "../script/Interactions.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract InteractionsTest is Test, Constants {
    BasicNFT public basicNFT;
    DeployBasicNft public deployer;

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNFT = deployer.run();
    }

    function testCanMintNft() public {
        Interactions interactions = new Interactions();
        interactions.mintNftOnContract(
            address(basicNFT),
            "ipfs://nikita.biichuk.json"
        );
        assert(basicNFT.getTokenCounter() == 1);
    }

    function testcanMintNftWithDefaultTokenURI() public {
        Interactions interactions = new Interactions();
        interactions.mintNftOnContract(address(basicNFT), "");
        assert(basicNFT.getTokenCounter() == 1);
        assert(
            keccak256(abi.encodePacked(basicNFT.tokenURI(0))) ==
                keccak256(abi.encodePacked(DEFAULT_TOKEN_URI))
        );
    }
}
