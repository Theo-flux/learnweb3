// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    // _price is the price of one CryptoDev
    uint8  constant public _price = 0.01 ether;

    // maximum number of CryptoDevs that can ever exist
    uint8 constant public maxTokenIds = 20;

    // whitelist contract instance
    Whitelist whitelist;

    // number of tokens reserved for whitelisted members
    uint256 public reservedTokens;
    uint256 public reservedTokensClaimed = 0;

    /**
      * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
      * name in our case is `Crypto Devs` and symbol is `CD`.
      * Constructor for Crypto Devs takes in the baseURI to set _baseTokenURI for the collection.
      * It also initializes an instance of whitelist interface.
      */
    constructor (address whitelistContract) ERC721("Crypto Devs", "CD") Ownable(msg.sender) {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.maxWhitelistedAddress;
    }

    function mint() public payable {
      // Make sure we always leave enough room for whitelist reservations
      require(totalSupply() + reservedTokens - reservedTokensClaimed < maxTokenIds, "EXCEEDED_MAX_SUPPLY");

      // If user is part of the whitelist, make sure there is still reserved tokens left
      if(whitelist.whitelistedAddresses(msg.sender) && msg.value < _price) {
        //Make sure user does not already own nft
        require(balanceOf(msg.sender), "ALREADY_OWNED");
        reservedTokensClaimed += 1;
      }else {
        // If user is not on the whitelistaddress
        require(msg.value > _price, "NOT_ENOUGH_ETHER");
      }
      uint256 tokenId = totalSupply();
      _safeMint(msg.sender, tokenId);
    }

    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
      */
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}