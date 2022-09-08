// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "forge-std/Test.sol";
import "../src/CharitableNFT.sol";
import "../src/Donations.sol";

contract CharitableNFTTest is Test {
    address acc = address(1);
    NFT nft;
    Donations donations;

    function setUp() public {
        vm.deal(acc, 1 ether);
        donations = new Donations();
        nft = new NFT("MyNft", "nft", address(donations));
    }

    function testCheckMintAllowed() public {
        vm.startPrank(acc, acc);
        donations.donate{value: 0.2 ether}();
        assertEq(
            ICharitableNFT(address(nft)).checkMintAllowed(0.1 ether),
            true
        );
        vm.stopPrank();
    }

    // doesnt work
    function testFailCheckMintAllowed() public {
        vm.startPrank(acc, acc);
        donations.donate{value: 0.2 ether}();
        // not donated enough
        assertEq(
            ICharitableNFT(address(nft)).checkMintAllowed(0.5 ether),
            true
        );
        vm.stopPrank();
    }

    function testCanMint() public {
        vm.startPrank(acc, acc);
        donations.donate{value: 0.2 ether}();
        nft.mintTo(acc);
        vm.stopPrank();
    }

    function testCannotMint() public {
        vm.startPrank(acc, acc);
        vm.expectRevert("Donation amount too low");
        nft.mintTo(acc);
        vm.stopPrank();
    }
}

contract NFT is ERC721, CharitableNFT {
    uint256 public currentTokenId;

    constructor(
        string memory _name,
        string memory _symbol,
        address _address
    ) ERC721(_name, _symbol) {
        setDonationAddress(_address);
    }

    function mintTo(address recipient) public payable returns (uint256) {
        // ensure user has donated enough
        checkMintAllowed(price);
        redeem(price);
        uint256 newItemId = ++currentTokenId;
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return Strings.toString(id);
    }
}
