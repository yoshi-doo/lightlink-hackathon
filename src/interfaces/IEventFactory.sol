// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13 .0;

interface IEventFactory {
    enum EventStatus {
        CURRENT,
        ARCHIVED
    }

    struct EventDetails {
        EventStatus status;
        uint256 index;
    }

    receive() external payable;
    function create(
        string memory name,
        string memory symbol,
        string memory description,
        string memory imageUrl,
        string memory imageUrlValidated,
        string memory dateTime,
        string memory location,
        uint256 amount,
        uint256 price,
        uint256 maxAllowedTicketsPerUser
    ) external payable returns (bool);
    function close(address event_) external returns (bool);
    function withdraw() external returns (bool);
    function buy(address event_, uint256 amount) external payable returns (bool);
    function validate(address event_, uint256 tokenId, address claimer) external returns (bool);
    function getCurrentEvents() external view returns (address[] memory);
    function getArchivedEvents() external view returns (address[] memory);
    function getCreatedEvents(address owner) external view returns (address[] memory);
    function getOwnedTicketEvents(address user) external view returns (address[] memory);
}
