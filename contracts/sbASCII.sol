// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "./libraries/Base64.sol";


contract sbASCII is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  address tokenAddress;

  // We split the SVG at the part where it asks for the XP blanace
  //<!-- Generator: Adobe Illustrator 19.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><!-- License: CC0. Made by SVG Repo: https://www.svgrepo.com/svg/262038/trophy -->
  string svgPartOne = "<svg version='1.1' id='Layer_1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' viewBox='0 0 512.005 512.005' style='enable-background:new 0 0 512.005 512.005;' xml:space='preserve'><path style='fill:#EEBF00;' d='M168.087, 355.819C101.953, 263.71, 71.13, 99.47,71.13, 99.47L256.002, 0l184.872, 99.47 c0,0-26.7,164.241-89.202,256.351L168.087,355.819z'/><g style='opacity:0.3;'><path style='fill:#664400;' d='M364.581,58.319L114.414,250.183c10.067,26.417,21.952,53.124,35.709,77.184L440.874,99.369 L364.581,58.319z'/></g><path style='fill:#FFEB99;' d='M215.341,359.233c-1.8,0-3.61-0.617-5.086-1.88c-32.948-28.173-61.499-76.386-84.86-143.301 c-17.252-49.42-24.889-90.076-25.205-91.783c-0.789-4.252,2.019-8.338,6.271-9.128c4.253-0.789,8.34,2.018,9.13,6.27 c0.301,1.622,30.985,162.882,104.843,226.036c3.287,2.81,3.675,7.755,0.863,11.042C219.749,358.303,217.552,359.233,215.341,359.233 z'/><g> <path style='opacity:0.3;fill:#664400;enable-background:new    ;' d='M402.175,78.648 c-10.473,47.638-31.178,126.978-63.926,191.014c-11.686,22.852-35.099,37.312-60.765,37.312l-138.477-0.001 c8.8,17.485,18.487,34.092,29.081,48.847l183.584,0.001c62.503-92.11,89.202-256.351,89.202-256.351L402.175,78.648z'/> <path style='fill:#664400;' d='M434.825,512H79.399V389.361c0-18.525,15.018-33.543,33.543-33.543h288.339 c18.525,0,33.543,15.018,33.543,33.543V512H434.825z'/></g><g> <rect x='79.398' y='456.731' style='fill:#56361D;' width='355.427' height='55.274'/> <path style='fill:#56361D;' d='M107.892,492.195c-4.326,0-7.832-3.506-7.832-7.832v-84.887c0-4.326,3.506-7.832,7.832-7.832  c4.326,0,7.832,3.506,7.832,7.832v84.887C115.724,488.689,112.217,492.195,107.892,492.195z'/></g><path style='fill:#FFF5CC;' d='M340.651,426.751H177.6c-8.79,0-15.98-7.191-15.98-15.98v-3.253c0-8.79,7.191-15.98,15.98-15.98 h163.052c8.79,0,15.98,7.191,15.98,15.98v3.253C356.632,419.56,349.44,426.751,340.651,426.751z'/><text x='50%' y='90%' class='base' dominant-baseline='middle' text-anchor='middle' style='fill: rgb(255, 255, 255); font-family: Josefin, sans-serif; font-size: 45px;'>Ethernaut XP</text><text x='50%' y='40%' class='base' dominant-baseline='middle' text-anchor='middle' style='font-family: Josefin, sans-serif; font-size: 160px;'>";  

  event NewNftMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("SoulBound ASCII", "SBASCII") {}

  // Mint one NFT to msg.sender
  function mint() public {
    // require balance of owner to be 0
    require(balanceOf(msg.sender) == 0);

    // Update all NFTs balances
    updateAllUris();

    // Mint new NFT
    makeNFT(msg.sender);
  }

  // Mint one NFT to _to
  function mintTo(address _to) public {
    // require balance of _to to be 0
    require(balanceOf(_to) == 0);

    // Update all NFTs balances
    updateAllUris();

    // Mint new NFT
    makeNFT(_to);
  }

  function makeNFT(address _to) internal virtual {
    uint256 newItemId = _tokenIds.current();

    // Mint Token
    _safeMint(_to, newItemId);
  
    // Update URI of minted NFT
    updateURI(newItemId, 0);
  
    // Increase NFT counter
    _tokenIds.increment();

    emit NewNftMinted(_to, newItemId);
  }

  function updateURI(uint256 _tokenId, uint256 _balance) internal {
    // Construction of SVG image
    string memory finalSvg = string(abi.encodePacked(svgPartOne, Strings.toString(_balance), "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "ASCII Dynamic NFT", "description": "Display your EXP balance on this NFT", "image": "data:image/svg+xml;base64,',
            // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
            Base64.encode(bytes(finalSvg)),
            '"}'
          )
        )
      )
    );

    // Prepend data:application/json;base64, to our data
    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    // Update URI!!!
    _setTokenURI(_tokenId, finalTokenUri);
  }

  // Public function to update all NFTs
  function updateAllUris() public {
    for (uint256 i = 0; i < _tokenIds.current(); i++) {
      updateTokenURI(i);
    }
  }

  // Internal function to update a single NFT
  function updateTokenURI(uint256 _tokenId) internal {
    uint256 balance = getBalanceOfToken(_tokenId);
    updateURI(_tokenId, balance);
  }

  // Get the balance of external token of the owner of the NFT
  function getBalanceOfToken(uint256 _tokenId) public view returns (uint256) {
    // Get owner of NFT
    address owner = ownerOf(_tokenId);

    // Get decimals of external token
    uint256 decimals = ERC20(tokenAddress).decimals();

    // Get balance of external token
    uint256 tokenBalance = IERC20(tokenAddress).balanceOf(owner);

    // Return balance of external token divided by decimals
    return tokenBalance / (10 ** decimals);
  }

  // Only owner function to set the external token address
  function setTokenAddress(address _tokenAddress) external onlyOwner {
    tokenAddress = _tokenAddress;
  }

  // Override ERC721 _transfer function to prevent transfers
  function _transfer(address from, address to, uint256 tokenId) internal pure override {
    revert("Soulbound ASCII NFTs cannot be transferred");
  }
}