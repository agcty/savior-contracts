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
        vm.deal(acc, 1 ether);
    }

    function testDonate() public {
        vm.startPrank(acc, acc);

        // vm.expectEmit(acc, 1 ether);
        donations.donate{value: 1 ether}();

        assertEq(address(donations).balance, 1 ether);
        (uint256 depositedAmount, uint256 redeemedAmount) = donations.users(
            acc
        );

        assertEq(depositedAmount, 1 ether);
        assertEq(redeemedAmount, 0 ether);

        vm.stopPrank();
    }

    function testDonateFor() public {
        address acc2 = address(2);

        vm.startPrank(acc, acc);

        // vm.expectEmit(acc, 1 ether);
        donations.donateFor{value: 1 ether}(acc2);

        assertEq(address(donations).balance, 1 ether);
        (uint256 depositedAmount, uint256 redeemedAmount) = donations.users(
            acc2
        );

        assertEq(depositedAmount, 1 ether);
        assertEq(redeemedAmount, 0 ether);

        vm.stopPrank();
    }

    function testRedeem() public {
        vm.startPrank(acc, acc);
        donations.donate{value: 1 ether}();
        donations.redeem(0.3 ether);
        vm.stopPrank();
        (, uint256 redeemedAmount) = donations.users(acc);
        assertEq(redeemedAmount, 0.3 ether);
    }

    function testCannotRedeemMoreThanDonated() public {
        vm.startPrank(acc, acc);
        donations.donate{value: 1 ether}();
        vm.expectRevert("Cannot redeem more than donated");
        donations.redeem(2 ether);
        vm.stopPrank();
    }

    function testWithdrawalWorksAsOwner() public {
        // Mint an NFT, sending eth to the contract
        address payable payee = payable(address(0x1337));
        uint256 priorPayeeBalance = payee.balance;
        uint256 priorDonationsBalance = address(donations).balance;

        assertEq(priorPayeeBalance, 0 ether);

        // donate first
        vm.prank(acc, acc);
        donations.donate{value: 1 ether}();

        // withdraw to account
        donations.withdrawPayments(payee);

        assertEq(payee.balance, priorDonationsBalance + payee.balance);
    }

    function testWithdrawalFailsAsNotOwner() public {
        // Mint an NFT, sending eth to the contract
        vm.prank(acc, acc);
        donations.donate{value: 1 ether}();

        // Confirm that a non-owner cannot withdraw
        vm.expectRevert("Ownable: caller is not the owner");
        vm.startPrank(address(0xd3ad));
        donations.withdrawPayments(payable(address(0xd3ad)));
        vm.stopPrank();
    }
}
