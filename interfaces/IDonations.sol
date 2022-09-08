// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

interface IDonations {
    event Donated(address, uint256);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Redeemed(address, uint256);

    function donate() external payable;
    function owner() external view returns (address);
    function redeem(uint256 value) external;
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function users(address) external view returns (uint256 donatedAmount, uint256 redeemedAmount);
    function withdrawPayments(address payee) external;
}