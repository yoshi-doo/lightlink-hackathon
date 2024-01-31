// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13 .0;

import {Ownable} from "@thirdweb-dev/contracts/extension/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {IEventFactory} from "./interfaces/IEventFactory.sol";
import {Event} from "./Event.sol";

/**
 * @title A Factory contract to create and close events contracts.
 * @notice Each event is represented by an ERC721 contract and tickets correspond to ERC721 tokens.
 */
contract EventFactory is IEventFactory, Ownable, ReentrancyGuard {
    /**
     * @notice Fee for listing an Event with the Event Factory.
     */
    uint256 public listingFee;

    /**
     * @notice Default for maximum allowed tickets per user.
     */
    uint256 private constant _MAX_TICKETS_PER_USER = 2;

    /**
     * @notice Array of contract addresses of current events.
     */
    address[] private _currentEvents;

    /**
     * @notice Array of contract addresses of closed/archived events.
     * @dev A closed event is considered archived.
     */
    address[] private _archivedEvents;

    /**
     * @notice Mapping from event contract address to event details
     */
    mapping(address => EventDetails) private _eventMap;

    /**
     * @notice Mapping from owner address to owned event contract addresses.
     */
    mapping(address => address[]) private _ownerToEventMap;

    /**
     * @notice Mapping from ticket owner address to event contract addresses.
     */
    mapping(address => address[]) private _userToEventMap;

    error CallerNotCreator();
    error EventAlreadyArchived();

    constructor(uint256 listingFee_) {
        _setupOwner(msg.sender);
        listingFee = listingFee_;
    }

    receive() external payable override {}

    /**
     * @notice Function to create a new Event contract.
     * @dev listingFee amount should be passed in msg.value.
     * @param name Event name.
     * @param symbol Event contract ERC721 symbol.
     * @param description Event description.
     * @param imageUrl Event image url.
     * @param imageUrlValidated Event image url after validated.
     * @param dateTime Event dateTime.
     * @param location Event location.
     * @param amount Event ticket amount to be minted.
     * @param price Event ticket price.
     * @param maxAllowedTicketsPerUser Maximum tickets allowed per user default is 2.
     * @return bool Status of event creation.
     */
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

        _ownerToEventMap[msg.sender].push(address(eventContract));
        return true;
    }

    /**
     * @notice Function to buy a ticket from an Event contract.
     * @param event_ Event contract address.
     * @param amount Amount of tickets to buy.
     * @return bool status of ticket purchase.
     */
    function buy(address event_, uint256 amount) external payable override returns (bool) {
        Event eventContract = Event(event_);
        bool success = eventContract.buy{value: msg.value}(amount, msg.sender);
        require(success);
        _userToEventMap[msg.sender].push(event_);
        return success;
    }

    /**
     * @notice Function to validate a ticket in Event contract.
     * @param event_ Event contract address.
     * @param tokenId Token Id of the event ticket.
     * @param claimer Claimer of the event ticket.
     * @return bool status of event closure.
     */
    function validate(
        address event_,
        uint256 tokenId,
        address claimer
    ) external override returns (bool) {
        if (_eventMap[event_].status == EventStatus.ARCHIVED) {
            revert EventAlreadyArchived();
        }
        Event eventContract = Event(event_);
        if (msg.sender != eventContract.creator()) {
            revert CallerNotCreator();
        }
        bool success = eventContract.validate(tokenId, claimer);
        require(success);
        return success;
    }

    /**
     * @notice Function to close an Event contract.
     * @dev Closing the event transfer the commission to the EventFactory contract and the remaining to the creator/owner of the event.
     * @param event_ Event contract address.
     * @return bool status of event closure.
     */
    function close(address event_) external override nonReentrant returns (bool) {
        if (_eventMap[event_].status == EventStatus.ARCHIVED) {
            revert EventAlreadyArchived();
        }
        Event eventContract = Event(event_);
        if (msg.sender != eventContract.creator()) {
            revert CallerNotCreator();
        }
        bool success = eventContract.close();
        require(success);
        _archiveEvent(event_);
        return success;
    }

    /**
     * @notice Function to let owner withdraw balance on contract.
     */
    function withdraw() external override onlyOwner nonReentrant returns (bool) {
        (bool success, ) = owner().call{value: address(this).balance}("");
        return success;
    }

    /**
     * @notice Function to return events details.
     */
    function getEventDetails(
        address event_
    )
        external
        view
        override
        returns (
            string memory name,
            string memory description,
            string memory imageUrl,
            string memory dateTime,
            string memory location,
            uint256 price,
            uint256 availableTickets
        )
    {
        Event eventContract = Event(event_);
        return eventContract.getContractDetails();
    }

    /**
     * @notice Function to return list of current events.
     * @return currentEvents Array of current Event contract addresses.
     */
    function getCurrentEvents() external view override returns (address[] memory) {
        return _currentEvents;
    }

    /**
     * @notice Function to return list of archived events.
     * @dev Archived events are events that are closed by the Event contract owner.
     * @return archivedEvents Array of archived Event contract addresses.
     */
    function getArchivedEvents() external view override returns (address[] memory) {
        return _archivedEvents;
    }

    /**
     * @notice Function to get events created by a user.
     * @param owner Address of the creator of events.
     * @return events Array of Event contract addresses of tickets owned by the user.
     */
    function getCreatedEvents(address owner) external view override returns (address[] memory) {
        return _ownerToEventMap[owner];
    }

    /**
     * @notice Function to get events created by a user.
     * @param user Address of the user for which tickets are to be retreived.
     * @return events Array of Event contract addresses created by the user.
     */
    function getOwnedTicketEvents(address user) external view override returns (address[] memory) {
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
