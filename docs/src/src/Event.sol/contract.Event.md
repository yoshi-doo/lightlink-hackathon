# Event
[Git Source](https://github.com/yoshi-doo/lightlink-hackathon/blob/8e3de41f527665a7787fa05479af63ea2982017a/src/Event.sol)

**Inherits:**
[IEvent](/src/interfaces/IEvent.sol/interface.IEvent.md), Ownable, ReentrancyGuard, ContractMetadataLogic, ERC721URIStorage


## State Variables
### eventDetails

```solidity
EventDetails public eventDetails;
```


### _tokenIds

```solidity
Counters.Counter private _tokenIds;
```


### _maxAllowedTicketsPerUser

```solidity
uint256 private _maxAllowedTicketsPerUser;
```


### isSoldOut

```solidity
bool public isSoldOut = false;
```


### isClosed

```solidity
bool public isClosed = false;
```


### creator

```solidity
address public creator;
```


### commissionPercentage

```solidity
uint8 public commissionPercentage = 5;
```


### isValidated

```solidity
mapping(uint256 => bool) public isValidated;
```


## Functions
### constructor


```solidity
constructor(
    address creator_,
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
) ERC721(name, symbol);
```

### buy


```solidity
function buy(uint256 amount, address buyer) external payable override onlyOwner returns (bool);
```

### validate


```solidity
function validate(uint256 tokenId, address claimer) external override onlyOwner returns (bool);
```

### close


```solidity
function close() external override onlyOwner nonReentrant returns (bool);
```

### getContractDetails


```solidity
function getContractDetails()
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

### tokenURI


```solidity
function tokenURI(uint256 tokenId) public view virtual override returns (string memory);
```

### _buildContractURI


```solidity
function _buildContractURI() internal view returns (string memory);
```

### _canSetOwner


```solidity
function _canSetOwner() internal view virtual override returns (bool);
```

### _canSetContractURI


```solidity
function _canSetContractURI() internal view virtual override returns (bool);
```

## Events
### TicketBought

```solidity
event TicketBought(address user, uint256 tokenId);
```

### TicketValidated

```solidity
event TicketValidated(uint256 tokenId);
```

