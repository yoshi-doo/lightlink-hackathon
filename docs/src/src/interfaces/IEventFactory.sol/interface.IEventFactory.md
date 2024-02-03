# IEventFactory
[Git Source](https://github.com/yoshi-doo/lightlink-hackathon/blob/8e3de41f527665a7787fa05479af63ea2982017a/src/interfaces/IEventFactory.sol)


## Functions
### receive


```solidity
receive() external payable;
```

### create


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
) external payable returns (bool);
```

### close


```solidity
function close(address event_) external returns (bool);
```

### withdraw


```solidity
function withdraw() external returns (bool);
```

### buy


```solidity
function buy(address event_, uint256 amount) external payable returns (bool);
```

### validate


```solidity
function validate(address event_, uint256 tokenId, address claimer) external returns (bool);
```

### getEventDetails


```solidity
function getEventDetails(address event_)
    external
    view
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


```solidity
function getCurrentEvents() external view returns (address[] memory);
```

### getArchivedEvents


```solidity
function getArchivedEvents() external view returns (address[] memory);
```

### getCreatedEvents


```solidity
function getCreatedEvents(address owner) external view returns (address[] memory);
```

### getOwnedTicketEvents


```solidity
function getOwnedTicketEvents(address user) external view returns (address[] memory);
```

## Structs
### EventDetails

```solidity
struct EventDetails {
    EventStatus status;
    uint256 index;
}
```

## Enums
### EventStatus

```solidity
enum EventStatus {
    CURRENT,
    ARCHIVED
}
```

