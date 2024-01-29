// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13 .0;

interface IEvent {
    struct EventDetails {
        string name;
        string description;
        string imageUrl;
        string imageUrlValidated;
        string dateTime;
        string location;
        uint256 price;
        uint256 availableTickets;
    }
    function buy(uint256 amount) external payable returns (bool);
    function validate(uint256 tokenId, address owner) external returns (bool);
    function close() external returns (bool);
}
