# DEventify

DEventify is a decentralized application template powered by [Forward protocol](https://forwardprotocol.io/) designed to empower users to create their own event ticketing platforms on the blockchain. By providing a seamless and secure solution, DEventify enables users to deploy and generate revenue by charging listing fees and commissions from event organizers. The DApp template to use and deploy can be found at https://forwardfactory.net/services/marketplace with the name `EventFactory`.

## Problem Statement:
Conventional ticketing systems often lack transparency, introduce the risk of errors, and suffer from scalability issues due to a single point of failure. This results in fraudulent activities and compromises the overall user experience. Blockchain based DApps can solve most of the problems related to current ticketing system but deploying blockchain based applications is still a challenge as it requires niche expertise and a long learning curve. Also users face a problems while interacting with a DApp because of the associated gas fees.

## Features and Functionality:
Ease of deployment: Provide template which gives a no code solution for deploying a DApp seamlessly.
Gassless transaction: LightLinks enterprise mode to have gasless transaction out of the box for users (through whitelisting on testnet).
Event Organizer Empowerment: Event organizers can easily create new event campaigns and issue tickets on the blockchain by providing a listing fee and commission to the platform.
Blockchain-Backed Tickets: Tickets issued on the platform are unique Non-Fungible Tokens (NFTs) on the blockchain, ensuring their authenticity and security.
User Ticket Validation: Organizers can verify and validate tickets seamlessly, enhancing the overall event management process.
User Ticket Purchase: Users can conveniently purchase tickets as NFTs. After successful validation, the NFT is converted into a collectible for the user.
Every event created is an individual ERC721 contract that is controlled by the event organizer, all issuing and validation is inbuilt in the Event contract.

## Technologies Used:
Solidity smart contracts, LightLink Pegasus Testnet, Forward Protocol Blockscout explorer and API.

## Template Dashboard:
After deploying the template below dashboard is provided to interact with the smart contract.
<img width="1188" alt="Screenshot 2024-02-04 at 19 52 22" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/179e3109-859c-4d26-ba5c-0df0cb5a562e">

### Buyer Panel
Functionalities of potential ticket buyer.

| Syntax      | Description |
| ----------- | ----------- |
|Get listed Events address|Return list of current events address.|
|Get Event details|Returns Event details (metadata) like name, description, location, date_time etc.|
|Buy Event ticket|Buy event ticket by passing event address and amount of tickets to buy. User has to pass the price of the ticket in value.
The price of the ticket is collected on the Event contract.|
|Get purchased Event ticket address|Returns all event addresses of purchased tickets.|


### Creator Panel
Functionalities for event organizers or creators.
| Syntax      | Description |
| ----------- | ----------- |
|Get created Events|Get events created by passed addresss.|
|Get listing Fee|Get listing fee in wei for listin an event on the platform.|
|Create and list new Event|Create a new event by passing all the required metadata, price and amount.|
|Validate user ticket|As an event creator validate/verify ticket of user by passing the event address and token id|
|Close an Event contract|Closes the sale of an Event, transfers the commission to the Event platform and the remaining balance of the event contract to the creator of the event. |

Detailed documentation for the contract methods can be found here https://github.com/yoshi-doo/lightlink-hackathon/blob/main/docs/src/src/EventFactory.sol/contract.EventFactory.md.
Contract deployed for the demo can be viewd at https://pegasus.lightlink.io/address/0xca064e047840136d1E98d566c1290dA4c8a0f0B7

## Supplementary React Frontend:
For better visualization, the template contract can also be connected to an external react frontend developed as part of the hackathon.
The repository for it can be found here https://github.com/yoshi-doo/lightlink-hack-frontend. It can be deployed as on ipfs or a dedicated server.
Here is the version connected to the contract developed as part of the hackathon https://lightlink-hack-frontend.vercel.app/

Below are some screen shots from the react frontend for the ticketing application.
|Page|Screen shot|
| ----------- | ----------- |
|Dashboard|<img width="1506" alt="Screenshot 2024-02-04 at 21 07 29" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/3c106361-43b4-4743-a808-5f0820e10882">|
|My Tickets|<img width="1501" alt="Screenshot 2024-02-04 at 21 12 48" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/fc49adff-1fcb-4965-abef-57648b2eae8f">|
|Buy Ticket|<img width="1011" alt="Screenshot 2024-02-04 at 21 13 57" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/5adad5fd-86ab-436a-b29c-364c4921cc7f">|
|Create Event|<img width="1076" alt="Screenshot 2024-02-04 at 21 15 05" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/79e877ea-17a5-4fc6-a4aa-5a931ffbbd84">|
|My Events|<img width="1503" alt="Screenshot 2024-02-04 at 21 16 03" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/ccd15b82-2dcd-464d-af73-7f8e9a0440a1">|
|Validate ticket|<img width="984" alt="Screenshot 2024-02-04 at 21 17 05" src="https://github.com/yoshi-doo/lightlink-hackathon/assets/117723599/3de2d27f-77af-4cd5-8bdf-290bf41e5f70">|
