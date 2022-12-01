# Ticket

## Base

1. ITicket
2. EVT
3. ERC721Enumerable
4. Pausable

## Deploy

| param            | type      | note                                  |
| ---------------- | --------- | ------------------------------------- |
| name\_           | string    | token ticket name                     |
| symbol\_         | string    | token ticket symbol                   |
| properties       | string[]  | EVT property Names                    |
| encryptedKeyIDs  | bytes32[] | EVT encryptionKeyID                   |
| baseURI\_        | string    | point to the EVT offchain data        |
| movieAddr\_      | address   | movie contract address                |
| duration\_ | uint256   | valid duration of the ticket (second) |

## Functions

```
pause()
unpause()
updateBaseURI(string baseURI_)
updateDuration(uint256 duration_)
updatePayee(address payee_)
getPayee()
withdraw()
safeMint(address to, uint256 amount, uint256 tokenId)
checkTicket(uint256 ticketId)
commonInfo()
ticketInfo(uint256 ticketId)
movieAddr()
duration()
```

## Events

```
BaseURIUpdate(string baseURI);
DurationUpdate(uint256 duration);
PayeeUpdate(address payee);
EventCreateTicket(uint256 indexed ticketId);
EventTicketCheck(uint256 indexed ticketId, uint256 checkingTime);
```

## Function

### pause()

Pause contract.

Requirements:

- onlyOwner

### unpause()

Restart contract.

Requirements:

- onlyOwner

### updateBaseURI(string baseURI\_)

Update `baseURI`.

Requirements:

- onlyOwner

### updateDuration(uint256 duration)

Update `duration`.

Requirements:

- onlyOwner

### updatePayee(uint256 payee\_)

Update `payee`.

Requirements:

- onlyOwner

### getPayee() -> address

Returns the payee address.

### withdraw()

Withdraw the balance to the payee.

Requirements:

- owner or payee

### safeMint(address to, uint256 amount, uint256 tokenId)

Batch mint ticket EVT by `tokenId`.

Requirements:

- must own `tokenId` EVT

### checkTicket(uint256 ticketId)

Have tickets checked and write the check-in time.

Requirements:

- `ticketId` must exist
- must own `ticketId` EVT
- timestamp greater than `startTime`
- timestamp less than `endTime`
- ticket has not expired

### commonInfo() -> address, uint256, uint256, uint256, string

Returns `movieAddr`, `startTime`, `endTime`, `duration`, `baseURI`.

### ticketInfo(uint256 ticketId) -> address, uint256, uint256, uint256, string, uint256

Returns `movieAddr`, `startTime`, `endTime`, `duration`, `baseURI`, `checkingTime`.

Requirements:

- if there is no check-in, the `checkingTime` is 0.

### movieAddr() -> address

Returns `movieAddr`,movie contract address.

### duration() -> uint256

Returns `duration`,valid duration of the ticket (second).

## Event

### BaseURIUpdate(string baseURI)

Emitted when `baseURI` is updated.

### DurationUpdate(uint256 duration)

Emitted when `duration` is updated.

### PayeeUpdate(address payee)

Emitted when `payee` is updated.

### EventCreateTicket(uint256 indexed ticketId)

Emitted when `ticketId` EVT is created.

### EventTicketCheck(uint256 indexed ticketId, uint256 checkingTime)

Emitted when `ticketId` have checked for the first time.
