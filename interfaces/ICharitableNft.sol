// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

// this should probably also have the mint function
interface ICharitableNFT {
    function checkMintAllowed(uint256 price) external returns (bool);

    function redeem(uint256 price) external;

    function setDonationAddress(address _address) external;
}
