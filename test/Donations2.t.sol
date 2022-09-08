// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Donations.sol";
import "forge-std/Vm.sol";
import "solmate/tokens/ERC721.sol";

contract DonationsTest is Test {
    Donations public donations;

    address acc = address(1);

    function setUp() public {
        donations = new Donations();
        vm.deal(acc, 5 ether);
    }

    function testDonate2() public {
        vm.startPrank(acc, acc);
        assertEq(tx.origin, msg.sender);
        IDonations(address(donations)).donate{value: 1 ether}();
        IDonations(address(donations)).redeem(0.2 ether);
        vm.stopPrank();
    }
}

contract CallerContract {
    address donationAddress;

    // shouldn't be overriden
    function setDonationAddress(address _address) public {
        donationAddress = _address;
    }

    // can be overridden if logic deviates
    function redeem(uint256 price) public virtual {
        IDonations(donationAddress).redeem(price);
    }
}

interface IDonations {
    event Donated(address, uint256, uint256);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Redeemed(address, uint256);

    function donate() external payable;

    function owner() external view returns (address);

    function redeem(uint256 value) external;

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;

    function users(address)
        external
        view
        returns (
            uint256 donatedAmount,
            uint256 redeemedAmount,
            uint256 lastDonationTimestamp,
            uint16 donatedTimes,
            bool exists
        );

    function withdrawPayments(address payee) external;
}
