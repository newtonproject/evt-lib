# Ticket

## Base

1. ITicket
2. EVT
3. ERC721Enumerable
4. Pausable

## Deploy

| param            | type      | note                              |
| ---------------- | --------- | --------------------------------- |
| name\_           | string    | token collection name             |
| symbol\_         | string    | token collection symbol           |
| properties       | string[]  | EVT property Names                |
| encryptedKeyIDs  | bytes32[] | EVT encryptionKeyID               |
| baseURI\_        | string    | point to the EVT offchain data    |
| movieAddr\_      | address   | movie contract address            |
| startTime\_      | uint256   | film release date (second)        |
| endTime\_        | uint256   | film off the screen date (second) |
| ticketDuration\_ | uint256   | valid duration of the ticket      |

## Functions

```
pause()
unpause()
updateBaseURI(string baseURI_)
updateStartTime(uint256 startTime_)
updateEndTime(uint256 _endTime)
updateTicketDuration(uint256 ticketDuration_)
updatePayee(address payee_)
getPayee()
withdraw()
safeMint(address to, uint256 amount, uint256 movieId)
checkTicket(uint256 ticketId)
commonInfo()
ticketInfo(uint256 ticketId)
movieAddr()
startTime()
endTime()
ticketDuration()
```

## Events

```
BaseURIUpdate(string baseURI);
StartTimeUpdate(uint256 startTime);
EndTimeUpdate(uint256 endTime);
TicketDurationUpdate(uint256 ticketDuration);
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

### updateStartTime(uint256 startTime\_)

Update `startTime`.

Requirements:

- onlyOwner
- second

### updateEndTime(uint256 endTime\_)

Update `endTime`.

Requirements:

- onlyOwner
- second

### updateTicketDuration(uint256 ticketDuration)

Update `ticketDuration`.

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

### safeMint(address to, uint256 amount, uint256 movieId)

Batch mints ticket EVT.

Requirements:

- must own `movieId` EVT

### checkTicket(uint256 ticketId)

Have tickets checked and write the check-in time.

Requirements:

- `movieId` must exist
- must own `ticketId` EVT
- timestamp greater than `startTime`
- timestamp less than `endTime`
- ticket has not expired

### commonInfo() -> address, uint256, uint256, uint256, string
Returns `movieAddr`, `startTime`, `endTime`, `ticketDuration`, `baseURI`.

### ticketInfo(uint256 ticketId) -> address, uint256, uint256, uint256, string, uint256
Returns `movieAddr`, `startTime`, `endTime`, `ticketDuration`, `baseURI`, `checkingTime`.

Requirements:

- if there is no check-in, the `checkingTime` is 0.
