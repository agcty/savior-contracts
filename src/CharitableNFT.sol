// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IDonations.sol";
import "../interfaces/ICharitableNft.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

/** This contract acts as an interface for charitable nfts, at the very minimum charitable nfts need to implement the checkMintAllowed and redeem functions */
abstract contract CharitableNFT is ICharitableNFT, Ownable {
    address donationAddress;
    uint256 price = 0.1 ether;

    // shouldn't be overriden
    function setDonationAddress(address _address) public onlyOwner {
        donationAddress = _address;
    }

    // can be overridden if logic deviates
    function checkMintAllowed(uint256 price) public virtual returns (bool) {
        (uint256 donatedAmount, ) = IDonations(donationAddress).users(
            msg.sender
        );
        require(donatedAmount >= price, "Donation amount too low");
        return true;
    }

    // can be overridden if logic deviates
    function redeem(uint256 price) public virtual {
        IDonations(donationAddress).redeem(price);
    }
}
