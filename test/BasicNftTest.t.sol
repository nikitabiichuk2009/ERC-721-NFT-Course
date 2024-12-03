// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNFT public basicNFT;
    DeployBasicNft public deployer;
    address public USER = makeAddr("user");
    address public RECIPIENT = makeAddr("recipient");

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "NikitaBiichuksNFT";
        string memory actualName = basicNFT.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "NBNFT";
        string memory actualSymbol = basicNFT.symbol();
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNFT.mintNft("ipfs://nikita.biichuk.json");
        assertEq(basicNFT.balanceOf(USER), 1);
        assertEq(basicNFT.ownerOf(0), USER);
        assert(
            keccak256(abi.encodePacked(basicNFT.tokenURI(0)))
                == keccak256(abi.encodePacked("ipfs://nikita.biichuk.json"))
        );
        assertEq(basicNFT.getTokenCounter(), 1);
    }

    function testTransferNFT() public {
        vm.prank(USER);
        basicNFT.mintNft("ipfs://test.json");

        vm.prank(USER);
        basicNFT.transferFrom(USER, RECIPIENT, 0);

        assertEq(basicNFT.balanceOf(USER), 0);
        assertEq(basicNFT.balanceOf(RECIPIENT), 1);
        assertEq(basicNFT.ownerOf(0), RECIPIENT);
    }

    function testFailUnauthorizedTransfer() public {
        address UNAUTHORIZED_USER = makeAddr("unauthorized");

        vm.prank(USER);
        basicNFT.mintNft("ipfs://test.json");

        vm.prank(UNAUTHORIZED_USER);
        basicNFT.transferFrom(USER, RECIPIENT, 0);
    }

    function testApproveAndTransfer() public {
        address APPROVED_USER = makeAddr("approved");

        vm.prank(USER);
        basicNFT.mintNft("ipfs://test.json");

        vm.prank(USER);
        basicNFT.approve(APPROVED_USER, 0);

        assertEq(basicNFT.getApproved(0), APPROVED_USER);

        vm.prank(APPROVED_USER);
        basicNFT.transferFrom(USER, RECIPIENT, 0);

        assertEq(basicNFT.ownerOf(0), RECIPIENT);
    }

    function testSetApprovalForAll() public {
        address OPERATOR = makeAddr("operator");

        vm.prank(USER);
        basicNFT.mintNft("ipfs://test.json");

        vm.prank(USER);
        basicNFT.setApprovalForAll(OPERATOR, true);

        assertTrue(basicNFT.isApprovedForAll(USER, OPERATOR));
    }

    function testSafeTransferFromWithData() public {
        vm.prank(USER);
        basicNFT.mintNft("ipfs://test.json");

        vm.prank(USER);
        basicNFT.safeTransferFrom(USER, RECIPIENT, 0, "");

        assertEq(basicNFT.ownerOf(0), RECIPIENT);
    }

    function testRevokeApproval() public {
        address APPROVED_USER = makeAddr("approved");

        vm.prank(USER);
        basicNFT.mintNft("ipfs://test.json");

        vm.startPrank(USER);
        basicNFT.approve(APPROVED_USER, 0);
        assertEq(basicNFT.getApproved(0), APPROVED_USER);

        basicNFT.approve(address(0), 0);
        assertEq(basicNFT.getApproved(0), address(0));
        vm.stopPrank();
    }

    function testRevokeOperatorApproval() public {
        address OPERATOR = makeAddr("operator");

        vm.startPrank(USER);
        basicNFT.setApprovalForAll(OPERATOR, true);
        assertTrue(basicNFT.isApprovedForAll(USER, OPERATOR));

        basicNFT.setApprovalForAll(OPERATOR, false);
        assertFalse(basicNFT.isApprovedForAll(USER, OPERATOR));
        vm.stopPrank();
    }

    function testTokenCounter() public {
        assertEq(basicNFT.getTokenCounter(), 0);

        vm.startPrank(USER);
        basicNFT.mintNft("ipfs://1.json");
        assertEq(basicNFT.getTokenCounter(), 1);

        basicNFT.mintNft("ipfs://2.json");
        assertEq(basicNFT.getTokenCounter(), 2);
        vm.stopPrank();
    }
}
