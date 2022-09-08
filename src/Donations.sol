// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

struct User {
    uint256 donatedAmount;
    uint256 redeemedAmount;
}

error WithdrawTransfer();

// Version 1: Works with only one project
// Version 2: Uses NFTs to create new projects
contract Donations is Ownable {
    event Donated(address, uint256);
    event Redeemed(address, uint256);

    mapping(address => User) public users;

    function donate() external payable {
        User storage u = users[msg.sender];

        u.donatedAmount += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    function getUser() external view returns (uint256) {
        return
            users[0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266]
                .donatedAmount;
    }

    // used to donate for another person
    // useful for anonymizing donations or to let nft smart contracts handle donation
    function donateFor(address _addressFor) external payable {
        User storage u = users[_addressFor];

        u.donatedAmount += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    // Do not call this function directly or you risk losing out on funds. Should only be called by smart contracts.
    function redeem(uint256 value) external {
        // using tx.origin here because the charitablenft is responsible for redeeming but msg.sender would be different because of the intermediary contract
        // and passing msg.sender down the call chain would require an address argument in redeem() and that in turn would require some form of auth
        User storage u = users[tx.origin];
        // ensure user can't redeem more than they have donated
        require(
            (u.redeemedAmount + value) <= u.donatedAmount,
            "Cannot redeem more than donated"
        );
        u.redeemedAmount += value;
        emit Redeemed(msg.sender, value);
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx, ) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }
}
