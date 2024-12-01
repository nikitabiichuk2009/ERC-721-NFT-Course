// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

abstract contract Constants {
    string public constant DEFAULT_TOKEN_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
}

contract Interactions is Script, Constants {
    function run(string memory tokenURI) external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        mintNftOnContract(mostRecentlyDeployed, tokenURI);
    }

    function mintNftOnContract(address contractToMintFrom, string memory tokenURI) public {
        // if no tokenURI is provided, use the default one
        if (bytes(tokenURI).length == 0) {
            tokenURI = DEFAULT_TOKEN_URI;
        }
        vm.startBroadcast();
        BasicNFT(contractToMintFrom).mintNft(tokenURI);
        vm.stopBroadcast();
    }
}
