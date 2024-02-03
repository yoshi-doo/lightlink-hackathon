# IEvent
[Git Source](https://github.com/yoshi-doo/lightlink-hackathon/blob/8e3de41f527665a7787fa05479af63ea2982017a/src/interfaces/IEvent.sol)


## Functions
### buy


```solidity
function buy(uint256 amount, address buyer) external payable returns (bool);
```

### validate


```solidity
function validate(uint256 tokenId, address owner) external returns (bool);
```

### close


```solidity
function close() external returns (bool);
```

### getContractDetails


```solidity
function getContractDetails()
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

## Structs
### EventDetails

```solidity
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
```

