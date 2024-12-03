// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__NotApprovedOrOwner(address, uint256);
    error MoodNft__TokenDoesNotExist(uint256);

    enum Mood {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri)
        ERC721("NikitaBiichukMoodNft", "NBMOOD")
    {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function changeMood(uint256 tokenId) public {
        if (_ownerOf(tokenId) == address(0)) {
            revert MoodNft__TokenDoesNotExist(tokenId);
        }
        if (!_isAuthorized(_ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNft__NotApprovedOrOwner(msg.sender, tokenId);
        }

        s_tokenIdToMood[tokenId] = s_tokenIdToMood[tokenId] == Mood.HAPPY ? Mood.SAD : Mood.HAPPY;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) {
            revert MoodNft__TokenDoesNotExist(tokenId);
        }

        string memory imageURI = s_tokenIdToMood[tokenId] == Mood.HAPPY ? s_happySvgImageUri : s_sadSvgImageUri;

        string memory tokenData = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                name(),
                '", "description": "A mood NFT that reflects the mood of the owner, happy or sad", ',
                '"image": "',
                imageURI,
                '", "attributes": [{"trait_type": "moodiness", "value": "',
                s_tokenIdToMood[tokenId] == Mood.HAPPY ? "100" : "0",
                '", "owner": "',
                _ownerOf(tokenId),
                '"}]}'
            )
        );
        return string(abi.encodePacked(_baseURI(), tokenData));
    }

    function getMood(uint256 tokenId) public view returns (Mood) {
        if (_ownerOf(tokenId) == address(0)) {
            revert MoodNft__TokenDoesNotExist(tokenId);
        }
        return s_tokenIdToMood[tokenId];
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySvgImageUri;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvgImageUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
