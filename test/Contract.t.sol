// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13 .0;

import {Test} from "forge-std/Test.sol";
import {EventFactory} from "../src/EventFactory.sol";
import {Event} from "../src/Event.sol";

import "forge-std/console.sol";

contract EventTest is Test {
    EventFactory internal factoryContract;
    address internal factoryAdmin = address(123);
    address internal org1 = address(1);
    address internal org2 = address(2);
    uint256 constant LISTING_FEE = 2 ether;

    function setUp() public {
        vm.deal(factoryAdmin, 10 ether);
        vm.deal(org1, 10 ether);
        vm.deal(org2, 10 ether);
        vm.prank(factoryAdmin);
        factoryContract = new EventFactory(LISTING_FEE);
        // eventContract = new Event(
        // nonAdminUser,
        // "Test",
        // "TST",
        // "Test Event",
        // "http://local.image",
        // "http://local.validated",
        // "12-12-2024 19:00",
        // "Berlin",
        // 10,
        // 1 ether,
        // 4
        // );
        console.logAddress(factoryContract.owner());
        vm.startPrank(org1);
        factoryContract.create{value: factoryContract.listingFee()}(
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
        vm.stopPrank();
        // vm.startPrank(org2);
        // factoryContract.create{value: factoryContract.listingFee()}(
        //     "Test2",
        //     "TST2",
        //     "2Test Event",
        //     "http://2local.image",
        //     "http://2local.validated",
        //     "22-12-2024 19:00",
        //     "Berlin2",
        //     15,
        //     2 ether,
        //     5
        // );
        // vm.stopPrank();
    }

    receive() external payable {}

    function testClose() public {
        vm.startPrank(org2);
        Event(factoryContract.getEvents(org1)[0]).buy{value: 4 ether}(4);
        vm.stopPrank();
        address org1Event = factoryContract.getEvents(org1)[0];
        console.log("balance org1 %s", org1.balance);
        console.log("balance org2 %s", org2.balance);
        console.log("balance factory %s", address(factoryContract).balance);
        vm.prank(org1);
        factoryContract.close(org1Event);
        address[] memory currentEvents2 = factoryContract.getCurrentEvents();
        for (uint256 index = 0; index < currentEvents2.length; index++) {
            console.log("curr %s", currentEvents2[index]);
        }

        address[] memory archivedEvents = factoryContract.getArchivedEvents();
        for (uint256 index = 0; index < archivedEvents.length; index++) {
            console.log("arch %s", archivedEvents[index]);
        }
        console.log("balance org1 %s", org1.balance);
        console.log("balance org2 %s", org2.balance);
        console.log("balance factory %s", address(factoryContract).balance);
    }
}
