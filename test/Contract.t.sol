// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13 .0;

import {Test} from "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

import "forge-std/console.sol";

contract EventTest is Test {
    Event internal eventContract;
    address internal nonAdminUser;

    function setUp() public {
        nonAdminUser = address(1);
        eventContract = new Event(
            nonAdminUser,
            "Test",
            "TST",
            "Test Event",
            "http://local.image",
            "http://local.validated",
            "12-12-2024 19:00",
            "Berlin",
            10,
            1 ether,
            4
        );
        console.logAddress(address(eventContract));
    }

    receive() external payable {}

    function testClose() public {
        hoax(address(12));
        eventContract.buy{value: 3 ether}(3);
        console.logAddress(eventContract.deployer());
        vm.prank(nonAdminUser);
        eventContract.close();
        console.logUint(nonAdminUser.balance);
        console.logUint(address(this).balance);
    }
}
