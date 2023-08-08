// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address public alice;
    address public bob;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        alice = address(1);
        bob = address(2);
    }

    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;
        ourToken.approve(bob, initialAllowance);
        assertEq(ourToken.allowance(msg.sender, bob), initialAllowance);

        uint256 newAllowance = 50;
        ourToken.approve(bob, newAllowance);
        assertEq(ourToken.allowance(msg.sender, bob), newAllowance);
    }

    function testTransfers() public {
        uint256 transferAmount = 50;
        ourToken.transfer(alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);

        uint256 initialAllowance = 100;
        ourToken.approve(bob, initialAllowance);
        ourToken.transferFrom(msg.sender, bob, transferAmount);
        assertEq(ourToken.balanceOf(bob), transferAmount);
    }
}
