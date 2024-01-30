// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13 .0;

import {Ownable} from "@thirdweb-dev/contracts/extension/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {IEventFactory} from "./interfaces/IEventFactory.sol";
import {Event} from "./Event.sol";

contract EventFactory is IEventFactory, Ownable, ReentrancyGuard {
    uint256 public listingFee;
    uint256 private constant _MAX_TICKETS_PER_USER = 2;
    address[] private _currentEvents;
    address[] private _archivedEvents;

    mapping(address => EventDetails) private _eventMap;
    mapping(address => address[]) private _userToEventMap;

    constructor(uint256 listingFee_) {
        _setupOwner(msg.sender);
        listingFee = listingFee_;
    }

    receive() external payable override {}

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
    ) external payable override returns (bool) {
        require(bytes(name).length != 0);
        require(bytes(symbol).length != 0);
        require(bytes(description).length != 0);
        require(bytes(imageUrl).length != 0);
        require(bytes(imageUrlValidated).length != 0);
        require(bytes(dateTime).length != 0);
        require(bytes(location).length != 0);
        require(amount > 0, "Amount should be greater than 0");
        require(price > 0, "Price should be greater than 0");
        require(msg.value == listingFee, "Listing fee not passed or incorrect");

        Event eventContract = new Event(
            msg.sender,
            name,
            symbol,
            description,
            imageUrl,
            imageUrlValidated,
            dateTime,
            location,
            amount,
            price,
            maxAllowedTicketsPerUser != 0 ? maxAllowedTicketsPerUser : _MAX_TICKETS_PER_USER
        );
        _currentEvents.push(address(eventContract));
        _eventMap[address(eventContract)] = EventDetails(
            EventStatus.CURRENT,
            _currentEvents.length - 1
        );

        _userToEventMap[msg.sender].push(address(eventContract));
        return true;
    }

    function close(address event_) external override nonReentrant returns (bool) {
        require(_eventMap[event_].status != EventStatus.ARCHIVED, "Event is already archived");
        Event eventContract = Event(event_);
        require(msg.sender == eventContract.owner(), "Caller is not owner of the event");
        bool success = eventContract.close();
        require(success);
        _archiveEvent(event_);
        return success;
    }

    function getCurrentEvents() external view override returns (address[] memory) {
        return _currentEvents;
    }

    function getArchivedEvents() external view override returns (address[] memory) {
        return _archivedEvents;
    }

    function getEvents(address user) external view override returns (address[] memory) {
        return _userToEventMap[user];
    }

    function _archiveEvent(address event_) internal {
        // Save current index for archiving event
        uint256 currentIndex = _eventMap[event_].index;
        // Push archiving event to _archivedEvents
        _archivedEvents.push(event_);
        // Update _eventMap for archived event with new details
        _eventMap[event_] = EventDetails(EventStatus.ARCHIVED, _archivedEvents.length - 1);
        // Save address for last event in _currentEvents
        address lastCurrentEvent = _currentEvents[_currentEvents.length - 1];
        // Copy the last event in _currentEvents to index of archived event
        _currentEvents[currentIndex] = lastCurrentEvent;
        // Pop the last event in _currentEvents
        _currentEvents.pop();
        // Update the _eventMap with new details
        _eventMap[lastCurrentEvent] = EventDetails(EventStatus.CURRENT, currentIndex);
    }

    function _canSetOwner() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }
}
