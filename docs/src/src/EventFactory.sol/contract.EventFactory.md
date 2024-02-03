# EventFactory
[Git Source](https://github.com/yoshi-doo/lightlink-hackathon/blob/8e3de41f527665a7787fa05479af63ea2982017a/src/EventFactory.sol)

**Inherits:**
[IEventFactory](/src/interfaces/IEventFactory.sol/interface.IEventFactory.md), Ownable, ReentrancyGuard

Each event is represented by an ERC721 contract and tickets correspond to ERC721 tokens.


## State Variables
### listingFee
Fee for listing an Event with the Event Factory.


```solidity
uint256 public listingFee;
```


### _MAX_TICKETS_PER_USER
Default for maximum allowed tickets per user.


```solidity
uint256 private constant _MAX_TICKETS_PER_USER = 2;
```


### _currentEvents
Array of contract addresses of current events.


```solidity
address[] private _currentEvents;
```


### _archivedEvents
Array of contract addresses of closed/archived events.

*A closed event is considered archived.*


```solidity
address[] private _archivedEvents;
```


### _eventMap
Mapping from event contract address to event details


```solidity
mapping(address => EventDetails) private _eventMap;
```


### _ownerToEventMap
Mapping from owner address to owned event contract addresses.


```solidity
mapping(address => address[]) private _ownerToEventMap;
```


### _userToEventMap
Mapping from ticket owner address to event contract addresses.


```solidity
mapping(address => address[]) private _userToEventMap;
```


## Functions
### constructor


```solidity
constructor(uint256 listingFee_);
```

### receive


```solidity
receive() external payable override;
```

### create

Function to create a new Event contract.

*listingFee amount should be passed in msg.value.*


```solidity
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
) external payable override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|Event name.|
|`symbol`|`string`|Event contract ERC721 symbol.|
|`description`|`string`|Event description.|
|`imageUrl`|`string`|Event image url.|
|`imageUrlValidated`|`string`|Event image url after validated.|
|`dateTime`|`string`|Event dateTime.|
|`location`|`string`|Event location.|
|`amount`|`uint256`|Event ticket amount to be minted.|
|`price`|`uint256`|Event ticket price.|
|`maxAllowedTicketsPerUser`|`uint256`|Maximum tickets allowed per user default is 2.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool Status of event creation.|


### buy

Function to buy a ticket from an Event contract.


```solidity
function buy(address event_, uint256 amount) external payable override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`event_`|`address`|Event contract address.|
|`amount`|`uint256`|Amount of tickets to buy.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool status of ticket purchase.|


### validate

Function to validate a ticket in Event contract.


```solidity
function validate(address event_, uint256 tokenId, address claimer) external override returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`event_`|`address`|Event contract address.|
|`tokenId`|`uint256`|Token Id of the event ticket.|
|`claimer`|`address`|Claimer of the event ticket.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool status of event closure.|


### close

Function to close an Event contract.

*Closing the event transfer the commission to the EventFactory contract and the remaining to the creator/owner of the event.*


```solidity
function close(address event_) external override nonReentrant returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`event_`|`address`|Event contract address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool status of event closure.|


### withdraw

Function to let owner withdraw balance on contract.


```solidity
function withdraw() external override onlyOwner nonReentrant returns (bool);
```

### getEventDetails

Function to return events details.


```solidity
function getEventDetails(address event_)
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
    );
```

### getCurrentEvents

Function to return list of current events.


```solidity
function getCurrentEvents() external view override returns (address[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|currentEvents Array of current Event contract addresses.|


### getArchivedEvents

Function to return list of archived events.

*Archived events are events that are closed by the Event contract owner.*


```solidity
function getArchivedEvents() external view override returns (address[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|archivedEvents Array of archived Event contract addresses.|


### getCreatedEvents

Function to get events created by a user.


```solidity
function getCreatedEvents(address owner) external view override returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`owner`|`address`|Address of the creator of events.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|events Array of Event contract addresses of tickets owned by the user.|


### getOwnedTicketEvents

Function to get events created by a user.


```solidity
function getOwnedTicketEvents(address user) external view override returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address of the user for which tickets are to be retreived.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|events Array of Event contract addresses created by the user.|


### _archiveEvent


```solidity
function _archiveEvent(address event_) internal;
```

### _canSetOwner


```solidity
function _canSetOwner() internal view virtual override returns (bool);
```

## Errors
### CallerNotCreator

```solidity
error CallerNotCreator();
```

### EventAlreadyArchived

```solidity
error EventAlreadyArchived();
```

