// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13 .0;

import {Ownable} from "@thirdweb-dev/contracts/extension/Ownable.sol";
import {ContractMetadataLogic} from "@thirdweb-dev/contracts/extension/plugin/ContractMetadataLogic.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

import {IEvent} from "./interfaces/IEvent.sol";

contract Event is IEvent, Ownable, ContractMetadataLogic, ERC721URIStorage {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using Strings for uint256;

    EventDetails public eventDetails;
    Counters.Counter private _tokenIds;

    uint256 private _maxAllowedTicketsPerUser;
    bool public isSoldOut = false;
    bool public isClosed = false;

    mapping(uint256 => bool) public isValidated;

    constructor(
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
    ) ERC721(name, symbol) {
        _setupOwner(msg.sender);
        eventDetails = EventDetails(
            name,
            description,
            imageUrl,
            imageUrlValidated,
            dateTime,
            location,
            price,
            amount
        );
        _setupContractURI(_buildContractURI());
        _maxAllowedTicketsPerUser = maxAllowedTicketsPerUser;
    }

    function buy(uint256 amount) external payable override returns (bool) {
        require(!isClosed, "Event is closed for sale");
        require(!isSoldOut, "Event is sold out");
        require(amount <= eventDetails.availableTickets, "Requested amount not available");
        require(
            (amount <= _maxAllowedTicketsPerUser) &&
                (ERC721.balanceOf(msg.sender) + amount <= _maxAllowedTicketsPerUser),
            "Exceeds max ticket purchase amount"
        );
        require(msg.value == eventDetails.price * amount, "Passed payment value is invalid");

        for (uint256 index = 0; index < amount; index++) {
            _tokenIds.increment();
            uint256 tokenId = _tokenIds.current();
            _safeMint(msg.sender, tokenId);
        }
        eventDetails.availableTickets = eventDetails.availableTickets.sub(amount);
        if (eventDetails.availableTickets == 0) {
            isSoldOut = true;
        }
        return true;
    }

    function validate(uint256 tokenId, address claimer) external override onlyOwner returns (bool) {
        require(isValidated[tokenId] != true, "Ticket is already validated");
        require(ERC721.ownerOf(tokenId) == claimer, "Claimer is not the owner");
        isValidated[tokenId] = true;
        return true;
    }

    function close() external override onlyOwner returns (bool) {
        uint256 amount = address(this).balance;
        require(amount > 0, "Contract balance is 0");

        address _owner = owner();
        (bool success, ) = _owner.call{value: amount}("");
        return success;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        string memory imageUrl = eventDetails.imageUrl;
        string memory isTokenValidated = "false";
        if (isValidated[tokenId]) {
            isTokenValidated = "true";
            imageUrl = eventDetails.imageUrlValidated;
        }
        string memory json = string(
            abi.encodePacked(
                '{"name": "',
                eventDetails.name,
                '", "description": "',
                eventDetails.description,
                '", "image": "',
                imageUrl,
                '", "attributes": [{"trait_type": "date_time", "value": "',
                eventDetails.dateTime,
                '"}, {"trait_type": "location", "value": "',
                eventDetails.location,
                '"}, {"trait_type": "price", "value": "',
                eventDetails.price.toString(),
                '"}, {"trait_type": "token_id", "value": "',
                tokenId.toString(),
                '"}, {"trait_type": "is_validated", "value": ',
                isTokenValidated,
                "}]}"
            )
        );
        return string.concat("data:application/json;utf8,", json);
    }

    function _buildContractURI() internal view returns (string memory) {
        string memory json = string(
            abi.encodePacked(
                '{"name": "',
                eventDetails.name,
                '", "description": "',
                eventDetails.description,
                '", "image": "',
                eventDetails.imageUrl,
                '", "attributes": [{"trait_type": "date_time", "value": "',
                eventDetails.dateTime,
                '"}, {"trait_type": "location", "value": "',
                eventDetails.location,
                '"}, {"trait_type": "price", "value": "',
                eventDetails.price.toString(),
                '"}]}'
            )
        );
        return string.concat("data:application/json;utf8,", json);
    }

    function _canSetOwner() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }

    function _canSetContractURI() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }
}
