// Based on https://github.com/Elpacos/quickfork/blob/master/test/TestPoc1.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../interface.sol"; 

contract POCTest is Test {

    // ETH Tokens
    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    //address target = vm.envAddress("TARGET_ADDRESS");

    // ON-CHAIN CONTRACTS

    // Users 
    address alice = address(1);
    address bob = address(2);// bob always gets rekt :/

    uint256 fork;
    CheatCodes constant cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public {
        fork = vm.createFork("mainnet");
        vm.selectFork(fork);

        deal(address(usdc), alice, 10 ether);
        deal(address(usdc), bob, 10 ether);
        startHoax(alice, 10 ether);
    }

    // UNIT TEST
    function testExploitUnit() public {
        vm.stopPrank();
        vm.prank(bob);

        // EXPLOIT
        usdc.transfer(alice, 1 ether);

        assertEq(usdc.balanceOf(alice), 11 ether);

        emit log_named_decimal_uint("balance of alice:", IERC20(usdc).balanceOf(address(alice)),18);
    }

    // FUZZ TEST
    // function testExploitFuzz(uint256 amount) public {
    //     vm.assume(amount <= 10 ether);

    //     // EXPLOIT
    //     usdc.transfer(target, amount);

    //     assertEq(usdc.balanceOf(alice), 10 ether - amount);
    // }


}
