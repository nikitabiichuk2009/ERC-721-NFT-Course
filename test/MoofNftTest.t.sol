// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft, Constants} from "../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test, Constants {
    MoodNft public moodNft;
    DeployMoodNft public deployer;
    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testConstructorSetsCorrectly() public view {
        assertEq(moodNft.name(), "NikitaBiichukMoodNft");
        assertEq(moodNft.symbol(), "NBMOOD");
        assertEq(moodNft.getTokenCounter(), 0);
        assertEq(moodNft.getHappySVG(), HAPPY_SVG_IMAGE_URI);
        assertEq(moodNft.getSadSVG(), SAD_SVG_IMAGE_URI);
    }

    function testMintNft() public {
        vm.prank(USER);
        moodNft.mintNft();
        assertEq(moodNft.balanceOf(USER), 1);
        assertEq(uint256(moodNft.getMood(0)), uint256(MoodNft.Mood.HAPPY));
        assertEq(moodNft.getTokenCounter(), 1);
    }

    function testChangeMood() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.prank(USER);
        moodNft.changeMood(0);
        assertEq(uint256(moodNft.getMood(0)), uint256(MoodNft.Mood.SAD));
        console.log(moodNft.tokenURI(0));
    }

    function testUnauthorizedChangeMoodReverts() public {
        vm.prank(USER);
        moodNft.mintNft();
        address unauthorizedUser = address(0x123);
        vm.prank(unauthorizedUser);
        vm.expectRevert(abi.encodeWithSelector(MoodNft.MoodNft__NotApprovedOrOwner.selector, unauthorizedUser, 0));
        moodNft.changeMood(0);
    }

    function testChangeMoodRevertsForNonexistentToken() public {
        vm.expectRevert(abi.encodeWithSelector(MoodNft.MoodNft__TokenDoesNotExist.selector, 0));
        moodNft.changeMood(0);
    }

    function testTokenURI() public {
        vm.prank(USER);
        moodNft.mintNft();
        string memory tokenUri = moodNft.tokenURI(0);
        console.log(tokenUri);
        assert(bytes(tokenUri).length > 0);
    }

    function testGetTokenUriRevertsForNonexistentToken() public {
        vm.expectRevert(abi.encodeWithSelector(MoodNft.MoodNft__TokenDoesNotExist.selector, 0));
        moodNft.tokenURI(0);
    }

    function testTokenCounter() public view {
        assertEq(moodNft.getTokenCounter(), 0);
    }

    function testGetTokenCounter() public {
        assertEq(moodNft.getTokenCounter(), 0);

        vm.startPrank(USER);
        moodNft.mintNft();
        assertEq(moodNft.getTokenCounter(), 1);

        moodNft.mintNft();
        assertEq(moodNft.getTokenCounter(), 2);
        vm.stopPrank();
    }

    function testGetMood() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        assertEq(uint256(moodNft.getMood(0)), uint256(MoodNft.Mood.HAPPY));

        moodNft.changeMood(0);
        assertEq(uint256(moodNft.getMood(0)), uint256(MoodNft.Mood.SAD));
        vm.stopPrank();
    }

    function testGetMoodRevertsForNonexistentToken() public {
        vm.expectRevert(abi.encodeWithSelector(MoodNft.MoodNft__TokenDoesNotExist.selector, 0));
        moodNft.getMood(0);
    }
}
